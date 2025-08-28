import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/home/home_controller.dart';
import 'package:message_box/presentation/home/widgets/confirm_delete.dart';
import 'package:message_box/presentation/home/widgets/featured_section.dart';
import 'package:message_box/presentation/home/widgets/list_messages.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/add_new_message.dart';
import 'package:message_box/services/widget_service.dart';

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
      ref.read(homeControllerProvider.notifier).refreshFeatured();
      ref.read(homeControllerProvider.notifier).refreshRecent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButton: AddNewMessageButton(
        onPressed: () async {
          final changed = await context.push<bool>('/compose');
          if (changed == true && mounted) {
            await ref.read(homeControllerProvider.notifier).refreshFeatured();
            await ref.read(homeControllerProvider.notifier).refreshRecent();
          }
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [palette.gradientStart, palette.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(homeControllerProvider.notifier).refreshFeatured();
              await ref.read(homeControllerProvider.notifier).refreshRecent();
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              children: [
                // Top bar
                Row(
                  children: [
                    SizedBox(width: 48, height: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'DearBox',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push('/setting'),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.messagesTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const FeaturedSection(),
                const SizedBox(height: 16),
                ListMessages(
                  onConfirmDelete: showConfirmDeleteDialog,
                  onTogglePin: (m) async => ref
                      .read(homeControllerProvider.notifier)
                      .onPinToggle(m.id),
                  onDeleted: (m) async {
                    await ref.read(deleteMessageProvider).call(m.id);
                    await ref
                        .read(homeControllerProvider.notifier)
                        .refreshFeatured();
                    await ref
                        .read(homeControllerProvider.notifier)
                        .refreshRecent();
                    final featured = await ref
                        .read(latestMessageProvider)
                        .call();
                    await WidgetService.updateWidget(
                      content: featured?.content,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
