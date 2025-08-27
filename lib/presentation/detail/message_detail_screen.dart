import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';

class MessageDetailScreen extends ConsumerWidget {
  final String messageId;
  const MessageDetailScreen({super.key, required this.messageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getMessageProvider).call(messageId);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final m = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.detailTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: m == null
                    ? null
                    : () async {
                        final changed = await context.push<bool>(
                          '/edit/${m.id}',
                        );
                        if (changed == true && context.mounted) {
                          // trigger a snack
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.updated,
                              ),
                            ),
                          );
                        }
                      },
              ),
              IconButton(
                icon: Icon(
                  m?.pinned == true ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                onPressed: m == null
                    ? null
                    : () async {
                        final willPin = !(m.pinned);
                        await ref
                            .read(updateMessageProvider)
                            .call(
                              m.copyWith(
                                pinned: willPin,
                                updatedAt: DateTime.now().toUtc(),
                              ),
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                willPin
                                    ? AppLocalizations.of(context)!.pinned
                                    : AppLocalizations.of(context)!.unpinned,
                              ),
                            ),
                          );
                        }
                      },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: m == null
                    ? null
                    : () async {
                        final ok = await _confirmDelete(context);
                        if (ok) {
                          await ref.read(deleteMessageProvider).call(m.id);
                          if (context.mounted) context.pop(true);
                        }
                      },
              ),
            ],
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : m == null
              ? const Center(child: Text('Not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.content, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text(
                        '${AppLocalizations.of(context)!.updated}: ${formatRelative(m.updatedAt ?? m.createdAt, context)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
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
