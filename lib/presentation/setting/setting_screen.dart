import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final currentLocale = appState.locale;
    final currentTheme = appState.themeKey;

    return BaseScrollableScreen(
      appBar: GradientAppBar(title: AppLocalizations.of(context)!.settings),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentLocale?.languageCode ?? 'en',
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Row(children: [Text('English')]),
            ),
            DropdownMenuItem(
              value: 'vi',
              child: Row(children: [Text('Tiếng Việt')]),
            ),
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
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(
              Icons.palette_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.theme,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded),
        ),
        const SizedBox(height: 24),
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
    );
  }
}
