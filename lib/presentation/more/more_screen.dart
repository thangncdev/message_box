import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: GradientAppBar(
        title: AppLocalizations.of(context)!.more,
        centerTitle: true,
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CardTile(
            icon: Icons.settings_outlined,
            title: AppLocalizations.of(context)!.settings,
            subtitle: AppLocalizations.of(context)!.settingsSubtitle,
            onTap: () => context.push('/setting'),
          ),
          const SizedBox(height: 12),
          _CardTile(
            icon: Icons.help_outline_rounded,
            title: AppLocalizations.of(context)!.widgetGuide,
            subtitle: AppLocalizations.of(context)!.widgetGuideSubtitle,
            onTap: () => context.push('/guide'),
          ),
          const SizedBox(height: 12),
          _CardTile(
            icon: Icons.mail_outline,
            title: AppLocalizations.of(context)!.feedback,
            subtitle: AppLocalizations.of(context)!.feedbackSubtitle,
            onTap: () async {
              final uri = Uri(
                scheme: 'mailto',
                path: 'thangnct110@gmail.com',
                query: Uri.encodeFull('subject=DearBox Feedback'),
              );
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          const SizedBox(height: 12),
          _CardTile(
            icon: Icons.star_rate_rounded,
            title: AppLocalizations.of(context)!.rateThisApp,
            subtitle: AppLocalizations.of(context)!.rateAppSubtitle,
            onTap: () async {
              final uri = Uri.parse('https://beacons.ai/thangnct');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _CardTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: palette.cardA,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: palette.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: palette.onCard,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: palette.onCard.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
