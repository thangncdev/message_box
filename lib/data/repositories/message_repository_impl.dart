import 'dart:math';

import 'package:message_box/data/datasources/local/message_local_ds.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageLocalDataSource local;
  MessageRepositoryImpl(this.local);

  @override
  Future<void> create(Message message) async {
    await local.put(message);
  }

  @override
  Future<void> update(Message message) async {
    // Enforce single pinned message globally
    if (message.pinned) {
      final all = local.list();
      for (final m in all) {
        if (m.id != message.id && m.pinned) {
          await local.put(
            m.copyWith(pinned: false, updatedAt: DateTime.now().toUtc()),
          );
        }
      }
    }
    await local.put(message);
  }

  @override
  Future<void> delete(String id) async {
    final toDelete = await get(id);
    await local.delete(id);
    // If deleted message was pinned, auto-pin the latest remaining one
    if (toDelete?.pinned == true) {
      final remaining = local.list(sort: MessageSort.newest);
      if (remaining.isNotEmpty) {
        final latest = remaining.first;
        if (!latest.pinned) {
          await local.put(
            latest.copyWith(pinned: true, updatedAt: DateTime.now().toUtc()),
          );
        }
      }
    }
  }

  @override
  Future<Message?> get(String id) async {
    return local.get(id);
  }

  @override
  Future<List<Message>> list({
    String? query,
    MessageSort sort = MessageSort.newest,
    bool pinnedFirst = false,
  }) async {
    final items = local.list(query: query, sort: sort);
    if (!pinnedFirst) return items;
    final pinned = items.where((m) => m.pinned).toList();
    final others = items.where((m) => !m.pinned).toList();
    return [...pinned, ...others];
  }

  @override
  Future<Message?> latest() async {
    final items = local.list(sort: MessageSort.newest);
    return items.isNotEmpty ? items.first : null;
  }

  @override
  Future<Message?> random() async {
    final items = local.list();
    if (items.isEmpty) return null;
    final rnd = Random();
    return items[rnd.nextInt(items.length)];
  }
}
