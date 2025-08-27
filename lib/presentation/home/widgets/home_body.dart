import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/home/home_controller.dart';
import 'package:message_box/presentation/home/widgets/featured_section.dart';
import 'package:message_box/presentation/home/widgets/list_messages.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/home/widgets/confirm_delete.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeControllerProvider.notifier).refreshFeatured();
        await ref.read(homeControllerProvider.notifier).refreshRecent();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const FeaturedSection(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.messagesTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          ListMessages(
            onConfirmDelete: showConfirmDeleteDialog,
            onTogglePin: (m) async =>
                ref.read(homeControllerProvider.notifier).onPinToggle(m.id),
            onDeleted: (m) async {
              await ref.read(deleteMessageProvider).call(m.id);
              await ref.read(homeControllerProvider.notifier).refreshFeatured();
              await ref.read(homeControllerProvider.notifier).refreshRecent();
              final mode = ref.read(widgetModeProvider);
              final featured = mode == 'random'
                  ? await ref.read(randomMessageProvider).call()
                  : await ref.read(latestMessageProvider).call();
              await WidgetService.saveWidgetState(mode: mode);
              await WidgetService.updateWidget(
                messageId: featured?.id,
                content: featured?.content ?? 'No message yet. Open DearBox.',
              );
            },
          ),
        ],
      ),
    );
  }
}
