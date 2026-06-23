import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/application/services/time_verification_service.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/infrastructure/ui/localization/context_ext.dart';

Future<bool?> showClockFraudDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _ClockFraudDialog(),
  );
}

class _ClockFraudDialog extends StatefulWidget {
  const _ClockFraudDialog();

  @override
  State<_ClockFraudDialog> createState() => _ClockFraudDialogState();
}

class _ClockFraudDialogState extends State<_ClockFraudDialog> {
  bool _processing = false;

  Future<void> _acceptRollback() async {
    setState(() => _processing = true);
    await sl<TimeVerificationService>().acceptPendingRollback();
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final service = sl<TimeVerificationService>();
    final count = service.pendingFraudCount;
    final target = service.restoreTarget;
    final targetText = target != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(target)
        : '';
    final mq = MediaQuery.of(context);
    final landscape = mq.size.width > mq.size.height;
    final maxH = mq.size.height * (landscape ? 0.9 : 0.8);

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.cream,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480, maxHeight: maxH),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!landscape) ...[
                  Icon(Icons.schedule_rounded,
                      color: AppTheme.darkPink, size: 40),
                  const SizedBox(height: 12),
                ],
                Text(
                  context.t('clock_fraud_title'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  context.tw('clock_fraud_body', {'count': '$count'}),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkText.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (targetText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.lavender.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.lavender.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      context.tw('clock_fraud_restore_hint',
                          {'date': targetText}),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.darkText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (_processing)
                  const CircularProgressIndicator()
                else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _acceptRollback,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(
                        context.t('clock_fraud_accept'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkMint,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => SystemNavigator.pop(),
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: Text(
                        context.t('clock_fraud_restore'),
                        textAlign: TextAlign.center,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.darkLavender,
                        side: BorderSide(
                            color: AppTheme.darkLavender.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
