import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/core/theme.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context)!.language,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentLocale?.languageCode ?? 'system',
            items: [
              DropdownMenuItem(
                value: 'system',
                child: Text(AppLocalizations.of(context)!.followSystem),
              ),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
            ],
            onChanged: (v) {
              if (v == 'system') {
                ref.read(currentLocaleProvider.notifier).state = null;
              } else if (v == 'en') {
                ref.read(currentLocaleProvider.notifier).state = const Locale(
                  'en',
                );
              } else if (v == 'vi') {
                ref.read(currentLocaleProvider.notifier).state = const Locale(
                  'vi',
                );
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          Text('Theme', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: ref.watch(currentThemeKeyProvider),
            items: [
              for (final key in availableThemes)
                DropdownMenuItem(value: key, child: Text(key)),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(currentThemeKeyProvider.notifier).state = v;
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
