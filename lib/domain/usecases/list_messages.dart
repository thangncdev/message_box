import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class ListMessages {
  final MessageRepository repository;
  ListMessages(this.repository);

  Future<List<Message>> call({
    String? query,
    MessageSort sort = MessageSort.newest,
    bool pinnedFirst = false,
  }) => repository.list(query: query, sort: sort, pinnedFirst: pinnedFirst);
}
