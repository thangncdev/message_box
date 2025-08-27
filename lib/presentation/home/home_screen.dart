import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/presentation/home/home_controller.dart';
import 'package:message_box/presentation/home/widgets/home_body.dart';
import 'package:message_box/l10n/app_localizations.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/setting'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed = await context.push<bool>('/compose');
          if (changed == true && mounted) {
            await ref.read(homeControllerProvider.notifier).refreshFeatured();
            await ref.read(homeControllerProvider.notifier).refreshRecent();
          }
        },
        child: const Icon(Icons.edit_rounded),
      ),
      body: const HomeBody(),
    );
  }
}
