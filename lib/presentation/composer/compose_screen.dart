import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/constants/content.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/composer/compose_controller.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:message_box/services/shared_preferences_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  final String? messageId;
  const ComposeScreen({super.key, this.messageId});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _showValidationError = false;
  String? _placeholder;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey suggestedButtonKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_placeholder == null) {
      final isEn = AppLocalizations.of(context)!.localeName == 'en';
      final list = isEn
          ? listPlaceholderWriteSomethingEN
          : listPlaceholderWriteSomethingVI;
      _placeholder = list[Random().nextInt(list.length)];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showTutorial());

    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });
    Future.microtask(() async {
      if (widget.messageId != null) {
        final m = await ref
            .read(messageProvider.notifier)
            .getMessage(widget.messageId!);
        if (m != null) {
          _ctrl.text = m.content;
          ref.read(composeControllerProvider.notifier).setContent(m.content);
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void showTutorial() async {
    final prefsService = await SharedPreferencesService.getInstance();
    final hasSeenGuide = prefsService.getHasSeenSuggestedMessageGuide();

    if (hasSeenGuide) {
      return;
    }

    targets.add(
      TargetFocus(
        identify: "suggestedButton",
        keyTarget: suggestedButtonKey,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              AppLocalizations.of(context)!.guideSuggestedMessage,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      textSkip: AppLocalizations.of(context)!.done,
      paddingFocus: 8,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorialCoachMark.show(context: context);
      prefsService.setHasSeenSuggestedMessageGuide(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.messageId != null;
    final palette = Theme.of(context).extension<PastelPalette>()!;

    return BaseScreen(
      appBar: StyledAppBar(
        title: isEdit
            ? AppLocalizations.of(context)!.editMessage
            : AppLocalizations.of(context)!.newMessage,
        style: AppBarStyle.gradient,
        actions: [
          IconButton(
            key: suggestedButtonKey,
            onPressed: () {
              context.pushNamed('suggestion-quotes');
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.format_quote_rounded),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.cardA,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isEdit ? Icons.edit : Icons.create,
                      color: palette.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit
                          ? AppLocalizations.of(context)!.editMessage
                          : AppLocalizations.of(context)!.newMessage,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.onCard,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isEdit
                      ? AppLocalizations.of(context)!.makeChangesToYourMessage
                      : (_placeholder ?? ''),
                  style: TextStyle(
                    color: palette.onCard.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Text input section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: palette.cardB,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: palette.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.newMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.onCard,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      maxLines: null,
                      minLines: 16,
                      onChanged: (v) {
                        ref
                            .read(composeControllerProvider.notifier)
                            .setContent(v);
                        if (_showValidationError && v.trim().isNotEmpty) {
                          setState(() {
                            _showValidationError = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.writeSomething,
                        errorText: _showValidationError
                            ? AppLocalizations.of(context)!.writeSomething
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: palette.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: palette.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: palette.accent,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _ctrl,
                        builder: (context, value, _) {
                          final int len = value.text.trim().runes.length;
                          final bool over = len > maxLength;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: over
                                  ? Colors.red.shade100
                                  : palette.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$len/$maxLength',
                              style: TextStyle(
                                color: over
                                    ? Colors.red.shade700
                                    : palette.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),

                      ElevatedButton.icon(
                        onPressed: () async {
                          final content = _ctrl.text.trim();
                          if (content.isEmpty) {
                            setState(() {
                              _showValidationError = true;
                            });
                            return;
                          }

                          bool success = false;
                          if (isEdit) {
                            success = await ref
                                .read(composeControllerProvider.notifier)
                                .saveEdit(widget.messageId!);
                          } else {
                            success = await ref
                                .read(composeControllerProvider.notifier)
                                .saveNew();
                          }
                          if (mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEdit
                                      ? AppLocalizations.of(context)!.updated
                                      : AppLocalizations.of(context)!.saved,
                                ),
                                backgroundColor: palette.accent,
                              ),
                            );
                            context.pop(true);
                            ref
                                .read(composeControllerProvider.notifier)
                                .checkShowWidgetGuide(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.errorTooLong,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save, size: 18),
                        label: Text(AppLocalizations.of(context)!.save),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.accent,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Footer section
          if (isEdit) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.pinnedBg.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.borderColor),
              ),
              child: FutureBuilder(
                future: ref
                    .read(messageProvider.notifier)
                    .getMessage(widget.messageId!),
                builder: (context, snapshot) {
                  final updatedAt =
                      snapshot.data?.updatedAt ?? snapshot.data?.createdAt;
                  if (updatedAt == null) return const SizedBox.shrink();
                  return Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: palette.onCard.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${AppLocalizations.of(context)!.updated}: ${formatRelative(updatedAt, context)}',
                        style: TextStyle(
                          color: palette.onCard.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
