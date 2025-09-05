import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<_LanguageOption> _languages = const [
    _LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    _LanguageOption(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    return Scaffold(
      backgroundColor: palette.cardB,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header
              Text(
                AppLocalizations.of(context)!.selectLanguage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: palette.onCard,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.selectLanguageSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: palette.onCard.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 40),

              // Language Options
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language.code;

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOut,
                      builder: (context, t, child) => Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * 20),
                          child: child,
                        ),
                      ),
                      child: _LanguageCard(
                        language: language,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedLanguage = language.code;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedLanguage != null ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: _selectedLanguage != null
                        ? palette.accent
                        : palette.borderColor,
                    foregroundColor: _selectedLanguage != null
                        ? Colors.white
                        : palette.onCard.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadowColor: Colors.black.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continueButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_selectedLanguage == null) return;

    // Update app state with selected locale
    await ref
        .read(appProvider.notifier)
        .changeLocale(Locale(_selectedLanguage!));

    if (mounted) {
      context.go('/onboarding');
    }
  }
}

class _LanguageCard extends StatelessWidget {
  final _LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? palette.accent.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? palette.accent : palette.borderColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: palette.cardA,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    language.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),

                // Language Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? palette.accent : palette.onCard,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        language.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? palette.accent.withValues(alpha: 0.7)
                              : palette.onCard.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? palette.accent : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? palette.accent : palette.borderColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
