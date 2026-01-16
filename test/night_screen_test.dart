import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/screens/night_screen.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/config/theme.dart';
import 'package:werwolf_digital_flutter/config/constants.dart'; // GamePhase
import 'package:werwolf_digital_flutter/widgets/moon_widget.dart';
import 'package:werwolf_digital_flutter/widgets/night_effects.dart'; // NEW
import 'package:werwolf_digital_flutter/widgets/night_sky_background.dart';

import 'package:werwolf_digital_flutter/models/night_action.dart';
import 'package:werwolf_digital_flutter/services/network_service.dart';
import 'package:werwolf_digital_flutter/services/bot_manager.dart';
import 'package:werwolf_digital_flutter/models/chat_message.dart';

// Mock GameProvider
class MockGameProvider extends ChangeNotifier implements GameProvider {
  @override
  GameState gameState = GameState.initial();
  @override
  bool isHost = false;
  @override
  String? myPlayerId = '1';

  @override
  ServerConnectionState get connectionState => ServerConnectionState.connected;

  MockGameProvider({
    RoleType role = RoleType.dorfbewohner,
    bool isAlive = true,
  }) {
    final player =
        Player(id: '1', name: 'Tester', role: role, isAlive: isAlive);
    final other = Player(id: '2', name: 'Victim', role: RoleType.dorfbewohner);
    gameState = GameState.initial().copyWith(
      players: [player, other],
      roomCode: 'TEST',
      gamePhase: GamePhase.night,
    );
  }

  // Stubs
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
  void submitNightAction(ActionType action, String? targetId) {}
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
  testWidgets('NightScreen shows passive UI for Villager',
      (WidgetTester tester) async {
    final mockProvider = MockGameProvider(role: RoleType.dorfbewohner);

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const NightScreen(),
        ),
      ),
    );

    // Initial build
    await tester.pump();

    // Check for NightSky and Moon
    expect(find.byType(NightSkyBackground), findsOneWidget);
    expect(find.byType(MoonWidget), findsOneWidget);

    // Check for passive text
    expect(find.text('DIE NACHT'), findsOneWidget);
    expect(find.text('Schließe deine Augen...'), findsOneWidget);

    // Ensure no active role UI
    expect(find.text('BESTÄTIGEN'), findsNothing);

    // Teardown infinite animations
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('NightScreen shows active UI for Werwolf',
      (WidgetTester tester) async {
    final mockProvider = MockGameProvider(role: RoleType.werwolf);

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const NightScreen(),
        ),
      ),
    );

    // Use finite pump instead of pumpAndSettle due to infinite animations
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Check for active text
    expect(find.text('WÄHLE EIN OPFER'), findsOneWidget);

    // Check for HeartbeatOverlay
    expect(find.byType(HeartbeatOverlay), findsOneWidget);

    // Check for player grid (Active content)
    expect(find.byType(GridView), findsOneWidget);

    // Teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('NightScreen shows Seer UI with Mist',
      (WidgetTester tester) async {
    final mockProvider = MockGameProvider(role: RoleType.seherin);

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const NightScreen(),
        ),
      ),
    );

    // Use finite pump
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Check for active text
    expect(find.text('WESSEN IDENTITÄT MÖCHTEST DU SEHEN?'), findsOneWidget);

    // Check for SeerMistOverlay
    expect(find.byType(SeerMistOverlay), findsOneWidget);

    // Teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
