import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/presentation/home/home_screen.dart';
import 'package:message_box/presentation/detail/message_detail_screen.dart';
import 'package:message_box/presentation/composer/compose_screen.dart';
import 'package:message_box/presentation/setting/setting_screen.dart';
import 'package:message_box/presentation/more/more_screen.dart';
import 'package:message_box/presentation/onboarding/onboarding_screen.dart';
import 'package:message_box/presentation/guide/guide_screen.dart';
import 'package:message_box/presentation/language_selection/language_selection_screen.dart';
import 'package:message_box/presentation/test/test_screen.dart';
import 'package:message_box/services/shared_preferences_service.dart';
import 'package:message_box/presentation/suggestion_quotes/suggestion_quotes.dart';

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
        path: '/language-selection',
        name: 'language-selection',
        builder: (context, state) => const LanguageSelectionScreen(),
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
      GoRoute(
        path: '/suggestion-quotes',
        name: 'suggestion-quotes',
        builder: (context, state) => const SuggestionQuotesScreen(),
      ),
      GoRoute(
        path: '/test-screen',
        name: 'test-screen',
        builder: (context, state) => const TutorialExample(),
      ),
    ],
    redirect: (context, state) async {
      final prefsService = await SharedPreferencesService.getInstance();
      final hasLanguage = prefsService.hasSelectedLanguage();
      final seenOnboarding = prefsService.getSeenOnboarding();

      final isOnLanguageSelection =
          state.matchedLocation == '/language-selection';
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      // If no language selected, go to language selection
      if (!hasLanguage && !isOnLanguageSelection) {
        return '/language-selection';
      }

      // If language selected but haven't seen onboarding, go to onboarding
      if (hasLanguage && !seenOnboarding && !isOnOnboarding) {
        return '/onboarding';
      }

      return null;
    },
  );
});
