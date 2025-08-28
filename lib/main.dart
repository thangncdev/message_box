import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/services/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetService.init();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');
  runApp(const ProviderScope(child: DearBoxApp()));
}

class DearBoxApp extends ConsumerWidget {
  const DearBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);
    final themeKey = ref.watch(currentThemeKeyProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: buildAppTheme(themeKey),
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
