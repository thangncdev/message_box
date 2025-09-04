import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/usecases/create_message.dart';
import 'package:message_box/domain/usecases/update_message.dart';
import 'package:message_box/domain/usecases/delete_message.dart';
import 'package:message_box/domain/usecases/get_message.dart';
import 'package:message_box/domain/usecases/list_messages.dart';
import 'package:message_box/domain/usecases/random_message.dart';
import 'package:message_box/domain/usecases/latest_message.dart';
import 'package:message_box/data/datasources/local/message_local_ds.dart';
import 'package:message_box/data/repositories/message_repository_impl.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/core/utils/id.dart';
import 'package:message_box/services/widget_service.dart';

// DataSource + Repository providers (needed for usecases)
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

// Usecase providers
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

/// Message state class chứa trạng thái của message management
class MessageState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;
  final Message? featuredMessage;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const MessageState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.featuredMessage,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  MessageState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
    Message? featuredMessage,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      featuredMessage: featuredMessage ?? this.featuredMessage,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

/// MessageProvider quản lý tất cả operations liên quan đến message
class MessageProvider extends StateNotifier<MessageState> {
  final Ref ref;
  late final Box<Message> _messageBox;
  late final StreamSubscription<BoxEvent> _boxSubscription;

  MessageProvider(this.ref) : super(const MessageState()) {
    _initialize();
  }

  /// Khởi tạo provider và setup Hive box
  Future<void> _initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      // Get message box
      _messageBox = Hive.box<Message>(MessageLocalDataSource.boxName);

      // Load initial messages
      await _loadMessages();

      // Listen to box changes for real-time updates
      _boxSubscription = _messageBox.watch().listen((_) {
        _loadMessages();
      });

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize message provider: $e',
      );
    }
  }

  /// Load messages từ Hive box
  Future<void> _loadMessages() async {
    try {
      final messages = _messageBox.values.toList();
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(messages: messages);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load messages: $e');
    }
  }

  /// Tạo message mới
  Future<bool> createMessage(String content) async {
    try {
      state = state.copyWith(isCreating: true, error: null);

      // Unpin tất cả messages hiện tại
      await _unpinAllMessages();

      final now = DateTime.now().toUtc();
      final message = Message(
        id: _generateId(),
        content: content.trim(),
        createdAt: now,
        updatedAt: null,
        pinned: true, // Message mới luôn được ghim
      );

      final createMessageUseCase = ref.read(createMessageProvider);
      await createMessageUseCase.call(message);

      state = state.copyWith(isCreating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: 'Failed to create message: $e',
      );
      return false;
    }
  }

  /// Cập nhật message
  Future<bool> updateMessage(String id, String content) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);

      final existingMessage = await getMessage(id);
      if (existingMessage == null) {
        state = state.copyWith(isUpdating: false, error: 'Message not found');
        return false;
      }

      final updatedMessage = existingMessage.copyWith(
        content: content.trim(),
        updatedAt: DateTime.now().toUtc(),
      );

      final updateMessageUseCase = ref.read(updateMessageProvider);
      await updateMessageUseCase.call(updatedMessage);

      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Failed to update message: $e',
      );
      return false;
    }
  }

  /// Xóa message
  Future<bool> deleteMessage(String id) async {
    try {
      state = state.copyWith(isDeleting: true, error: null);

      final deleteMessageUseCase = ref.read(deleteMessageProvider);
      await deleteMessageUseCase.call(id);

      state = state.copyWith(isDeleting: false);

      // Lấy message mới nhất để cập nhật widget
      final messages = _messageBox.values.toList();
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latestMessage = messages.isNotEmpty ? messages.first : null;
      await WidgetService.updateWidget(content: latestMessage?.content);

      return true;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Failed to delete message: $e',
      );
      return false;
    }
  }

  /// Generate unique ID
  String _generateId() {
    return generateId();
  }

  /// Unpin tất cả messages
  Future<void> _unpinAllMessages() async {
    try {
      final messages = _messageBox.values.toList();
      for (final message in messages) {
        if (message.pinned) {
          final unpinnedMessage = message.copyWith(pinned: false);
          _messageBox.put(message.id, unpinnedMessage);
        }
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to unpin all messages: $e');
    }
  }

  /// Lấy message theo ID
  Future<Message?> getMessage(String id) async {
    try {
      final getMessageUseCase = ref.read(getMessageProvider);
      return await getMessageUseCase.call(id);
    } catch (e) {
      state = state.copyWith(error: 'Failed to get message: $e');
      return null;
    }
  }

  /// Toggle pin status của message
  Future<bool> togglePin(String id) async {
    try {
      final message = await getMessage(id);
      if (message == null) return false;

      // Nếu message hiện tại đã được ghim, chỉ cần unpin nó
      if (message.pinned) {
        final unpinnedMessage = message.copyWith(pinned: false);
        _messageBox.put(id, unpinnedMessage);
        return true;
      }

      // Nếu message chưa được ghim, unpin tất cả messages khác trước
      await _unpinAllMessages();

      // Sau đó pin message này
      final pinnedMessage = message.copyWith(pinned: true);
      _messageBox.put(id, pinnedMessage);
      await WidgetService.updateWidget(content: pinnedMessage.content);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to toggle pin: $e');
      return false;
    }
  }

  /// Lấy featured message (random hoặc latest)
  Future<void> refreshFeaturedMessage(String mode) async {
    try {
      Message? featured;

      if (mode == 'random') {
        final randomMessageUseCase = ref.read(randomMessageProvider);
        featured = await randomMessageUseCase.call();
      } else {
        final latestMessageUseCase = ref.read(latestMessageProvider);
        featured = await latestMessageUseCase.call();
      }

      state = state.copyWith(featuredMessage: featured);
    } catch (e) {
      state = state.copyWith(error: 'Failed to refresh featured message: $e');
    }
  }

  /// Lấy danh sách messages đã pin
  List<Message> getPinnedMessages() {
    return state.messages.where((message) => message.pinned).toList();
  }

  /// Lấy danh sách messages gần đây (không pin)
  List<Message> getRecentMessages() {
    return state.messages.where((message) => !message.pinned).toList();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh tất cả data
  Future<void> refresh() async {
    await _loadMessages();
  }

  @override
  void dispose() {
    _boxSubscription.cancel();
    super.dispose();
  }
}

/// Provider instance
final messageProvider = StateNotifierProvider<MessageProvider, MessageState>((
  ref,
) {
  return MessageProvider(ref);
});

/// Convenience providers để dễ sử dụng
final messagesListProvider = Provider<List<Message>>((ref) {
  return ref.watch(messageProvider).messages;
});

final isLoadingMessagesProvider = Provider<bool>((ref) {
  return ref.watch(messageProvider).isLoading;
});

final messageErrorProvider = Provider<String?>((ref) {
  return ref.watch(messageProvider).error;
});

final featuredMessageProvider = Provider<Message?>((ref) {
  return ref.watch(messageProvider).featuredMessage;
});

final isCreatingMessageProvider = Provider<bool>((ref) {
  return ref.watch(messageProvider).isCreating;
});

final isUpdatingMessageProvider = Provider<bool>((ref) {
  return ref.watch(messageProvider).isUpdating;
});

final isDeletingMessageProvider = Provider<bool>((ref) {
  return ref.watch(messageProvider).isDeleting;
});

final pinnedMessagesProvider = Provider<List<Message>>((ref) {
  final messages = ref.watch(messageProvider).messages;
  return messages.where((message) => message.pinned).toList();
});
