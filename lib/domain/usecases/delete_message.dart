import 'package:message_box/domain/repositories/message_repository.dart';

class DeleteMessage {
  final MessageRepository repository;
  DeleteMessage(this.repository);

  Future<void> call(String id) => repository.delete(id);
}
