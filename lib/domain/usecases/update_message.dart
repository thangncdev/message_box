import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class UpdateMessage {
  final MessageRepository repository;
  UpdateMessage(this.repository);

  Future<void> call(Message message) => repository.update(message);
}
