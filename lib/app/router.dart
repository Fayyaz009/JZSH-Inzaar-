import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/games/games_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lesson/lesson_screen.dart';
import '../features/module/module_screen.dart';
import '../features/parent/parent_screen.dart';
import '../features/rhymes/rhymes_screen.dart';
import '../features/splash/splash_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/module/:moduleKey',
        builder: (context, state) => ModuleScreen(
          moduleKey: state.pathParameters['moduleKey'] ?? '',
        ),
      ),
      GoRoute(
        path: '/lesson/:moduleKey/:itemKey',
        builder: (context, state) => LessonScreen(
          moduleKey: state.pathParameters['moduleKey'] ?? '',
          itemKey: state.pathParameters['itemKey'] ?? '',
        ),
      ),
      GoRoute(
        path: '/games',
        builder: (context, state) => const GamesScreen(),
      ),
      GoRoute(
        path: '/rhymes',
        builder: (context, state) => const RhymesScreen(),
      ),
      GoRoute(
        path: '/parent',
        builder: (context, state) => const ParentScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Oops! Page not found.')),
    ),
  );
}
