import 'dart:math';
import '../models/game_state.dart';
import '../models/role.dart';
import '../config/constants.dart';

class NarrativeService {
  final Random _random = Random();

  String generateNarration(GameState gameState) {
    switch (gameState.gamePhase) {
      case GamePhase.lobby:
        return 'Willkommen in Düsterwald. Wir warten auf weitere Mutige...';

      case GamePhase.roleDistribution:
        return 'Das Schicksal wird nun entschieden. Ich verteile die Rollen...';

      case GamePhase.roleReveal:
        return 'Schaut jetzt auf eure Karten. Wisst ihr, wer ihr seid? Merkt es euch gut!';

      case GamePhase.firstNight:
        return 'Die Nacht bricht herein. Alle schließen die Augen. Amor, erwache und wähle die Liebenden.';

      case GamePhase.night:
        return _getNightIntro(gameState.round);

      case GamePhase.dawn:
        // Already handled by GameEngine logic mostly, but we can enhance it here
        // The GameEngine passes specific event results (who died), so we might just return that
        // OR we can make this smarter. For now, let's keep the engine's result but maybe prefix it.
        return gameState.narration;

      case GamePhase.day:
        return 'Der Tag beginnt. Das Dorf erwacht. Diskutiert! Wer verhält sich verdächtig?';

      case GamePhase.nomination:
        return 'Die Diskussion endet. Wen wollt ihr anklagen? Nennt eure Verdächtigen.';

      case GamePhase.defense:
        return 'Der Angeklagte darf nun sprechen. Verteidige dich!';

      case GamePhase.voting:
        return 'Es ist Zeit für das Urteil. Hebt die Hand für schuldig, oder lasst sie unten für unschuldig.';

      case GamePhase.execution:
        return "Die Entscheidung ist gefallen.";
      case GamePhase.tragedy:
        return "Eine Tragödie hat sich ereignet.";
      case GamePhase.victory:
        return "Das Spiel ist vorbei.";
      case GamePhase.gameOver:
        return "Spielende.";
    }
  }

  String _getNightIntro(int round) {
    if (round == 1) {
      return 'Die Nacht legt sich über das Dorf. Werwölfe, erwacht und sucht euer erstes Opfer!';
    }
    final intros = [
      'Wieder wird es dunkel. Die Gefahr lauert im Schatten.',
      'Der Mond steht hoch. Die Werwölfe sind hungrig.',
      'Eine weitere unheimliche Nacht beginnt.',
    ];
    return intros[_random.nextInt(intros.length)];
  }

  String getDeathNarration(String victimName, RoleType role) {
    final templates = [
      '$victimName wurde heute Nacht brutal ermordet.',
      'Wir fanden $victimName heute Morgen tot auf.',
      'Ein schrecklicher Fund: $victimName ist nicht mehr unter uns.',
    ];
    return templates[_random.nextInt(templates.length)];
  }
}
