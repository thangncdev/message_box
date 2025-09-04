import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/home/home_screen.dart';
import 'package:message_box/presentation/detail/message_detail_screen.dart';
import 'package:message_box/presentation/composer/compose_screen.dart';
import 'package:message_box/presentation/setting/setting_screen.dart';
import 'package:message_box/presentation/more/more_screen.dart';
import 'package:message_box/presentation/onboarding/onboarding_screen.dart';
import 'package:message_box/presentation/guide/guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        path: '/more',
        name: 'more',
        builder: (context, state) => const MoreScreen(),
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
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/guide',
        name: 'guide',
        builder: (context, state) => const GuideScreen(),
      ),
    ],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('seen_onboarding') ?? false;
      final loggingInOnboarding = state.matchedLocation == '/onboarding';
      if (!seen && !loggingInOnboarding) {
        return '/onboarding';
      }
      return null;
    },
  );
});
