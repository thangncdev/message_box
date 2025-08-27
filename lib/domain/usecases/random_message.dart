import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';

class RandomMessage {
  final MessageRepository repository;
  RandomMessage(this.repository);

  Future<Message?> call() => repository.random();
}
