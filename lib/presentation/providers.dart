import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message_box/core/app_router.dart';
import 'package:message_box/data/datasources/local/message_local_ds.dart';
import 'package:message_box/data/repositories/message_repository_impl.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/domain/usecases/create_message.dart';
import 'package:message_box/domain/usecases/delete_message.dart';
import 'package:message_box/domain/usecases/get_message.dart';
import 'package:message_box/domain/usecases/latest_message.dart';
import 'package:message_box/domain/usecases/list_messages.dart';
import 'package:message_box/domain/usecases/random_message.dart';
import 'package:message_box/domain/usecases/update_message.dart';
import 'package:message_box/core/theme.dart';

// Router provider
final routerProvider = appRouterProvider;

// Hive init provider
final hiveInitProvider = FutureProvider<void>((ref) async {
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  final box = await Hive.openBox<Message>(MessageLocalDataSource.boxName);
  ref.onDispose(() => box.close());
});

// DataSource + Repository
final messageBoxProvider = Provider<Box<Message>>((ref) {
  final box = Hive.box<Message>(MessageLocalDataSource.boxName);
  return box;
});

final messageLocalDataSourceProvider = Provider<MessageLocalDataSource>((ref) {
  return MessageLocalDataSource(ref.watch(messageBoxProvider));
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepositoryImpl(ref.watch(messageLocalDataSourceProvider));
});

// Usecases
final createMessageProvider = Provider<CreateMessage>(
  (ref) => CreateMessage(ref.watch(messageRepositoryProvider)),
);
final updateMessageProvider = Provider<UpdateMessage>(
  (ref) => UpdateMessage(ref.watch(messageRepositoryProvider)),
);
final deleteMessageProvider = Provider<DeleteMessage>(
  (ref) => DeleteMessage(ref.watch(messageRepositoryProvider)),
);
final getMessageProvider = Provider<GetMessage>(
  (ref) => GetMessage(ref.watch(messageRepositoryProvider)),
);
final listMessagesProvider = Provider<ListMessages>(
  (ref) => ListMessages(ref.watch(messageRepositoryProvider)),
);
final randomMessageProvider = Provider<RandomMessage>(
  (ref) => RandomMessage(ref.watch(messageRepositoryProvider)),
);
final latestMessageProvider = Provider<LatestMessage>(
  (ref) => LatestMessage(ref.watch(messageRepositoryProvider)),
);

// Widget mode setting provider: 'random' | 'latest'
final widgetModeProvider = StateProvider<String>((ref) => 'latest');

// Global refresh ticker to notify screens to reload data
final refreshTickProvider = StateProvider<int>((ref) => 0);

// Unified messages stream: single source of truth
final messagesStreamProvider = StreamProvider<List<Message>>((ref) async* {
  final box = ref.watch(messageBoxProvider);
  List<Message> current() {
    final items = box.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  // initial emit
  yield current();
  // subsequent changes
  await for (final _ in box.watch()) {
    yield current();
  }
});

// Locale provider (null = follow system)
final currentLocaleProvider = StateProvider<Locale?>((ref) => null);

// Theme provider (key from availableThemes)
final currentThemeKeyProvider = StateProvider<String>(
  (ref) => AppThemeKeys.honey,
);
