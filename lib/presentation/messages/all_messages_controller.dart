import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/domain/repositories/message_repository.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

class AllMessagesState {
  final String query;
  final MessageSort sortOrder;
  final AsyncValue<List<Message>> list;

  const AllMessagesState({
    this.query = '',
    this.sortOrder = MessageSort.newest,
    this.list = const AsyncValue.loading(),
  });

  AllMessagesState copyWith({
    String? query,
    MessageSort? sortOrder,
    AsyncValue<List<Message>>? list,
  }) => AllMessagesState(
    query: query ?? this.query,
    sortOrder: sortOrder ?? this.sortOrder,
    list: list ?? this.list,
  );
}

class AllMessagesController extends StateNotifier<AllMessagesState> {
  final Ref ref;
  AllMessagesController(this.ref) : super(const AllMessagesState()) {
    ref.listen<AsyncValue<List<Message>>>(messagesStreamProvider, (_, __) {
      refresh();
    });
  }

  Future<void> refresh() async {
    final streamVal = ref.read(messagesStreamProvider);
    state = state.copyWith(
      list: streamVal.when(
        data: (items) {
          // apply search + sort + pinned-first in-memory
          List<Message> filtered = items;
          if (state.query.trim().isNotEmpty) {
            final q = state.query.trim().toLowerCase();
            filtered = filtered
                .where((m) => m.content.toLowerCase().contains(q))
                .toList();
          }
          // sort by createdAt
          filtered.sort(
            (a, b) => state.sortOrder == MessageSort.newest
                ? b.createdAt.compareTo(a.createdAt)
                : a.createdAt.compareTo(b.createdAt),
          );
          // pinned-first grouping
          final pinned = filtered.where((m) => m.pinned).toList();
          final others = filtered.where((m) => !m.pinned).toList();
          return AsyncValue.data([...pinned, ...others]);
        },
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      ),
    );
  }

  Future<void> search(String q) async {
    state = state.copyWith(query: q);
    await refresh();
  }

  Future<void> setSort(MessageSort order) async {
    state = state.copyWith(sortOrder: order);
    await refresh();
  }

  Future<void> delete(String id) async {
    await ref.read(deleteMessageProvider).call(id);
    await refresh();
    // bump refresh tick so Home can sync
    ref.read(refreshTickProvider.notifier).state++;
    await _updateHomeWidget();
  }

  Future<void> pinToggle(String id) async {
    final msg = await ref.read(getMessageProvider).call(id);
    if (msg == null) return;
    final willPin = !msg.pinned;
    await ref
        .read(updateMessageProvider)
        .call(msg.copyWith(pinned: willPin, updatedAt: DateTime.now().toUtc()));
    await refresh();
    ref.read(refreshTickProvider.notifier).state++;
    await _updateHomeWidget();
  }

  Future<void> _updateHomeWidget() async {
    final mode = ref.read(widgetModeProvider);
    final featured = mode == 'random'
        ? await ref.read(randomMessageProvider).call()
        : await ref.read(latestMessageProvider).call();
    await WidgetService.saveWidgetState(mode: mode);
    await WidgetService.updateWidget(
      messageId: featured?.id,
      content: featured?.content ?? 'No message yet. Open DearBox.',
    );
  }
}

final allMessagesControllerProvider =
    StateNotifierProvider<AllMessagesController, AllMessagesState>((ref) {
      return AllMessagesController(ref);
    });
