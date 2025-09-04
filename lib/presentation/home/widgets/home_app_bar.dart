import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/assets/images/app_images.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/l10n/app_localizations.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  const HomeAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    return Row(
      children: [
        // Logo/Icon placeholder
        Image.asset(AppImages.logo_in_app, width: 68, height: 68),
        const SizedBox(width: 12),
        // App title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DearBox',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: palette.onCard,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.yourPersonalMessageBox,
                style: TextStyle(
                  fontSize: 12,
                  color: palette.onCard.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // More button
        Container(
          decoration: BoxDecoration(
            color: palette.cardA,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.borderColor),
          ),
          child: IconButton(
            onPressed: () => context.push('/more'),
            icon: Icon(Icons.more_horiz_rounded, color: palette.accent),
            tooltip: 'More',
          ),
        ),
      ],
    );
  }
}
