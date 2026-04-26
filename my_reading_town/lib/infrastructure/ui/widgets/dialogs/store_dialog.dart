import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_town/app_constants.dart';
import 'package:my_reading_town/domain/rules/store_rules.dart';
import 'package:my_reading_town/domain/rules/species_rules.dart';
import 'package:my_reading_town/application/services/ad_service.dart';
import 'package:my_reading_town/application/services/store_service.dart';
import 'package:my_reading_town/adapters/providers/village_provider.dart';
import 'package:my_reading_town/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_town/infrastructure/di/service_locator.dart';
import 'package:my_reading_town/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/app_toast.dart';

void showStoreDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _StoreDialog(),
  );
}

class _StoreDialog extends StatefulWidget {
  @override
  State<_StoreDialog> createState() => _StoreDialogState();
}

class _StoreDialogState extends State<_StoreDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, DiscountInfo> _discounts;
  late StoreService _storeService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _discounts = StoreRules.computeDiscounts();
    _storeService = StoreService();
    _storeService.initialize();
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final village = context.read<VillageProvider>();
    final index = _tabController.index;
    if (index == 2) {
      village.markStoreFreeGemsSeen();
      village.markStoreDiscountSeen();
    } else if (index == 3 || index == 4) {
      village.markStoreDiscountSeen();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _storeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final dialogWidth =
        isLandscape ? screenSize.width * 0.75 : screenSize.width * 0.92;
    final dialogHeight =
        isLandscape ? screenSize.height * 0.88 : screenSize.height * 0.82;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppTheme.cream,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 40 : 16,
        vertical: isLandscape ? 16 : 32,
      ),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            _StoreHeader(lang: lang),
            _StoreTabBar(
              controller: _tabController,
              lang: lang,
              discounts: _discounts,
            ),
            Consumer<VillageProvider>(
              builder: (_, village, __) =>
                  _GemBalanceBar(gems: village.gems, lang: lang),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _ResourcesTab(lang: lang),
                  _PowerupsTab(lang: lang),
                  _GemsTab(
                      lang: lang,
                      discounts: _discounts,
                      storeService: _storeService),
                  _PacksTab(
                      lang: lang,
                      discounts: _discounts,
                      storeService: _storeService),
                  _SpeciesTab(lang: lang, storeService: _storeService, discounts: _discounts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final LanguageProvider lang;

  const _StoreHeader({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.pink, AppTheme.lavender],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              lang.translate('store_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _StoreTabBar extends StatefulWidget {
  final TabController controller;
  final LanguageProvider lang;
  final Map<String, DiscountInfo> discounts;

  const _StoreTabBar({
    required this.controller,
    required this.lang,
    required this.discounts,
  });

  @override
  State<_StoreTabBar> createState() => _StoreTabBarState();
}

class _StoreTabBarState extends State<_StoreTabBar> {
  bool get _hasDiscounts => widget.discounts.isNotEmpty;

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tab(Widget icon, String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 82, maxWidth: 82),
      child: Tab(icon: icon, text: text),
    );
  }

  List<Widget> _buildTabs(bool fill) {
    Widget tab(Widget icon, String text) {
      if (fill) return Tab(icon: icon, text: text);
      return _tab(icon, text);
    }

    return [
      tab(
        const Icon(Icons.inventory_2, size: 18),
        widget.lang.translate('store_tab_resources'),
      ),
      tab(
        const Icon(Icons.auto_awesome, size: 18),
        widget.lang.translate('store_tab_powerups'),
      ),
      tab(
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.diamond, size: 18),
            if (_hasDiscounts)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('%',
                      style: TextStyle(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        widget.lang.translate('store_tab_gems'),
      ),
      tab(
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.card_giftcard, size: 18),
            if (_hasDiscounts)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('%',
                      style: TextStyle(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        widget.lang.translate('store_tab_packs'),
      ),
      tab(
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.pets, size: 18),
            if (_hasDiscounts)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('%',
                      style: TextStyle(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        widget.lang.translate('store_tab_species'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const tabCount = 5;
    const minTabWidth = 82.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fill = constraints.maxWidth >= tabCount * minTabWidth;
        final tabBar = TabBar(
          controller: widget.controller,
          isScrollable: !fill,
          tabAlignment: fill ? TabAlignment.fill : TabAlignment.start,
          indicatorColor: AppTheme.darkPink,
          indicatorWeight: 3,
          labelColor: AppTheme.darkPink,
          unselectedLabelColor: AppTheme.darkText.withValues(alpha: 0.5),
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          tabs: _buildTabs(fill),
        );
        return Container(
          color: AppTheme.softWhite,
          child: fill
              ? tabBar
              : Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: tabBar,
                ),
        );
      },
    );
  }
}

class _ResourcesTab extends StatelessWidget {
  final LanguageProvider lang;

  const _ResourcesTab({required this.lang});

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            icon: ResourceIcon.coin(size: 18),
            text: lang.translate('coins'),
            color: AppTheme.mediumOrange,
          ),
          SizedBox(height: 8),
          _ResourceGrid(
            items: StoreRules.coinItems,
            village: village,
            lang: lang,
          ),
          SizedBox(height: 16),
          _SectionLabel(
            icon: ResourceIcon.wood(size: 18),
            text: lang.translate('wood'),
            color: AppTheme.darkOrange,
          ),
          SizedBox(height: 8),
          _ResourceGrid(
            items: StoreRules.woodItems,
            village: village,
            lang: lang,
          ),
          SizedBox(height: 16),
          _SectionLabel(
            icon: ResourceIcon.metal(size: 18),
            text: lang.translate('metal'),
            color: Colors.blueGrey,
          ),
          SizedBox(height: 8),
          _ResourceGrid(
            items: StoreRules.metalItems,
            village: village,
            lang: lang,
          ),
        ],
      ),
    );
  }
}

class _ResourceGrid extends StatelessWidget {
  final List<StoreResourceItem> items;
  final VillageProvider village;
  final LanguageProvider lang;

  const _ResourceGrid({
    required this.items,
    required this.village,
    required this.lang,
  });

  Widget _iconFor(ResourceType type, double size) {
    switch (type) {
      case ResourceType.coins:
        return ResourceIcon.coin(size: size);
      case ResourceType.wood:
        return ResourceIcon.wood(size: size);
      case ResourceType.metal:
        return ResourceIcon.metal(size: size);
    }
  }

  Color _colorFor(ResourceType type) {
    switch (type) {
      case ResourceType.coins:
        return AppTheme.coinGold;
      case ResourceType.wood:
        return AppTheme.mediumOrange;
      case ResourceType.metal:
        return Colors.blueGrey.shade300;
    }
  }

  Future<void> _buy(BuildContext context, StoreResourceItem item) async {
    if (village.gems < item.gemCost) {
      _showNotEnoughGems(context, lang);
      return;
    }

    final confirmed = await _showGemConfirmDialog(context, lang, item.gemCost);
    if (!confirmed || !context.mounted) return;

    switch (item.resource) {
      case ResourceType.coins:
        await village.addResources(gems: -item.gemCost, coins: item.amount);
        break;
      case ResourceType.wood:
        await village.addResources(gems: -item.gemCost, wood: item.amount);
        break;
      case ResourceType.metal:
        await village.addResources(gems: -item.gemCost, metal: item.amount);
        break;
    }

    if (context.mounted) {
      _showPurchaseSuccess(context, lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: items.map((item) {
        final canAfford = village.gems >= item.gemCost;
        final color = _colorFor(item.resource);
        return _StoreCard(
          topColor: color.withValues(alpha: 0.2),
          borderColor: color,
          onTap: () => _buy(context, item),
          canAfford: canAfford,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconFor(item.resource, 50),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '+${item.amount}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ResourceIcon.gem(size: 18),
                      SizedBox(width: 3),
                      Text(
                        '${item.gemCost}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              canAfford ? AppTheme.darkLavender : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PowerupsTab extends StatelessWidget {
  final LanguageProvider lang;

  const _PowerupsTab({required this.lang});

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PowerupSection(
            assetPath: 'assets/images/items/book_item.png',
            labelKey: 'happiness_book',
            descKey: 'happiness_book_desc',
            items: StoreRules.bookItems,
            color: AppTheme.pink,
            village: village,
            lang: lang,
          ),
          SizedBox(height: 16),
          _PowerupSection(
            assetPath: 'assets/images/items/sandwich_item.png',
            labelKey: 'constructor_sandwich',
            descKey: 'sandwich_desc',
            items: StoreRules.sandwichItems,
            color: AppTheme.mediumOrange,
            village: village,
            lang: lang,
          ),
          SizedBox(height: 16),
          _PowerupSection(
            assetPath: 'assets/images/items/hammer_item.png',
            labelKey: 'constructor_hammer',
            descKey: 'hammer_desc',
            items: StoreRules.hammerItems,
            color: AppTheme.darkSkyBlue,
            village: village,
            lang: lang,
          ),
          SizedBox(height: 16),
          _PowerupSection(
            assetPath: 'assets/images/items/glasses_item.png',
            labelKey: 'magic_glasses',
            descKey: 'glasses_desc',
            items: StoreRules.glassesItems,
            color: AppTheme.darkMint,
            village: village,
            lang: lang,
          ),
        ],
      ),
    );
  }
}

class _PowerupSection extends StatelessWidget {
  final String assetPath;
  final String labelKey;
  final String descKey;
  final List<StorePowerupItem> items;
  final Color color;
  final VillageProvider village;
  final LanguageProvider lang;

  const _PowerupSection({
    required this.assetPath,
    required this.labelKey,
    required this.descKey,
    required this.items,
    required this.color,
    required this.village,
    required this.lang,
  });

  Future<void> _buy(BuildContext context, StorePowerupItem item) async {
    if (village.gems < item.gemCost) {
      _showNotEnoughGems(context, lang);
      return;
    }

    final confirmed = await _showGemConfirmDialog(context, lang, item.gemCost);
    if (!confirmed || !context.mounted) return;

    await village.addResources(gems: -item.gemCost);
    final inventoryType = StoreRules.inventoryTypeForPowerup(item.powerup);
    await village.addItemToInventory(inventoryType, amount: item.quantity);

    if (context.mounted) {
      _showPurchaseSuccess(context, lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 24, height: 24),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.translate(labelKey),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    lang.translate(descKey),
                    style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.darkText.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: items.map((item) {
            final canAfford = village.gems >= item.gemCost;
            return _StoreCard(
              topColor: color.withValues(alpha: 0.15),
              borderColor: color,
              onTap: () => _buy(context, item),
              canAfford: canAfford,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(assetPath, width: 50, height: 50),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ResourceIcon.gem(size: 18),
                          SizedBox(width: 3),
                          Text(
                            '${item.gemCost}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: canAfford
                                  ? AppTheme.darkLavender
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _GemsTab extends StatefulWidget {
  final LanguageProvider lang;
  final Map<String, DiscountInfo> discounts;
  final StoreService storeService;

  const _GemsTab({
    required this.lang,
    required this.discounts,
    required this.storeService,
  });

  @override
  State<_GemsTab> createState() => _GemsTabState();
}

class _GemsTabState extends State<_GemsTab> {
  bool _watchingAdForGems = false;
  Timer? _adCooldownTimer;

  @override
  void dispose() {
    _adCooldownTimer?.cancel();
    super.dispose();
  }

  void _startAdCooldownTimer() {
    _adCooldownTimer?.cancel();
    _adCooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _adCooldownTimer?.cancel();
        return;
      }
      final village = context.read<VillageProvider>();
      final remaining = village.adCooldownRemainingFor('gems');
      if (remaining == null) {
        _adCooldownTimer?.cancel();
        _adCooldownTimer = null;
      }
      setState(() {});
    });
  }

  Future<void> _watchAdForGems() async {
    if (_watchingAdForGems) return;
    final village = context.read<VillageProvider>();
    if (village.adGemsClaimed) return;
    if (village.adCooldownRemainingFor('gems') != null) return;
    village.recordAdCooldown('gems');
    setState(() => _watchingAdForGems = true);
    final earned =
        await sl<AdService>().showRewardedAd(context, widget.lang);
    if (!mounted) return;
    if (earned) {
      final claimed = await village.watchAdForGems();
      if (mounted && claimed) {
        showSuccessToast(
            context, widget.lang.translate('ad_gems_received'));
      }
    }
    if (mounted) {
      setState(() => _watchingAdForGems = false);
      _startAdCooldownTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _AdForGemsSection(
            village: village,
            lang: widget.lang,
            onWatchAd: _watchAdForGems,
            isWatching: _watchingAdForGems,
            cooldown: village.adCooldownRemainingFor('gems'),
          ),
          SizedBox(height: 12),
          _DiscountBanner(discounts: widget.discounts, lang: widget.lang),
          SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: StoreRules.gemsItems.map((item) {
              final discount = widget.discounts[item.productId];
              final finalPrice = discount != null
                  ? StoreRules.applyDiscount(item.basePrice, discount.percent)
                  : item.basePrice;
              return _GemsPriceCard(
                item: item,
                finalPrice: finalPrice,
                discount: discount,
                lang: widget.lang,
                onTap: () => _purchase(context, item, village, finalPrice),
              );
            }).toList(),
          ),
          SizedBox(height: 8),
          if (!AppConstants.playStore) _SimulationNotice(lang: widget.lang),
        ],
      ),
    );
  }

  Future<void> _purchase(
    BuildContext context,
    StoreGemsItem item,
    VillageProvider village,
    double finalPrice,
  ) async {
    if (!AppConstants.playStore) {
      await village.addResources(gems: item.gems);
      if (context.mounted) {
        _showSimulatedPurchase(
            context,
            widget.lang,
            widget.lang
                .translate('store_gems_received')
                .replaceAll('{gems}', '${item.gems}'));
      }
      return;
    }

    final result = await widget.storeService.purchaseGems(item);
    if (!context.mounted) return;

    if (result.state == StorePurchaseState.error) {
      _showError(context, widget.lang, result.errorMessage);
    }
  }
}

class _AdForGemsSection extends StatelessWidget {
  final VillageProvider village;
  final LanguageProvider lang;
  final VoidCallback onWatchAd;
  final bool isWatching;
  final Duration? cooldown;

  const _AdForGemsSection({
    required this.village,
    required this.lang,
    required this.onWatchAd,
    required this.isWatching,
    this.cooldown,
  });

  @override
  Widget build(BuildContext context) {
    final claimed = village.adGemsClaimed;
    final adsToday = village.adGemsAdsToday;
    const Color sectionColor = AppTheme.darkMint;
    final Color bgColor = AppTheme.mint.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: claimed
            ? Colors.grey.withValues(alpha: 0.08)
            : bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: claimed
              ? Colors.grey.withValues(alpha: 0.3)
              : sectionColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_circle_outline,
                  size: 16,
                  color: claimed ? Colors.grey : sectionColor),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  lang.translate('ad_gems_section_title'),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: claimed ? Colors.grey : sectionColor),
                ),
              ),
              Text(
                lang.translate('ad_daily_limit_label'),
                style: TextStyle(
                    fontSize: 10,
                    color: (claimed ? Colors.grey : sectionColor)
                        .withValues(alpha: 0.6)),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (claimed) ...[
            Text(
              lang.translate('ad_gems_claimed_today'),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ResourceIcon.gem(size: 18),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              lang.translate('ad_gems_section_subtitle'),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkText),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        lang
                            .translate('ad_gems_progress')
                            .replaceAll('{count}', '$adsToday'),
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.darkText.withValues(alpha: 0.7)),
                      ),
                      SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: adsToday / 3.0,
                          backgroundColor:
                              sectionColor.withValues(alpha: 0.15),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(sectionColor),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: (isWatching || cooldown != null) ? null : onWatchAd,
                    icon: isWatching
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(Icons.play_arrow, size: 16),
                    label: Text(
                      cooldown != null
                          ? '${lang.translate('ad_gems_watch_btn')} (${cooldown!.inSeconds}s)'
                          : lang.translate('ad_gems_watch_btn'),
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sectionColor,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PacksTab extends StatelessWidget {
  final LanguageProvider lang;
  final Map<String, DiscountInfo> discounts;
  final StoreService storeService;

  const _PacksTab({
    required this.lang,
    required this.discounts,
    required this.storeService,
  });

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _DiscountBanner(discounts: discounts, lang: lang),
          SizedBox(height: 12),
          ...StoreRules.packs.map((pack) {
            final discount = discounts[pack.productId];
            final finalPrice = discount != null
                ? StoreRules.applyDiscount(pack.basePrice, discount.percent)
                : pack.basePrice;
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _PackCard(
                pack: pack,
                finalPrice: finalPrice,
                discount: discount,
                lang: lang,
                onTap: () => _purchase(context, pack, village, finalPrice),
              ),
            );
          }),
          if (!AppConstants.playStore) _SimulationNotice(lang: lang),
        ],
      ),
    );
  }

  Future<void> _purchase(
    BuildContext context,
    StorePack pack,
    VillageProvider village,
    double finalPrice,
  ) async {
    if (!AppConstants.playStore) {
      await _applyPackContents(village, pack);
      if (context.mounted) {
        _showSimulatedPurchase(
          context,
          lang,
          lang
              .translate('store_pack_received')
              .replaceAll('{pack}', lang.translate('store_pack_${pack.id}')),
        );
      }
      return;
    }

    final result = await storeService.purchasePack(pack);
    if (!context.mounted) return;

    if (result.state == StorePurchaseState.error) {
      _showError(context, lang, result.errorMessage);
    }
  }

  Future<void> _applyPackContents(
      VillageProvider village, StorePack pack) async {
    await village.addResources(
      coins: pack.coins,
      wood: pack.wood,
      metal: pack.metal,
      gems: pack.gems,
    );
    if (pack.bookPowerups > 0) {
      await village.addItemToInventory('book', amount: pack.bookPowerups);
    }
    if (pack.sandwichPowerups > 0) {
      await village.addItemToInventory('sandwich',
          amount: pack.sandwichPowerups);
    }
    if (pack.hammerPowerups > 0) {
      await village.addItemToInventory('hammer', amount: pack.hammerPowerups);
    }
    if (pack.glassesPowerups > 0) {
      await village.addItemToInventory('glasses', amount: pack.glassesPowerups);
    }
  }
}

class _GemsPriceCard extends StatelessWidget {
  final StoreGemsItem item;
  final double finalPrice;
  final DiscountInfo? discount;
  final LanguageProvider lang;
  final VoidCallback onTap;

  const _GemsPriceCard({
    required this.item,
    required this.finalPrice,
    required this.discount,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const gemColor = AppTheme.gemPurple;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gemColor.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gemColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (discount != null)
              Positioned(
                top: 8,
                right: 8,
                child: _DiscountBadge(percent: discount!.percent),
              ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResourceIcon.gem(size: 38),
                    SizedBox(height: 5),
                    Text(
                      '${item.gems} ${lang.translate('gems')}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkLavender,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    if (discount != null) ...[
                      Text(
                        '\$${item.basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.darkLavender,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        '\$${finalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  final StorePack pack;
  final double finalPrice;
  final DiscountInfo? discount;
  final LanguageProvider lang;
  final VoidCallback onTap;

  const _PackCard({
    required this.pack,
    required this.finalPrice,
    required this.discount,
    required this.lang,
    required this.onTap,
  });

  Color get _color {
    final hex = pack.colorHex;
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final packName = lang.translate('store_pack_${pack.id}');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        packName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          lang.translate('store_save').replaceAll('{pct}', '${pack.savingsPercent}'),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (discount != null) ...[
                      _DiscountBadge(percent: discount!.percent),
                      SizedBox(height: 4),
                      Text(
                        '\$${pack.basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${finalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 1, color: color.withValues(alpha: 0.4)),
            SizedBox(height: 10),
            _PackContentsColumn(pack: pack, lang: lang),
          ],
        ),
      ),
    );
  }
}

class _PackContentsColumn extends StatelessWidget {
  final StorePack pack;
  final LanguageProvider lang;

  const _PackContentsColumn({required this.pack, required this.lang});

  @override
  Widget build(BuildContext context) {
    final items = <({Widget icon, int amount, String label})>[];

    void add(Widget icon, int amount, String labelKey) {
      if (amount <= 0) return;
      items.add((icon: icon, amount: amount, label: lang.translate(labelKey)));
    }

    add(ResourceIcon.coin(size: 17), pack.coins, 'coins');
    add(ResourceIcon.wood(size: 17), pack.wood, 'wood');
    add(ResourceIcon.metal(size: 17), pack.metal, 'metal');
    add(ResourceIcon.gem(size: 17), pack.gems, 'gems');
    add(Image.asset('assets/images/items/book_item.png', width: 18, height: 18), pack.bookPowerups, 'happiness_book');
    add(Image.asset('assets/images/items/sandwich_item.png', width: 18, height: 18), pack.sandwichPowerups, 'constructor_sandwich');
    add(Image.asset('assets/images/items/hammer_item.png', width: 18, height: 18), pack.hammerPowerups, 'constructor_hammer');
    add(Image.asset('assets/images/items/glasses_item.png', width: 18, height: 18), pack.glassesPowerups, 'magic_glasses');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            item.icon,
            SizedBox(width: 8),
            Text(
              '+${item.amount}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            SizedBox(width: 5),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkText.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final double percent;

  const _DiscountBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 4)
        ],
      ),
      child: Text(
        '-${percent.toInt()}%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DiscountBanner extends StatefulWidget {
  final Map<String, DiscountInfo> discounts;
  final LanguageProvider lang;

  const _DiscountBanner({required this.discounts, required this.lang});

  @override
  State<_DiscountBanner> createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<_DiscountBanner> {
  late final Stream<Duration> _countdown;

  @override
  void initState() {
    super.initState();
    if (widget.discounts.isNotEmpty) {
      final endsAt = widget.discounts.values.first.endsAt;
      _countdown = Stream.periodic(
        const Duration(seconds: 1),
        (_) {
          final rem = endsAt.difference(DateTime.now());
          return rem.isNegative ? Duration.zero : rem;
        },
      );
    }
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
    }
    return '${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.discounts.isEmpty) return SizedBox.shrink();

    final labelKey = widget.discounts.values.first.labelKey;
    final label = widget.lang.translate(labelKey);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.celebration, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                StreamBuilder<Duration>(
                  stream: _countdown,
                  initialData: widget.discounts.values.first.timeRemaining,
                  builder: (_, snap) {
                    final rem = snap.data ?? Duration.zero;
                    return Text(
                      '${widget.lang.translate('store_discount_ends_in')} ${_format(rem)}',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9)),
                    );
                  },
                ),
              ],
            ),
          ),
          Icon(Icons.local_fire_department, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}

class _GemBalanceBar extends StatelessWidget {
  final int gems;
  final LanguageProvider lang;

  const _GemBalanceBar({required this.gems, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.cream,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lavender.withValues(alpha: 0.35),
              AppTheme.gemPurple.withValues(alpha: 0.2)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lavender, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResourceIcon.gem(size: 22),
            SizedBox(width: 7),
            Text(
              '${lang.translate('store_your_gems')}: ',
              style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkText.withValues(alpha: 0.7)),
            ),
            Text(
              '$gems',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkLavender),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color color;

  const _SectionLabel(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Color topColor;
  final Color borderColor;
  final VoidCallback onTap;
  final bool canAfford;
  final Widget child;

  const _StoreCard({
    required this.topColor,
    required this.borderColor,
    required this.onTap,
    required this.canAfford,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: canAfford ? topColor : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: canAfford ? borderColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: canAfford
              ? [
                  BoxShadow(
                      color: borderColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}

class _SimulationNotice extends StatelessWidget {
  final LanguageProvider lang;

  const _SimulationNotice({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.amber.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              lang.translate('store_simulation_notice'),
              style: TextStyle(fontSize: 11, color: Colors.amber.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeciesTab extends StatelessWidget {
  final LanguageProvider lang;
  final StoreService storeService;
  final Map<String, DiscountInfo> discounts;

  const _SpeciesTab({required this.lang, required this.storeService, required this.discounts});

  Color _rarityColor(VillagerRarity rarity) {
    switch (rarity) {
      case VillagerRarity.common:
        return const Color(0xFF9E9E9E);
      case VillagerRarity.rare:
        return const Color(0xFF2196F3);
      case VillagerRarity.extraordinary:
        return const Color(0xFF9C27B0);
      case VillagerRarity.legendary:
        return const Color(0xFFFF9800);
      case VillagerRarity.godly:
        return const Color(0xFFF44336);
    }
  }

  Future<void> _purchase(
      BuildContext context, VillagerSpeciesData species) async {
    final village = context.read<VillageProvider>();
    if (village.isSpeciesUnlocked(species.id)) return;

    if (!AppConstants.playStore) {
      await village.unlockSpeciesFromStore(species.id);
      if (context.mounted) {
        _showSimulatedPurchase(
          context,
          lang,
          lang.translate('store_species_unlock_success'),
        );
      }
      return;
    }

    final productId = SpeciesRules.productIdForSpecies(species.id);
    final result = await storeService.purchaseSpecies(productId);
    if (!context.mounted) return;
    if (result.state == StorePurchaseState.success) {
      await village.unlockSpeciesFromStore(species.id);
      if (context.mounted) {
        showSuccessToast(
            context, lang.translate('store_species_unlock_success'));
      }
    } else if (result.state == StorePurchaseState.error) {
      _showError(context, lang, result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final village = context.watch<VillageProvider>();
    final available = village.storeSpeciesAvailable;

    if (available.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 48, color: AppTheme.coinGold),
              SizedBox(height: 12),
              Text(
                lang.translate('store_species_no_available'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.lavender.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.lavender),
            ),
            child: Row(
              children: [
                Icon(Icons.refresh, size: 16, color: AppTheme.darkLavender),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _nextRefreshText(),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.darkLavender,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ...available.map((species) {
                final productId = SpeciesRules.productIdForSpecies(species.id);
                final discount = discounts[productId];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _SpeciesStoreCard(
                    species: species,
                    lang: lang,
                    rarityColor: _rarityColor(species.rarity),
                    onTap: () => _purchase(context, species),
                    discount: discount,
                  ),
                );
              }),
          if (!AppConstants.playStore) _SimulationNotice(lang: lang),
        ],
      ),
    );
  }

  String _nextRefreshText() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return lang
        .translate('store_species_refresh')
        .replaceAll('{time}', '${h}h ${m.toString().padLeft(2, '0')}m');
  }
}

class _SpeciesStoreCard extends StatelessWidget {
  final VillagerSpeciesData species;
  final LanguageProvider lang;
  final Color rarityColor;
  final VoidCallback onTap;
  final DiscountInfo? discount;

  const _SpeciesStoreCard({
    required this.species,
    required this.lang,
    required this.rarityColor,
    required this.onTap,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final originalPrice = species.realPrice;
    final finalPrice = discount != null && originalPrice != null
        ? StoreRules.applyDiscount(originalPrice, discount!.percent)
        : originalPrice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: rarityColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: rarityColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: rarityColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: rarityColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/villagers/${species.id}/${species.id}_villager.png',
                      width: 40,
                      height: 40,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.pets,
                        size: 28,
                        color: rarityColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.translate(species.nameKey),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: rarityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: rarityColor, width: 1),
                            ),
                            child: Text(
                              lang.translate(SpeciesRules.rarityKey(species.rarity)),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: rarityColor,
                              ),
                            ),
                          ),
                          if (discount != null)
                            _DiscountBadge(percent: discount!.percent),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              lang.translate(species.descriptionKey),
              style: TextStyle(
                fontSize: 11.5,
                color: AppTheme.darkText.withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (discount != null && originalPrice != null) ...[
                  Text(
                    '\$${originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: rarityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lang.translate('store_species_buy').replaceAll(
                      '{price}',
                      '\$${(finalPrice ?? originalPrice ?? 0.0).toStringAsFixed(2)}',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _showGemConfirmDialog(
    BuildContext context, LanguageProvider lang, int gemCost) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.softWhite,
      title: Row(
        children: [
          ResourceIcon.gem(size: 22),
          SizedBox(width: 8),
          Text(
            lang.translate('store_confirm_title'),
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText),
          ),
        ],
      ),
      content: Text(
        lang.translate('store_confirm_body').replaceAll('{gems}', '$gemCost'),
        style: TextStyle(fontSize: 14, color: AppTheme.darkText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            lang.translate('cancel'),
            style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.6)),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkLavender,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            lang.translate('store_confirm_buy'),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
  return confirmed == true;
}

void _showNotEnoughGems(BuildContext context, LanguageProvider lang) =>
    showErrorToast(context, lang.translate('store_not_enough_gems'));

void _showPurchaseSuccess(BuildContext context, LanguageProvider lang) =>
    showSuccessToast(context, lang.translate('store_purchase_success'));

void _showSimulatedPurchase(
    BuildContext context, LanguageProvider lang, String detail) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.softWhite,
      title: Row(
        children: [
          Text('🛒', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Text(lang.translate('store_simulated_title'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(detail, style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text(
            lang.translate('store_simulation_notice'),
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkMint,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(lang.translate('done'),
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

void _showError(BuildContext context, LanguageProvider lang, String? message) =>
    showErrorToast(context, message ?? lang.translate('store_purchase_error'));
