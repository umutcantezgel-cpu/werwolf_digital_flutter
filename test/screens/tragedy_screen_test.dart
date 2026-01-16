import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/screens/tragedy_screen.dart';

// Mock GameProvider
class MockGameProvider extends GameProvider {
  @override
  GameState get gameState => GameState.initial().copyWith(
        lastKilledPlayerId: 'p1',
        players: [
          Player(id: 'p1', name: 'Hans', isAlive: false),
        ],
      );
}

void main() {
  setUp(() {
    Animate.restartOnHotReload = true;
    Animate.defaultDuration = Duration.zero;
  });

  testWidgets('TragedyScreen renders correctly', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>(
            create: (_) => MockGameProvider(),
          ),
        ],
        child: const MaterialApp(
          home: TragedyScreen(isTesting: true),
        ),
      ),
    );

    // Verify "TRAGÖDIE" text is present
    expect(find.text('TRAGÖDIE'), findsOneWidget);

    // Verify text content
    expect(find.text('TRAGÖDIE'), findsOneWidget);
    expect(find.text('HANS'), findsOneWidget); // Uppercased in UI

    // Verify subtitle
    expect(find.text('ist tot.'), findsOneWidget);

    // Verify background gradient container exists
    expect(find.byType(Container), findsWidgets);

    // Teardown: Remove widgets to dispose infinite animations
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
