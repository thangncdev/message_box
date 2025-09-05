import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/assets/images/app_images.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/services/shared_preferences_service.dart';
import 'package:message_box/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_Slide> _slides = const [
    _Slide(index: 0, emoji: '📦', image: AppImages.intro_1),
    _Slide(index: 1, emoji: '📝', image: AppImages.intro_2),
    _Slide(index: 2, emoji: '🌱', image: AppImages.intro_3),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Scaffold(
      backgroundColor: palette.cardB,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _OnboardCard(slide: slide),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            _Dots(count: _slides.length, index: _index),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  if (_index < _slides.length - 1)
                    Expanded(
                      child: _SoftButton(
                        label: AppLocalizations.of(context)!.next,
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: _SoftButton(
                        label: AppLocalizations.of(context)!.getStarted,
                        onPressed: () async {
                          final prefsService =
                              await SharedPreferencesService.getInstance();
                          await prefsService.setSeenOnboarding(true);
                          if (mounted) context.go('/');
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardCard extends StatelessWidget {
  final _Slide slide;
  const _OnboardCard({required this.slide});

  String getTitle(BuildContext context) {
    switch (slide.index) {
      case 0:
        return AppLocalizations.of(context)!.introTitle1;
      case 1:
        return AppLocalizations.of(context)!.introTitle2;
      case 2:
        return AppLocalizations.of(context)!.introTitle3;
      default:
        return '';
    }
  }

  String getContent(BuildContext context) {
    switch (slide.index) {
      case 0:
        return AppLocalizations.of(context)!.introContent1;
      case 1:
        return AppLocalizations.of(context)!.introContent2;
      case 2:
        return AppLocalizations.of(context)!.introContent3;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 16),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: palette.cardA,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: palette.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(slide.emoji, style: const TextStyle(fontSize: 44)),
            ),
            const SizedBox(height: 20),
            Text(
              getTitle(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: palette.onCard,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getContent(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: palette.onCard.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                slide.image,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SoftButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _SoftButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: Colors.white,
          foregroundColor: palette.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadowColor: Colors.black.withOpacity(0.15),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: i == index ? 18 : 8,
            decoration: BoxDecoration(
              color: i == index ? palette.accent : palette.borderColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
      ],
    );
  }
}

class _Slide {
  final int index;
  final String emoji;
  final String image;
  const _Slide({required this.index, required this.emoji, required this.image});
}
