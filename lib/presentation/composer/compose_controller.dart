import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

final int maxLength = 1000;

class ComposeState {
  final String content;
  final String? error;

  const ComposeState({this.content = '', this.error});

  bool get canSave =>
      content.trim().isNotEmpty && content.trim().runes.length <= maxLength;

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
    if (length > maxLength) error = 'Tối đa $maxLength ký tự';
    state = state.copyWith(content: value, error: error);
  }

    Future<bool> saveNew() async {
    final trimmed = state.content.trim();
    if (trimmed.isEmpty || trimmed.runes.length > maxLength) return false;

    final success = await ref
        .read(messageProvider.notifier)
        .createMessage(trimmed);
    if (success) {
      await WidgetService.updateWidget(content: trimmed);
    }
    return success;
  }

  Future<bool> saveEdit(String id) async {
    final trimmed = state.content.trim();
    if (trimmed.isEmpty || trimmed.runes.length > maxLength) 
    return false;

    final success = await ref
        .read(messageProvider.notifier)
        .updateMessage(id, trimmed);
    if (success) {
      await WidgetService.updateWidget(content: trimmed);
    }
    return success;
  }
}

final composeControllerProvider =
    StateNotifierProvider<ComposeController, ComposeState>((ref) {
      return ComposeController(ref);
    });
