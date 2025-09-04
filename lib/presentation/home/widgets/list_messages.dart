import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/home/widgets/search_field.dart';

class ListMessages extends ConsumerStatefulWidget {
  final Future<bool> Function(BuildContext context)? onConfirmDelete;
  final Future<void> Function(Message m)? onTogglePin;
  final Future<void> Function(Message m)? onDeleted;
  const ListMessages({
    super.key,
    this.onConfirmDelete,
    this.onTogglePin,
    this.onDeleted,
  });

  @override
  ConsumerState<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends ConsumerState<ListMessages> {
  String _query = '';
  MessageSort _sort = MessageSort.newest;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageProvider);
    final messages = ref.watch(messagesListProvider);
    final palette = Theme.of(context).extension<PastelPalette>()!;
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field (refactored)
        AnimatedSearchField(
          hintText: AppLocalizations.of(context)!.searchHint,
          onChanged: (v) => setState(() => _query = v),
          iconColor: palette.accent,
          borderColor: palette.accent,
          expandedWidthFactor: 0.92,
        ),
        const SizedBox(height: 12),
        if (messageState.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (messageState.error != null)
          Text('Error: ${messageState.error}')
        else ...[
          Builder(
            builder: (context) {
              // search
              List<Message> filtered = messages;
              if (_query.isNotEmpty) {
                final q = _query.toLowerCase();
                filtered = filtered
                    .where((m) => m.content.toLowerCase().contains(q))
                    .toList();
              }
              // sort
              filtered.sort(
                (a, b) => _sort == MessageSort.newest
                    ? b.createdAt.compareTo(a.createdAt)
                    : a.createdAt.compareTo(b.createdAt),
              );
              final data = filtered;

              if (data.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final m = data[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => context.push('/detail/${m.id}'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: palette.cardA,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: palette.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              m.pinned
                                  ? Icons.push_pin
                                  : Icons.emoji_emotions_outlined,
                              color: palette.accent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: palette.onCard,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRelative(
                                      m.updatedAt ?? m.createdAt,
                                      context,
                                    ),
                                    style: TextStyle(
                                      color: palette.onCard,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Color(0xFF8C88A6),
                              ),
                              onSelected: (v) async {
                                if (v == 'edit') context.push('/edit/${m.id}');
                                if (v == 'pin' && widget.onTogglePin != null) {
                                  await widget.onTogglePin!(m);
                                }
                                if (v == 'delete' &&
                                    widget.onConfirmDelete != null) {
                                  final ok = await widget.onConfirmDelete!(
                                    context,
                                  );
                                  if (ok && widget.onDeleted != null) {
                                    await widget.onDeleted!(m);
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    AppLocalizations.of(context)!.edit,
                                  ),
                                ),
                                if (!m.pinned)
                                  PopupMenuItem(
                                    value: 'pin',
                                    child: Text(
                                      AppLocalizations.of(context)!.pin,
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
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
            },
          ),
        ],
      ],
    );
  }
}
