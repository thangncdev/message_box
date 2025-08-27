import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/l10n/app_localizations.dart';

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
    final stream = ref.watch(messagesStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _query = '';
                              _searchCtrl.clear();
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<MessageSort>(
              value: _sort,
              items: [
                DropdownMenuItem(
                  value: MessageSort.newest,
                  child: Text(AppLocalizations.of(context)!.newest),
                ),
                DropdownMenuItem(
                  value: MessageSort.oldest,
                  child: Text(AppLocalizations.of(context)!.oldest),
                ),
              ],
              onChanged: (v) => setState(() => _sort = v ?? MessageSort.newest),
            ),
          ],
        ),
        const SizedBox(height: 12),
        stream.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (items) {
            // search
            List<Message> filtered = items;
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.noMessages),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final m = data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: m.pinned ? const Icon(Icons.push_pin) : null,
                    title: Text(
                      m.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      formatRelative(m.updatedAt ?? m.createdAt, context),
                    ),
                    onTap: () => context.push('/detail/${m.id}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'edit') context.push('/edit/${m.id}');
                        if (v == 'pin' && widget.onTogglePin != null)
                          await widget.onTogglePin!(m);
                        if (v == 'delete' && widget.onConfirmDelete != null) {
                          final ok = await widget.onConfirmDelete!(context);
                          if (ok && widget.onDeleted != null)
                            await widget.onDeleted!(m);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(AppLocalizations.of(context)!.edit),
                        ),
                        PopupMenuItem(
                          value: 'pin',
                          child: Text(
                            m.pinned
                                ? AppLocalizations.of(context)!.unpin
                                : AppLocalizations.of(context)!.pin,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(AppLocalizations.of(context)!.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
