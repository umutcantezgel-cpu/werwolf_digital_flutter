import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/screens/victory_screen.dart';
import 'package:werwolf_digital_flutter/services/network_service.dart';

// Mock NetworkService to prevent real connection attempts
class MockNetworkService extends NetworkService {
  MockNetworkService() : super('http://localhost:3000');
  @override
  void connect() {}
  @override
  void disconnect() {}
  @override
  void dispose() {}
}

// Mock GameProvider for Village Win
class MockVillageWinGameProvider extends GameProvider {
  MockVillageWinGameProvider() : super(networkService: MockNetworkService());

  @override
  GameState get gameState => GameState.initial().copyWith(
        narration: 'Das Dorf hat gewonnen!',
      );
}

// Mock GameProvider for Werewolf Win
class MockWerewolfWinGameProvider extends GameProvider {
  MockWerewolfWinGameProvider() : super(networkService: MockNetworkService());

  @override
  GameState get gameState => GameState.initial().copyWith(
        narration:
            'Die Werwölfe müssen herrschen!', // Matches "Die Werwölfe" check
      );
}

void main() {
  testWidgets('VictoryScreen renders Village Win correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>(
            create: (_) => MockVillageWinGameProvider(),
          ),
        ],
        child: const MaterialApp(
          home: VictoryScreen(isTesting: true),
        ),
      ),
    );

    // Verify Village Win Title
    expect(find.text('SIEG FÜR DAS DORF'), findsOneWidget);
    expect(find.text('Das Böse wurde vertrieben.'), findsOneWidget);
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
  });

  testWidgets('VictoryScreen renders Werewolf Win correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>(
            create: (_) => MockWerewolfWinGameProvider(),
          ),
        ],
        child: const MaterialApp(
          home: VictoryScreen(isTesting: true),
        ),
      ),
    );

    // Wait for animations (even if stripped, good for stability)
    await tester.pump(const Duration(seconds: 1));
    // Verify Werewolf Win Title
    expect(find.text('DIE WÖLFE HERRSCHEN'), findsOneWidget);
    expect(find.text('Niemand hat überlebt.'), findsOneWidget);
    expect(find.byIcon(Icons.nights_stay), findsOneWidget);

    // Pump to settle any non-looping animations/timers before disposal
    await tester.pump(const Duration(seconds: 5));
  });
}
