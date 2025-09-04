import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/core/theme.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final currentLocale = appState.locale;
    final currentTheme = appState.themeKey;

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
            onChanged: (v) async {
              if (v == 'system') {
                await ref.read(appProvider.notifier).changeLocale(null);
              } else if (v == 'en') {
                await ref
                    .read(appProvider.notifier)
                    .changeLocale(const Locale('en'));
              } else if (v == 'vi') {
                await ref
                    .read(appProvider.notifier)
                    .changeLocale(const Locale('vi'));
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          Text('Theme', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentTheme,
            items: [
              for (final key in availableThemes)
                DropdownMenuItem(value: key, child: Text(key)),
            ],
            onChanged: (v) async {
              if (v != null) {
                await ref.read(appProvider.notifier).changeTheme(v);
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          // Reset to defaults button
          ElevatedButton(
            onPressed: () async {
              await ref.read(appProvider.notifier).resetToDefaults();
            },
            child: Text('Reset to Defaults'),
          ),
          // Error display
          if (appState.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appState.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(appProvider.notifier).clearError();
                    },
                    icon: Icon(Icons.close, color: Colors.red.shade600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
