import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/home/widgets/confirm_delete.dart';
import 'package:message_box/presentation/home/widgets/featured_section.dart';
import 'package:message_box/presentation/home/widgets/home_app_bar.dart';
import 'package:message_box/presentation/home/widgets/list_messages.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/add_new_message.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(messageProvider.notifier).refreshFeaturedMessage('latest');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableScreen(
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButton: AddNewMessageButton(
        onPressed: () async {
          final changed = await context.push<bool>('/compose');
          if (changed == true && mounted) {
            await ref
                .read(messageProvider.notifier)
                .refreshFeaturedMessage('latest');
          }
        },
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      showRefreshIndicator: true,
      onRefresh: () async {
        await ref
            .read(messageProvider.notifier)
            .refreshFeaturedMessage('latest');
      },
      children: [
        HomeAppBar(title: AppLocalizations.of(context)!.messagesTitle),
        const SizedBox(height: 12),
        const FeaturedSection(),
        const SizedBox(height: 16),
        ListMessages(
          onConfirmDelete: (context) => showConfirmDeleteDialog(context),
          onTogglePin: (m) async {
            await ref.read(messageProvider.notifier).togglePin(m.id);
          },
          onDeleted: (m) async {
            await ref.read(messageProvider.notifier).deleteMessage(m.id);
          },
        ),
      ],
    );
  }
}
