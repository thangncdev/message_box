import 'package:hive/hive.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class MessageLocalDataSource {
  static const String boxName = 'messages';

  final Box<Message> box;
  MessageLocalDataSource(this.box);

  Future<void> put(Message message) async {
    await box.put(message.id, message);
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }

  Message? get(String id) {
    return box.get(id);
  }

  List<Message> list({String? query, MessageSort sort = MessageSort.newest}) {
    Iterable<Message> messages = box.values;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      messages = messages.where((m) => m.content.toLowerCase().contains(q));
    }
    final list = messages.toList();
    list.sort(
      (a, b) => sort == MessageSort.newest
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );
    return list;
  }
}
