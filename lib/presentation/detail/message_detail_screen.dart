import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';

class MessageDetailScreen extends ConsumerWidget {
  final String messageId;
  const MessageDetailScreen({super.key, required this.messageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.read(messageProvider.notifier).getMessage(messageId);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final m = snapshot.data;
        return BaseScreen(
          appBar: GradientAppBar(
            title: AppLocalizations.of(context)!.detailTitle,
            actions: [
              if (m != null)
                PopupMenuButton<_MenuOption>(
                  icon: const Icon(Icons.more_horiz_rounded),
                  onSelected: (value) async {
                    switch (value) {
                      case _MenuOption.edit:
                        final changed = await context.push<bool>(
                          '/edit/${m.id}',
                        );
                        if (changed == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.updated,
                              ),
                            ),
                          );
                        }
                        break;
                      case _MenuOption.pin:
                        if (!m.pinned) {
                          final success = await ref
                              .read(messageProvider.notifier)
                              .togglePin(m.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.pinned,
                                ),
                              ),
                            );
                            context.pop();
                          }
                        }
                        break;
                      case _MenuOption.delete:
                        final ok = await _confirmDelete(context);
                        if (ok) {
                          final success = await ref
                              .read(messageProvider.notifier)
                              .deleteMessage(m.id);
                          if (success && context.mounted) context.pop(true);
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    final items = <PopupMenuEntry<_MenuOption>>[];
                    items.add(
                      PopupMenuItem<_MenuOption>(
                        value: _MenuOption.edit,
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                    );
                    if (!(m.pinned)) {
                      items.add(
                        PopupMenuItem<_MenuOption>(
                          value: _MenuOption.pin,
                          child: Text(AppLocalizations.of(context)!.pin),
                        ),
                      );
                    }
                    items.add(
                      PopupMenuItem<_MenuOption>(
                        value: _MenuOption.delete,
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    );
                    items.add(const PopupMenuDivider(height: 8));

                    return items;
                  },
                ),
            ],
          ),
          child: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : m == null
              ? Center(child: Text(AppLocalizations.of(context)!.noMessages))
              : Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutCubic,
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, t, child) {
                            return Opacity(
                              opacity: t,
                              child: Transform.translate(
                                offset: Offset(0, (1 - t) * 24),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Text(
                              m.content,
                              style: const TextStyle(fontSize: 20, height: 1.5),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${AppLocalizations.of(context)!.updated}: ${formatRelative(m.updatedAt ?? m.createdAt, context)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(AppLocalizations.of(context)!.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
    return res ?? false;
  }
}

enum _MenuOption { edit, pin, delete }
