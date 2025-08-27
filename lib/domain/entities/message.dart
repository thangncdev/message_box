import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime createdAt; // UTC

  @HiveField(3)
  final DateTime? updatedAt; // UTC

  @HiveField(4)
  final bool pinned;

  const Message({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.pinned = false,
  });

  Message copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? pinned,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinned: pinned ?? this.pinned,
    );
  }
}
