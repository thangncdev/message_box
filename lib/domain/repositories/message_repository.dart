import 'package:message_box/domain/entities/message.dart';

enum MessageSort { newest, oldest }

abstract class MessageRepository {
  Future<void> create(Message message);
  Future<void> update(Message message);
  Future<void> delete(String id);
  Future<Message?> get(String id);
  Future<List<Message>> list({
    String? query,
    MessageSort sort = MessageSort.newest,
    bool pinnedFirst = false,
  });
  Future<Message?> random();
  Future<Message?> latest();
}
