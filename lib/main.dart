import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetService.init();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');
  await _seedIfFirstLaunch();
  runApp(const ProviderScope(child: DearBoxApp()));
}

class DearBoxApp extends ConsumerWidget {
  const DearBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: buildAppTheme(),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
    );
  }
}

Future<void> _seedIfFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final seeded = prefs.getBool('seeded') ?? false;
  if (seeded) return;
  final box = Hive.box<Message>('messages');
  final now = DateTime.now().toUtc();
  final samples = [
    Message(
      id: 'seed-1',
      content: 'Chúc bạn một ngày thật an yên 🌿',
      createdAt: now.subtract(const Duration(minutes: 5)),
      pinned: true,
    ),
    Message(
      id: 'seed-2',
      content: 'Uống nước và vươn vai nha 💧',
      createdAt: now.subtract(const Duration(minutes: 3)),
    ),
    Message(
      id: 'seed-3',
      content: 'Hít thở sâu, mọi chuyện sẽ ổn',
      createdAt: now.subtract(const Duration(minutes: 1)),
    ),
  ];
  for (final m in samples) {
    await box.put(m.id, m);
  }
  await prefs.setBool('seeded', true);
}
