import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

class ComposeState {
  final String content;
  final String? error;

  const ComposeState({this.content = '', this.error});

  bool get canSave =>
      content.trim().isNotEmpty && content.trim().runes.length <= 280;

  ComposeState copyWith({String? content, String? error}) =>
      ComposeState(content: content ?? this.content, error: error);
}

class ComposeController extends StateNotifier<ComposeState> {
  final Ref ref;
  ComposeController(this.ref) : super(const ComposeState());

  void setContent(String value) {
    String? error;
    final trimmed = value.trim();
    final length = trimmed.runes.length;
    if (length == 0) error = 'Nội dung không được để trống';
    if (length > 280) error = 'Tối đa 280 ký tự';
    state = state.copyWith(content: value, error: error);
  }

  Future<void> saveNew() async {
    final trimmed = state.content.trim();
    if (trimmed.isEmpty || trimmed.runes.length > 280) return;

    final success = await ref
        .read(messageProvider.notifier)
        .createMessage(trimmed);
    if (success) {
      await WidgetService.updateWidget(content: trimmed);
    }
  }

  Future<void> saveEdit(String id) async {
    final trimmed = state.content.trim();
    if (trimmed.isEmpty || trimmed.runes.length > 280) return;

    final success = await ref
        .read(messageProvider.notifier)
        .updateMessage(id, trimmed);
    if (success) {
      await WidgetService.updateWidget(content: trimmed);
    }
  }
}

final composeControllerProvider =
    StateNotifierProvider<ComposeController, ComposeState>((ref) {
      return ComposeController(ref);
    });
