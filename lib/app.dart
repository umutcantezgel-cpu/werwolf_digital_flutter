import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/lobby_screen.dart';
import 'screens/role_reveal_screen.dart';
import 'screens/game_screen.dart';
import 'screens/solo_mode_screen.dart';
import 'screens/solo_lobby_screen.dart';
import 'screens/training_screen.dart';
import 'screens/challenges_screen.dart';
import 'screens/victory_screen.dart';

import 'services/snack_bar_service.dart';
import '_app_life_cycle_observer.dart';

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/solo',
      builder: (context, state) => const SoloModeScreen(),
    ),
    GoRoute(
      path: '/solo-lobby',
      builder: (context, state) => const SoloLobbyScreen(),
    ),
    GoRoute(
      path: '/training',
      builder: (context, state) => const TrainingScreen(),
    ),
    GoRoute(
      path: '/challenges',
      builder: (context, state) => const ChallengesScreen(),
    ),
    GoRoute(
      path: '/lobby/:code',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        return LobbyScreen(roomCode: code);
      },
    ),
    GoRoute(
      path: '/role-reveal',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const RoleRevealScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/game/:code',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        return GameScreen(roomCode: code);
      },
    ),
    GoRoute(
      path: '/victory',
      builder: (context, state) => const VictoryScreen(),
    ),
  ],
);

class WerwolfApp extends StatefulWidget {
  const WerwolfApp({super.key});

  @override
  State<WerwolfApp> createState() => _WerwolfAppState();
}

class _WerwolfAppState extends State<WerwolfApp> with WidgetsBindingObserver {
  late AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver(context);
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Werwolf Digital',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
        );
      },
    );
  }
}
