import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/home/home_screen.dart';
import 'package:message_box/presentation/detail/message_detail_screen.dart';
import 'package:message_box/presentation/composer/compose_screen.dart';
import 'package:message_box/presentation/setting/setting_screen.dart';

/// Centralized app router using go_router
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/compose',
        name: 'compose',
        builder: (context, state) => const ComposeScreen(),
      ),
      GoRoute(
        path: '/setting',
        name: 'setting',
        builder: (context, state) => const SettingScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MessageDetailScreen(messageId: id);
        },
      ),
      GoRoute(
        path: '/edit/:id',
        name: 'edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ComposeScreen(messageId: id);
        },
      ),
    ],
  );
});
