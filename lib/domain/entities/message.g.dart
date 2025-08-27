// GENERATED CODE - hand-written to avoid build_runner in MVP
// ignore_for_file: type=lint

part of 'message.dart';

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Message(
      id: fields[0] as String,
      content: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime?,
      pinned: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.pinned);
  }
}
