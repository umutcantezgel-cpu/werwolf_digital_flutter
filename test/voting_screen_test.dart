import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/screens/voting_screen.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/config/theme.dart';
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

  MockGameProvider() {
    final player1 = Player(
        id: '1', name: 'Voter', role: RoleType.dorfbewohner, isAlive: true);
    final player2 =
        Player(id: '2', name: 'Suspect', role: RoleType.werwolf, isAlive: true);

    gameState = GameState.initial().copyWith(
      players: [player1, player2],
      roomCode: 'VOTE_TEST',
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
  testWidgets('VotingScreen renders correctly', (WidgetTester tester) async {
    final mockProvider = MockGameProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<GameProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const VotingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Check Header
    expect(find.text('ABSTIMMUNG'), findsOneWidget);

    // Check Timer
    expect(find.byType(TensionTimerWidget), findsOneWidget);

    // Check Players
    expect(find.text('Voter'), findsOneWidget);
    expect(find.text('Suspect'), findsOneWidget);

    // Select a player
    await tester.tap(find.text('Suspect'));
    await tester.pumpAndSettle();

    // Button appears
    expect(find.text('BESTÄTIGEN'), findsOneWidget);

    // Confirm Vote
    await tester.tap(find.text('BESTÄTIGEN'));
    await tester.pump();

    // SnackBar appears
    expect(find.text('Stimme abgegeben.'), findsOneWidget);
  });
}
