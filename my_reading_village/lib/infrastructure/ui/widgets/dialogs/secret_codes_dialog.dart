import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/domain/rules/secret_codes_rules.dart';
import 'package:my_reading_village/domain/rules/species_rules.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/resource_icon.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/species_bonus_popup.dart';

void showSecretCodesDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _SecretCodesDialog(),
  );
}

class _SecretCodesDialog extends StatefulWidget {
  const _SecretCodesDialog();

  @override
  State<_SecretCodesDialog> createState() => _SecretCodesDialogState();
}

enum _DialogState { input, loading, success, errorInvalid, errorUsed }

class _SecretCodesDialogState extends State<_SecretCodesDialog> {
  final _controller = TextEditingController();
  _DialogState _state = _DialogState.input;
  List<SecretReward> _rewards = [];

  static const _kAccent = Color(0xFF7B79E8);
  static const _kAccentLight = Color(0x1A7B79E8);
  static const _kGold = Color(0xFFFFD700);
  static const _kGoldLight = Color(0x1AFFD700);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInput(String value) {
    final input = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');

    if (input.isEmpty) {
      _controller.clear();
      return;
    }

    final buffer = StringBuffer();
    int letterCount = 0;

    for (int i = 0; i < input.length; i++) {
      final char = input[i];

      if (char == '-') {
        buffer.write('-');
        continue;
      }

      if (letterCount > 0 && letterCount % 3 == 0 && letterCount < 9) {
        final prevIsHyphen =
            buffer.isNotEmpty && buffer.toString().endsWith('-');
        if (!prevIsHyphen) {
          buffer.write('-');
        }
      }

      if (letterCount < 9) {
        buffer.write(char);
        letterCount++;
      }
    }

    final formatted = buffer.toString();
    if (formatted != _controller.text) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _redeem() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    setState(() => _state = _DialogState.loading);

    final village = context.read<VillageProvider>();
    final result = await village.redeemSecretCode(code);

    if (!mounted) return;
    if (!result.found) {
      setState(() => _state = _DialogState.errorInvalid);
    } else if (result.alreadyUsed) {
      setState(() => _state = _DialogState.errorUsed);
    } else {
      setState(() {
        _state = _DialogState.success;
        _rewards = result.rewards;
      });

      for (final reward in result.rewards) {
        if (reward.type == SecretRewardType.species &&
            reward.speciesId != null) {
          final speciesData = SpeciesRules.findById(reward.speciesId!);
          if (speciesData != null && mounted) {
            final speciesResult =
                await village.applySpeciesBonus(reward.speciesId!);
            if (mounted && speciesResult != null) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => SpeciesBonusPopup(
                  speciesData: speciesData,
                  isDuplicate: speciesResult.isDuplicate,
                ),
              );
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppTheme.softWhite,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _state == _DialogState.success
            ? _buildSuccess(context)
            : _buildInput(context),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _kAccentLight,
            shape: BoxShape.circle,
            border:
                Border.all(color: _kAccent.withValues(alpha: 0.4), width: 2),
          ),
          child: const Icon(Icons.key_rounded, color: _kAccent, size: 30),
        ),
        const SizedBox(height: 12),
        Text(
          context.t('secret_codes'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.t('secret_codes_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13, color: AppTheme.darkText.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          onChanged: _onInput,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: AppTheme.darkText,
          ),
          decoration: InputDecoration(
            hintText: context.t('secret_code_hint'),
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppTheme.darkText.withValues(alpha: 0.35),
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
            filled: true,
            fillColor: _kAccentLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _kAccent.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kAccent, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _kAccent.withValues(alpha: 0.3)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        if (_state == _DialogState.errorInvalid)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              context.t('secret_code_invalid'),
              style: const TextStyle(
                  fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        if (_state == _DialogState.errorUsed)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              context.t('secret_code_used'),
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _state == _DialogState.loading ? null : _redeem,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: _state == _DialogState.loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    context.t('secret_code_redeem'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        ),
      ],
    ));
  }

  Widget _buildSuccess(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _kGoldLight,
              shape: BoxShape.circle,
              border:
                  Border.all(color: _kGold.withValues(alpha: 0.5), width: 2.5),
            ),
            child:
                const Icon(Icons.celebration_rounded, color: _kGold, size: 34),
          ),
          const SizedBox(height: 14),
          Text(
            context.t('secret_code_success'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t('secret_code_rewards'),
            style: TextStyle(
                fontSize: 13, color: AppTheme.darkText.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kGoldLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kGold.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: _rewards.map((r) => _RewardRow(reward: r)).toList(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                context.t('done'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final SecretReward reward;
  const _RewardRow({required this.reward});

  @override
  Widget build(BuildContext context) {
    Widget icon;
    String label;

    switch (reward.type) {
      case SecretRewardType.coins:
        icon = ResourceIcon.coin(size: 22);
        label = '+${reward.amount} ${context.t('coins')}';
        break;
      case SecretRewardType.gems:
        icon = ResourceIcon.gem(size: 22);
        label = '+${reward.amount} ${context.t('gems')}';
        break;
      case SecretRewardType.wood:
        icon = ResourceIcon.wood(size: 22);
        label = '+${reward.amount} ${context.t('wood')}';
        break;
      case SecretRewardType.metal:
        icon = ResourceIcon.metal(size: 22);
        label = '+${reward.amount} ${context.t('metal')}';
        break;
      case SecretRewardType.item:
        icon = Image.asset(
          _itemAssetPath(reward.itemType ?? ''),
          width: 22,
          height: 22,
          errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_rounded,
              color: Color(0xFF8E24AA), size: 22),
        );
        final itemKey = _itemKey(reward.itemType ?? '');
        label = reward.amount > 1
            ? '+${reward.amount} ${context.t(itemKey)}'
            : context.t(itemKey);
        break;
      case SecretRewardType.species:
        icon = Image.asset(
          'assets/images/villagers/${reward.speciesId}/${reward.speciesId}_villager.png',
          width: 22,
          height: 22,
          errorBuilder: (_, __, ___) => const Icon(Icons.pets_rounded,
              color: Color(0xFFEF6C00), size: 22),
        );
        final speciesData = SpeciesRules.findById(reward.speciesId ?? '');
        label = speciesData != null
            ? context.t(speciesData.nameKey)
            : (reward.speciesId ?? '');
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _itemKey(String itemType) {
    switch (itemType) {
      case 'hammer':
        return 'constructor_hammer';
      case 'sandwich':
        return 'constructor_sandwich';
      case 'glasses':
        return 'magic_glasses';
      case 'book':
        return 'happiness_book';
      default:
        return itemType;
    }
  }

  static String _itemAssetPath(String itemType) {
    switch (itemType) {
      case 'hammer':
        return 'assets/images/items/hammer_item.png';
      case 'sandwich':
        return 'assets/images/items/sandwich_item.png';
      case 'glasses':
        return 'assets/images/items/glasses_item.png';
      case 'book':
        return 'assets/images/items/book_item.png';
      default:
        return 'assets/images/items/hammer_item.png';
    }
  }
}
