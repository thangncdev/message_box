import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class GetMessage {
  final MessageRepository repository;
  GetMessage(this.repository);

  Future<Message?> call(String id) => repository.get(id);
}
