import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class LatestMessage {
  final MessageRepository repository;
  LatestMessage(this.repository);

  Future<Message?> call() => repository.latest();
}
