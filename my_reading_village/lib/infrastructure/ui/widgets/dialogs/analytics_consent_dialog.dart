import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/analytics_service.dart';
import 'package:my_reading_village/application/services/ad_service.dart';
import 'package:my_reading_village/infrastructure/ui/widgets/common/shared_utils.dart';

Future<void> showAnalyticsConsentDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _AnalyticsConsentDialog(),
  );
}

class _AnalyticsConsentDialog extends StatefulWidget {
  const _AnalyticsConsentDialog();

  @override
  State<_AnalyticsConsentDialog> createState() =>
      _AnalyticsConsentDialogState();
}

class _AnalyticsConsentDialogState extends State<_AnalyticsConsentDialog> {
  bool _agreed = true;

  Future<void> _accept() async {
    await sl<AnalyticsService>().setConsent(_agreed);
    await sl<AdService>().setConsent(_agreed);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _openPrivacy() async {
    final uri = Uri.parse('https://myreadingvillage.com/privacy');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final landscape = isLandscape(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.softWhite,
        insetPadding: EdgeInsets.symmetric(
          horizontal: landscape ? 32 : 24,
          vertical: landscape ? 12 : 40,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 480,
            maxHeight: landscape
                ? MediaQuery.of(context).size.height * 0.90
                : MediaQuery.of(context).size.height * 0.82,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(landscape),
              Flexible(child: _buildScrollableBody(landscape)),
              _buildFooter(landscape),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool landscape) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, landscape ? 16 : 22, 20, 0),
      child: Row(
        children: [
          Container(
            width: landscape ? 36 : 44,
            height: landscape ? 36 : 44,
            decoration: BoxDecoration(
              color: AppTheme.darkPink.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.shield_outlined,
                color: AppTheme.darkPink, size: landscape ? 20 : 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.t('analytics_consent_title'),
              style: TextStyle(
                fontSize: landscape ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableBody(bool landscape) {
    final bodyText = context.t('analytics_consent_body');
    final lines = bodyText.split('\n');
    final double textSize = landscape ? 12 : 13;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._parseBodyLines(lines, textSize),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _openPrivacy,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_new,
                    size: 14, color: AppTheme.darkLavender),
                const SizedBox(width: 5),
                Text(
                  context.t('analytics_consent_privacy_link'),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkLavender,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.darkLavender,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildCheckboxRow(landscape),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  List<Widget> _parseBodyLines(List<String> lines, double textSize) {
    final widgets = <Widget>[];
    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 10));
      } else if (line.trimLeft().startsWith('•')) {
        final bulletText = line.trimLeft().substring(1).trim();
        widgets.add(_buildBulletRow(bulletText, textSize));
        widgets.add(const SizedBox(height: 5));
      } else if (line.endsWith(':')) {
        widgets.add(Text(
          line,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkPink,
            height: 1.4,
          ),
        ));
        widgets.add(const SizedBox(height: 6));
      } else {
        widgets.add(Text(
          line,
          style: TextStyle(
            fontSize: textSize,
            color: AppTheme.darkText.withValues(alpha: 0.80),
            height: 1.5,
          ),
        ));
      }
    }
    return widgets;
  }

  Widget _buildBulletRow(String text, double textSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppTheme.darkLavender,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: AppTheme.darkText.withValues(alpha: 0.80),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(bool landscape) {
    return GestureDetector(
      onTap: () => setState(() => _agreed = !_agreed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.darkPink.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _agreed
                ? AppTheme.darkPink.withValues(alpha: 0.35)
                : AppTheme.darkText.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                activeColor: AppTheme.darkPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.t('analytics_consent_checkbox'),
                style: TextStyle(
                  fontSize: landscape ? 12 : 13,
                  color: AppTheme.darkText.withValues(alpha: 0.85),
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool landscape) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, landscape ? 8 : 12, 20, landscape ? 12 : 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _accept,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkPink,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: landscape ? 9 : 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(
            context.t('analytics_consent_accept'),
            style: TextStyle(
              fontSize: landscape ? 14 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
