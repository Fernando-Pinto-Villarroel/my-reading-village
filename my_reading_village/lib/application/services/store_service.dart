import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:my_reading_village/domain/rules/store_rules.dart';
import 'package:my_reading_village/domain/rules/species_rules.dart';
import 'package:my_reading_village/domain/ports/village_repository.dart';
import 'package:my_reading_village/domain/ports/inventory_repository.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/analytics_service.dart';

enum StorePurchaseState { idle, pending, success, error, cancelled }

class StorePurchaseResult {
  final StorePurchaseState state;
  final String? errorMessage;

  const StorePurchaseResult({required this.state, this.errorMessage});
}

class StoreService extends ChangeNotifier {
  final VillageRepository _villageRepo;
  final InventoryRepository _invRepo;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  StoreService(this._villageRepo, this._invRepo);

  bool _available = false;
  bool _initialized = false;

  StorePurchaseState _purchaseState = StorePurchaseState.idle;
  final List<String> _grantedProductIds = [];

  bool get available => _available;
  bool get initialized => _initialized;
  StorePurchaseState get purchaseState => _purchaseState;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!AppConstants.playStore) {
      _available = true;
      _initialized = true;
      notifyListeners();
      return;
    }

    _available = await _iap.isAvailable();
    if (!_available) {
      _initialized = true;
      notifyListeners();
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (_) {
        _purchaseState = StorePurchaseState.error;
        notifyListeners();
      },
    );

    _initialized = true;
    notifyListeners();
  }

  List<String> consumeGrantedProductIds() {
    final ids = List<String>.from(_grantedProductIds);
    _grantedProductIds.clear();
    return ids;
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        _purchaseState = StorePurchaseState.pending;
        notifyListeners();
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _grantAndAcknowledge(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        _purchaseState = StorePurchaseState.error;
        notifyListeners();
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        _purchaseState = StorePurchaseState.cancelled;
        notifyListeners();
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<void> _grantAndAcknowledge(PurchaseDetails purchase) async {
    try {
      final productId = purchase.productID;
      final isSpecies = productId.startsWith('species_');
      final purchaseKey =
          purchase.purchaseID ?? '${productId}_${purchase.transactionDate ?? ''}';
      final alreadyProcessed =
          !isSpecies && await _villageRepo.isPurchaseProcessed(purchaseKey);
      if (!alreadyProcessed) {
        await _grantEntitlement(productId);
        if (!isSpecies) {
          await _villageRepo.markPurchaseProcessed(purchaseKey);
        }
        _grantedProductIds.add(productId);
        sl<AnalyticsService>().logIapPurchase(productId);
        sl<AnalyticsService>().updateUserProperties(hasMadeIap: true);
      }
      _purchaseState = StorePurchaseState.success;
      notifyListeners();
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    } catch (_) {
      _purchaseState = StorePurchaseState.error;
      notifyListeners();
    }
  }

  Future<void> _grantEntitlement(String productId) async {
    final gemsItem =
        StoreRules.gemsItems.where((i) => i.productId == productId).firstOrNull;
    if (gemsItem != null) {
      await _villageRepo.addResources(gems: gemsItem.gems);
      return;
    }

    final pack =
        StoreRules.packs.where((p) => p.productId == productId).firstOrNull;
    if (pack != null) {
      await _villageRepo.addResources(
          coins: pack.coins, wood: pack.wood, metal: pack.metal, gems: pack.gems);
      if (pack.bookPowerups > 0) {
        await _invRepo.addInventoryItem('book', amount: pack.bookPowerups);
      }
      if (pack.sandwichPowerups > 0) {
        await _invRepo.addInventoryItem('sandwich', amount: pack.sandwichPowerups);
      }
      if (pack.hammerPowerups > 0) {
        await _invRepo.addInventoryItem('hammer', amount: pack.hammerPowerups);
      }
      if (pack.glassesPowerups > 0) {
        await _invRepo.addInventoryItem('glasses', amount: pack.glassesPowerups);
      }
      if (pack.speciesId != null) {
        await _villageRepo.unlockSpecies(pack.speciesId!, isPurchased: false);
      }
      return;
    }

    if (productId.startsWith('species_')) {
      final speciesId = productId.substring('species_'.length);
      await _villageRepo.unlockSpecies(speciesId, isPurchased: true);
    }
  }

  Future<StorePurchaseResult> purchaseGems(StoreGemsItem item) async {
    if (!AppConstants.playStore) {
      return const StorePurchaseResult(state: StorePurchaseState.success);
    }
    return _launchPurchase(item.productId);
  }

  Future<StorePurchaseResult> purchasePack(StorePack pack) async {
    if (!AppConstants.playStore) {
      return const StorePurchaseResult(state: StorePurchaseState.success);
    }
    return _launchPurchase(pack.productId);
  }

  Future<StorePurchaseResult> purchaseSpecies(String productId) async {
    if (!AppConstants.playStore) {
      return const StorePurchaseResult(state: StorePurchaseState.success);
    }
    return _launchPurchase(productId);
  }

  Future<StorePurchaseResult> _launchPurchase(String productId) async {
    if (!_available) {
      return const StorePurchaseResult(
        state: StorePurchaseState.error,
        errorMessage: 'Store not available',
      );
    }

    final response = await _iap.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return const StorePurchaseResult(
        state: StorePurchaseState.error,
        errorMessage: 'Product not found',
      );
    }

    final purchaseParam = PurchaseParam(
      productDetails: response.productDetails.first,
    );

    _purchaseState = StorePurchaseState.pending;
    notifyListeners();

    try {
      final isSpecies = productId.startsWith('species_') ||
          SpeciesRules.allSpecies.any((s) => SpeciesRules.productIdForSpecies(s.id) == productId);
      if (isSpecies) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyConsumable(purchaseParam: purchaseParam);
      }
      return const StorePurchaseResult(state: StorePurchaseState.pending);
    } catch (e) {
      _purchaseState = StorePurchaseState.error;
      notifyListeners();
      return StorePurchaseResult(
        state: StorePurchaseState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    _purchaseState = StorePurchaseState.pending;
    notifyListeners();
    await _iap.restorePurchases();
  }

  Future<bool> restoreAndCollectResults() async {
    if (!_available) return false;
    resetState();

    bool anyRestored = false;
    final completer = Completer<void>();
    Timer? idleTimer;

    void scheduleComplete() {
      idleTimer?.cancel();
      idleTimer = Timer(const Duration(seconds: 5), () {
        if (!completer.isCompleted) completer.complete();
      });
    }

    void onUpdate() {
      if (_purchaseState == StorePurchaseState.success) {
        final ids = consumeGrantedProductIds();
        if (ids.isNotEmpty) anyRestored = true;
        scheduleComplete();
      } else if (_purchaseState == StorePurchaseState.error) {
        if (!completer.isCompleted) completer.complete();
      }
    }

    addListener(onUpdate);
    try {
      await _iap.restorePurchases();
      scheduleComplete();
      await completer.future
          .timeout(const Duration(seconds: 30), onTimeout: () {});
    } finally {
      idleTimer?.cancel();
      removeListener(onUpdate);
      resetState();
    }
    return anyRestored;
  }

  void resetState() {
    _purchaseState = StorePurchaseState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
