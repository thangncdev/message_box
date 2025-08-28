import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

class HomeState {
  final AsyncValue<Message?> featured;
  final AsyncValue<List<Message>> recent;

  const HomeState({
    this.featured = const AsyncValue.loading(),
    this.recent = const AsyncValue.loading(),
  });

  HomeState copyWith({
    AsyncValue<Message?>? featured,
    AsyncValue<List<Message>>? recent,
  }) => HomeState(
    featured: featured ?? this.featured,
    recent: recent ?? this.recent,
  );
}

class HomeController extends StateNotifier<HomeState> {
  final Ref ref;
  HomeController(this.ref) : super(const HomeState()) {
    // Listen unified stream
    ref.listen<AsyncValue<List<Message>>>(messagesStreamProvider, (_, __) {
      refreshFeatured();
      refreshRecent();
    });
  }

  Future<void> refreshFeatured() async {
    final mode = ref.read(widgetModeProvider);
    state = state.copyWith(featured: const AsyncValue.loading());
    try {
      final message = mode == 'random'
          ? await ref.read(randomMessageProvider).call()
          : await ref.read(latestMessageProvider).call();
      state = state.copyWith(featured: AsyncValue.data(message));
    } catch (e, st) {
      state = state.copyWith(featured: AsyncValue.error(e, st));
    }
  }

  Future<void> refreshRecent() async {
    final streamVal = ref.read(messagesStreamProvider);
    state = state.copyWith(
      recent: streamVal.when(
        data: (items) => AsyncValue.data(items.take(5).toList()),
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      ),
    );
  }

  Future<void> onPinToggle(String id) async {
    final msg = await ref.read(getMessageProvider).call(id);
    if (msg == null) return;
    final willPin = !msg.pinned;
    if (willPin) {
      final list = await ref.read(listMessagesProvider).call();
      for (final m in list) {
        if (m.id != id && m.pinned) {
          await ref
              .read(updateMessageProvider)
              .call(
                m.copyWith(pinned: false, updatedAt: DateTime.now().toUtc()),
              );
        }
      }
    }
    await ref
        .read(updateMessageProvider)
        .call(msg.copyWith(pinned: willPin, updatedAt: DateTime.now().toUtc()));
    await refreshFeatured();
    await refreshRecent();
    await WidgetService.updateWidget(content: msg.content);
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController(ref);
  },
);
