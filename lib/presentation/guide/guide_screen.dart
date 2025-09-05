import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/assets/images/app_images.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:message_box/l10n/app_localizations.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    final t = AppLocalizations.of(context)!;
    final steps = <_StepItem>[
      _StepItem(
        Icons.touch_app_rounded,
        t.guideStepIosJiggle,
        AppImages.guide_1,
      ),
      _StepItem(
        Icons.add_circle_outline_rounded,
        t.guideStepIosTapPlus,
        AppImages.guide_2,
      ),
      _StepItem(
        Icons.view_quilt_rounded,
        t.guideStepIosFindInGallery,
        AppImages.guide_3,
      ),
      _StepItem(
        Icons.style_rounded,
        t.guideStepIosChooseStyle,
        AppImages.guide_5,
      ),
      _StepItem(
        Icons.add_box_rounded,
        t.guideStepIosTapAddWidget,
        AppImages.guide_4,
      ),
      _StepItem(
        Icons.open_with_rounded,
        t.guideStepIosDragPosition,
        AppImages.guide_5,
      ),
      _StepItem(
        Icons.task_alt_rounded,
        t.guideStepIosTapDone,
        AppImages.guide_5,
      ),
    ];

    return BaseScreen(
      appBar: GradientAppBar(
        title: t.guideTitleIos,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: palette.cardB,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.guideTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: palette.onCard,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.guideSubtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.onCard.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final s = steps[i];
                  return _StepCard(icon: s.icon, text: s.text, image: s.image);
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                t.guideFooter,
                style: TextStyle(
                  color: palette.onCard.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.pop(),
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
                  t.done,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String image;
  const _StepCard({
    required this.icon,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.cardA,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.borderColor),
                ),
                child: Icon(icon, color: palette.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, color: palette.onCard),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width * 0.8,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class _StepItem {
  final IconData icon;
  final String text;
  final String image;
  _StepItem(this.icon, this.text, this.image);
}
