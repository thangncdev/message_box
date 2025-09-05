import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/l10n/app_localizations.dart';

class WidgetGuideModal extends StatelessWidget {
  const WidgetGuideModal({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    final t = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: palette.cardA,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: palette.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.widgets_rounded,
                size: 40,
                color: palette.accent,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              t.widgetGuideTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: palette.onCard,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              t.widgetGuideDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: palette.onCard.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close modal
                  context.push('/guide'); // Navigate to guide screen
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: palette.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadowColor: Colors.black.withOpacity(0.15),
                ),
                child: Text(
                  t.widgetGuideButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
