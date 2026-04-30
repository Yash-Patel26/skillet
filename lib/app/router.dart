import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/favorites/presentation/favorites_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_shell.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/preferences/presentation/preferences_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/recipe_detail/presentation/recipe_detail_page.dart';
import '../features/cook_mode/presentation/cook_mode_page.dart';
import '../features/search/presentation/search_page.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: ref.read(prefsStoreProvider).onboardingDone
        ? '/home'
        : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/preferences',
        builder: (_, state) => PreferencesPage(
          isInitial: state.uri.queryParameters['initial'] == 'true',
        ),
      ),
      ShellRoute(
        builder: (ctx, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
          GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        ],
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (_, state) =>
            RecipeDetailPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/cook/:id',
        builder: (_, state) => CookModePage(id: state.pathParameters['id']!),
      ),
    ],
  );
});
