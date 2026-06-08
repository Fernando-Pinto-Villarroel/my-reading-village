import 'package:flutter/material.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';

class HappinessIndicator extends StatelessWidget {
  final int happiness;
  final bool landscape;

  const HappinessIndicator(
      {super.key, required this.happiness, this.landscape = false});

  IconData get _moodIcon {
    if (happiness >= 100) return Icons.sentiment_very_satisfied;
    if (happiness >= 75) return Icons.sentiment_satisfied;
    if (happiness >= 50) return Icons.sentiment_neutral;
    if (happiness >= 25) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  Color get _barColor {
    if (happiness >= 100) return AppTheme.mint;
    if (happiness >= 75) return AppTheme.coinGold;
    if (happiness >= 50) return Colors.orange.shade400;
    if (happiness >= 25) return Colors.deepOrange.shade400;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xAA000000),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        width: landscape ? 195 : 165,
        child: Row(
          children: [
            Icon(_moodIcon, color: _barColor, size: 28),
            SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: happiness / 100,
                  backgroundColor: Colors.grey.shade600,
                  valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                  minHeight: 10,
                ),
              ),
            ),
            SizedBox(width: 6),
            SizedBox(
              width: 46,
              child: Text(
                '$happiness%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
