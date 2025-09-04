import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/composer/compose_controller.dart';
import 'package:message_box/presentation/providers.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  final String? messageId;
  const ComposeScreen({super.key, this.messageId});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.messageId != null) {
        final m = await ref
            .read(messageProvider.notifier)
            .getMessage(widget.messageId!);
        if (m != null) {
          _ctrl.text = m.content;
          ref.read(composeControllerProvider.notifier).setContent(m.content);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composeControllerProvider);
    final isEdit = widget.messageId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? AppLocalizations.of(context)!.editMessage
              : AppLocalizations.of(context)!.newMessage,
        ),
        actions: [
          TextButton(
            onPressed: state.canSave
                ? () async {
                    if (isEdit) {
                      await ref
                          .read(composeControllerProvider.notifier)
                          .saveEdit(widget.messageId!);
                    } else {
                      await ref
                          .read(composeControllerProvider.notifier)
                          .saveNew();
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEdit
                                ? AppLocalizations.of(context)!.updated
                                : AppLocalizations.of(context)!.saved,
                          ),
                        ),
                      );
                      context.pop(true);
                    }
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              autofocus: !isEdit,
              maxLines: null,
              minLines: 6,
              onChanged: (v) =>
                  ref.read(composeControllerProvider.notifier).setContent(v),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.writeSomething,
                errorText: state.error,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: '${_ctrl.text.trim().runes.length}/280',
              ),
            ),
            const SizedBox(height: 8),
            if (isEdit)
              Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder(
                  future: ref
                      .read(messageProvider.notifier)
                      .getMessage(widget.messageId!),
                  builder: (context, snapshot) {
                    final updatedAt =
                        snapshot.data?.updatedAt ?? snapshot.data?.createdAt;
                    if (updatedAt == null) return const SizedBox.shrink();
                    return Text(
                      '${AppLocalizations.of(context)!.updated}: ${formatRelative(updatedAt, context)}',
                      style: const TextStyle(color: Colors.black54),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
