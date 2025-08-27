import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/presentation/messages/all_messages_controller.dart';
import 'package:message_box/presentation/widgets/empty_state.dart';

class AllMessagesScreen extends ConsumerStatefulWidget {
  const AllMessagesScreen({super.key});

  @override
  ConsumerState<AllMessagesScreen> createState() => _AllMessagesScreenState();
}

class _AllMessagesScreenState extends ConsumerState<AllMessagesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(allMessagesControllerProvider.notifier).refresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allMessagesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Messages'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(allMessagesControllerProvider.notifier)
                              .search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) =>
                  ref.read(allMessagesControllerProvider.notifier).search(v),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                DropdownButton<MessageSort>(
                  value: state.sortOrder,
                  items: const [
                    DropdownMenuItem(
                      value: MessageSort.newest,
                      child: Text('Newest'),
                    ),
                    DropdownMenuItem(
                      value: MessageSort.oldest,
                      child: Text('Oldest'),
                    ),
                  ],
                  onChanged: (v) => v == null
                      ? null
                      : ref
                            .read(allMessagesControllerProvider.notifier)
                            .setSort(v),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(allMessagesControllerProvider.notifier).refresh(),
              child: state.list.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (items) {
                  if (items.isEmpty) {
                    return const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: EmptyState(text: 'No message found'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final m = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            m.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: m.pinned ? const Icon(Icons.push_pin) : null,
                          onTap: () async {
                            final changed = await context.push<bool>(
                              '/edit/${m.id}',
                            );
                            if (changed == true && mounted) {
                              await ref
                                  .read(allMessagesControllerProvider.notifier)
                                  .refresh();
                            }
                          },
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) async {
                              if (v == 'edit') {
                                final changed = await context.push<bool>(
                                  '/edit/${m.id}',
                                );
                                if (changed == true && mounted) {
                                  await ref
                                      .read(
                                        allMessagesControllerProvider.notifier,
                                      )
                                      .refresh();
                                }
                              }
                              if (v == 'delete') {
                                final ok = await _confirmDelete(context);
                                if (ok)
                                  await ref
                                      .read(
                                        allMessagesControllerProvider.notifier,
                                      )
                                      .delete(m.id);
                              }
                              if (v == 'pin')
                                await ref
                                    .read(
                                      allMessagesControllerProvider.notifier,
                                    )
                                    .pinToggle(m.id);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                              PopupMenuItem(
                                value: 'pin',
                                child: Text(m.pinned ? 'Unpin' : 'Pin'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return res ?? false;
  }
}
