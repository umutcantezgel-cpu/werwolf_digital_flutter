import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/screens/day_screen.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/config/theme.dart';
import 'package:werwolf_digital_flutter/config/constants.dart'; // GamePhase
import 'package:werwolf_digital_flutter/widgets/death_announcement_overlay.dart';
import 'package:werwolf_digital_flutter/widgets/tension_timer_widget.dart';

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
    List<String> deadPlayerIds = const [],
  }) {
    final player1 = Player(
        id: '1', name: 'AliveUser', role: RoleType.dorfbewohner, isAlive: true);
    final player2 = Player(
        id: '2',
        name: 'DeadVictim',
        role: RoleType.dorfbewohner,
        isAlive: false);

    gameState = GameState.initial().copyWith(
      players: [player1, player2],
      roomCode: 'TEST',
      gamePhase: GamePhase.day,
      deadPlayerIdsThisRound: deadPlayerIds,
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
  testWidgets('DayScreen shows Peaceful Morning if no one died',
      (WidgetTester tester) async {
    final mockProvider = MockGameProvider(deadPlayerIds: []);

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.lightTheme, // Day theme
          home: const DayScreen(),
        ),
      ),
    );

    await tester.pump(); // Build

    // Check overlay present initially
    expect(find.byType(DeathAnnouncementOverlay), findsOneWidget);

    // Peaceful Message
    expect(find.text('EIN NEUER MORGEN'), findsOneWidget);
    expect(find.text('Niemand ist gestorben.'), findsOneWidget);

    // Wait for auto-dismiss (simulated)
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Overlay should be gone
    expect(find.byType(DeathAnnouncementOverlay), findsNothing);

    // Day Content visible
    expect(find.text('DISKUSSION'), findsOneWidget);
    expect(find.byType(TensionTimerWidget), findsOneWidget);
  });

  testWidgets('DayScreen shows Tragedy if players died',
      (WidgetTester tester) async {
    final mockProvider =
        MockGameProvider(deadPlayerIds: ['2']); // Player 2 is dead

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const DayScreen(),
        ),
      ),
    );

    await tester.pump();

    // Tragedy Message
    expect(find.text('TRAGÖDIE!'), findsOneWidget);
    expect(find.text('DeadVictim ist tot.'), findsOneWidget);

    // Close overlay manually via timer or verify auto-close
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.byType(DeathAnnouncementOverlay), findsNothing);

    // Graveyard check
    expect(find.text('Friedhof (1)'), findsOneWidget);
    expect(find.text('DeadVictim'), findsOneWidget);
  });
}
