import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class CreateMessage {
  final MessageRepository repository;
  CreateMessage(this.repository);

  Future<void> call(Message message) => repository.create(message);
}
