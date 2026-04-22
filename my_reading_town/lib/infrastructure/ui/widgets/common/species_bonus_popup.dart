import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:my_reading_town/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_town/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_town/domain/rules/species_rules.dart';
import 'package:my_reading_town/infrastructure/ui/widgets/common/resource_icon.dart';

Color rarityColorForSpecies(VillagerRarity rarity) {
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

class SpeciesBonusPopup extends StatefulWidget {
  final VillagerSpeciesData speciesData;
  final bool isDuplicate;

  const SpeciesBonusPopup({
    super.key,
    required this.speciesData,
    required this.isDuplicate,
  });

  @override
  State<SpeciesBonusPopup> createState() => _SpeciesBonusPopupState();
}

class _SpeciesBonusPopupState extends State<SpeciesBonusPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.bounceOut);
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 3));
    _animCtrl.forward();
    _confettiCtrl.play();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final species = widget.speciesData;
    final rarityColor = rarityColorForSpecies(species.rarity);
    final isDuplicate = widget.isDuplicate;

    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.25,
              colors: [
                rarityColor,
                AppTheme.coinGold,
                AppTheme.pink,
                AppTheme.lavender,
              ],
            ),
          ),
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: AppTheme.softWhite,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: rarityColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: rarityColor.withValues(alpha: 0.35),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isDuplicate
                        ? context.t('roulette_species_duplicate')
                        : context.t('roulette_species_bonus'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDuplicate ? AppTheme.darkText : rarityColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/villagers/${species.id}/${species.id}_villager.png',
                        width: 60,
                        height: 60,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.pets,
                          size: 40,
                          color: rarityColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.t(species.nameKey),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: rarityColor, width: 1),
                    ),
                    child: Text(
                      context.t(SpeciesRules.rarityKey(species.rarity)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: rarityColor,
                      ),
                    ),
                  ),
                  if (isDuplicate) ...[
                    const SizedBox(height: 12),
                    Text(
                      context
                          .t('roulette_species_duplicate_desc')
                          .replaceAll('{species}', context.t(species.nameKey))
                          .replaceAll(
                              '{gems}',
                              '${SpeciesRules.duplicateSpeciesGemCompensation}'),
                      style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkText.withValues(alpha: 0.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResourceIcon.gem(size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '+${SpeciesRules.duplicateSpeciesGemCompensation} ${context.t('gems')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.gemPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rarityColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        context.t('done'),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
