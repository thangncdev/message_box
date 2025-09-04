import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_Slide> _slides = const [
    _Slide(
      title: 'DearBox',
      subtitle: 'A box for your thoughts 💌',
      emoji: '📦',
      bullets: [],
    ),
    _Slide(
      title: 'Write & Feel',
      subtitle: 'Write down your thoughts & feelings ✍️',
      emoji: '📝',
      bullets: [],
    ),
    _Slide(
      title: 'Save & Reflect',
      subtitle: 'Save quotes • Reflect anytime ✨',
      emoji: '🌸',
      bullets: [],
    ),
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
                        label: 'Next',
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
                        label: 'Get Started',
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('seen_onboarding', true);
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

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
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
              slide.title,
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
              slide.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: palette.onCard.withValues(alpha: 0.75),
              ),
            ),
            if (slide.bullets.isNotEmpty) const SizedBox(height: 12),
            for (final b in slide.bullets)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Flexible(
                      child: Text(
                        b,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.onCard.withValues(alpha: 0.8),
                        ),
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
  final String title;
  final String subtitle;
  final String emoji;
  final List<String> bullets;
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.bullets,
  });
}
