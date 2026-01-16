import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:werwolf_digital_flutter/screens/role_reveal_screen.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/models/night_action.dart';
import 'package:werwolf_digital_flutter/widgets/cinematic_role_reveal.dart';
import 'package:werwolf_digital_flutter/services/network_service.dart';
import 'package:werwolf_digital_flutter/services/bot_manager.dart';
import 'package:werwolf_digital_flutter/models/chat_message.dart';

import 'package:werwolf_digital_flutter/config/constants.dart';
import 'package:werwolf_digital_flutter/config/theme.dart';
import 'package:werwolf_digital_flutter/providers/skin_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock GameProvider? Or just use real one? Real one is easier if no external deps block it.
// GameProvider does NetworkService connect in constructor. That might be bad for tests.
// For widget tests, it's better to Mock or use a test-friendly subclass.

class MockGameProvider extends ChangeNotifier implements GameProvider {
  @override
  GameState gameState = GameState.initial();

  @override
  bool isHost = false;

  @override
  String? myPlayerId = '1';

  MockGameProvider() {
    // Setup minimal state for RoleReveal
    final player = Player(id: '1', name: 'Tester', role: RoleType.werwolf);
    gameState = GameState.initial().copyWith(
        players: [player], roomCode: 'TEST', gamePhase: GamePhase.roleReveal);
  }

  @override
  void joinLobby(String name, String id, String code) {}

  @override
  void createLobby(String name, String id) {}

  @override
  void startGame() {}

  @override
  void nextPhase() {}

  @override
  void resetGame() {}

  @override
  ServerConnectionState get connectionState => ServerConnectionState.connected;

  @override
  void submitNightAction(ActionType type, String? targetId) {}

  @override
  void submitVote(String targetId) {}

  @override
  List<ChatMessage> get chatHistory => [];

  @override
  void addMessage(ChatMessage msg) {}

  @override
  BotManager? get botManager => null;

  @override
  bool get isSoloMode => false;

  @override
  Future<void> startSoloGame(SoloModeConfig config,
      {RoleType? fixedRole}) async {}

  @override
  Future<void> startScenario(Object scenario) async {}
  @override
  void startSoloMatch() {}
}

void main() {
  setUp(() {
    Animate.restartOnHotReload = true;
    // Global Disable Animations for Tests to prevent "Timer Detected" / "Deactivated Ancestor" errors
    Animate.defaultDuration = Duration.zero;
    SharedPreferences.setMockInitialValues({}); // Mock SharedPreferences
  });

  testWidgets('RoleRevealScreen shows card and flips on tap',
      (WidgetTester tester) async {
    // Set huge size using legacy API which is sometimes more reliable in tests
    // tester.binding.window.physicalSizeTestValue = const Size(2048, 3072);
    // tester.binding.window.devicePixelRatioTestValue = 1.0;
    // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    // addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    // Using new API as per lints
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final mockProvider = MockGameProvider();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RoleRevealScreen(isTesting: true),
        ),
        GoRoute(
            path: '/game/TEST',
            builder: (context, state) =>
                const Scaffold(body: Text('Game Screen'))),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>.value(value: mockProvider),
          ChangeNotifierProvider<SkinProvider>(create: (_) => SkinProvider()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.darkTheme, // Includes WerwolfThemeExtension
        ),
      ),
    );

    // Verify initial state: Card back is visible
    expect(find.byType(CinematicRoleReveal), findsOneWidget);
    expect(find.text('VERSTANDEN'),
        findsNothing); // Button hidden initially (it's on the front/revealed side)

    // Tap the card to flip
    await tester.tap(find.byType(CinematicRoleReveal));

    // Tap the card to flip
    await tester.tap(find.byType(CinematicRoleReveal));

    // Wait for animation frame
    await tester.pump();
    await tester.pumpAndSettle(); // Should settle instantly now

    // Verify button appears (part of the RoleCard front)
    expect(find.text('VERSTANDEN'), findsOneWidget);

    // Tap button
    await tester.tap(find.text('VERSTANDEN'));
    await tester.pump(); // Handle navigation

    // Teardown: Remove widgets to dispose infinite animations
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1)); // Allow disposal to process
  });
}
