/// Ereignisse von der RoomRuntime an die Clients (für Toasts, Dialoge, Haptik).
///
/// Die Runtime sendet nie fertige Sätze, nur Typ + Argumente. Die App baut den
/// Text aus Lokalisierung + Szenario.
class GameEvent {
  final String type;

  /// Empfänger; `null` = alle im Raum.
  final String? to;
  final Map<String, dynamic> args;

  const GameEvent(this.type, {this.to, this.args = const {}});

  String? str(String k) => args[k] as String?;
  int? integer(String k) => (args[k] as num?)?.toInt();
  bool flag(String k) => args[k] == true;

  Map<String, dynamic> toJson() => {'type': type, if (to != null) 'to': to, 'args': args};

  factory GameEvent.fromJson(Map<String, dynamic> j) => GameEvent(
        j['type'] as String,
        to: j['to'] as String?,
        args: (j['args'] as Map? ?? const {}).cast<String, dynamic>(),
      );

  @override
  String toString() => 'GameEvent($type, to: $to, $args)';
}

/// Alle Ereignis-Typen. Argumente stehen jeweils dabei.
abstract final class Ev {
  /// {phase, chapter}
  static const phase = 'phase';

  /// {clue, hotspot?} – nur an den Finder
  static const clueFound = 'clue_found';

  /// {hotspot, by} – jemand anderes war schneller
  static const hotspotEmpty = 'hotspot_empty';

  /// {hotspot}
  static const nothingFound = 'nothing_found';

  /// {clue, by}
  static const clueShared = 'clue_shared';

  /// {clue}
  static const clueEvolved = 'clue_evolved';

  /// {clue, player} – Schatten hat ungesicherte Notizen beschädigt/gestohlen
  static const clueLost = 'clue_lost';

  /// {count} – Spuren sind verblasst
  static const cluesFaded = 'clues_faded';

  /// {combo, by}
  static const combo = 'combo';

  /// {} – passt nicht zusammen
  static const comboFail = 'combo_fail';

  /// {npc} – Verhör geöffnet
  static const dialogueOpen = 'dialogue_open';

  /// {npc, topic, line, lie?, clue?} – `line` ist der Schlüssel in `SuspectDef.lines`
  static const dialogue = 'dialogue';

  /// {npc, reason: silenced|dead|busy}
  static const dialogueRefused = 'dialogue_refused';

  /// {npc, clue, reaction: nervous|annoyed|neutral}
  static const present = 'present';

  /// {npc, by} – Widerspruch aufgedeckt (Beweisstärke +1)
  static const contradiction = 'contradiction';

  /// {player, effect, on}
  static const effect = 'effect';

  /// {player}
  static const attacked = 'attacked';

  /// {player}
  static const downed = 'downed';

  /// {player, by}
  static const revived = 'revived';

  /// {player}
  static const died = 'died';

  /// {npc}
  static const npcKilled = 'npc_killed';

  /// {by?, reason: group|scare|flare}
  static const shadowRepelled = 'shadow_repelled';

  /// {} – an einen Spieler, wenn der Schatten nah ist (Herzschlag)
  static const shadowNear = 'shadow_near';

  /// {lead}
  static const leadChosen = 'lead_chosen';

  /// {by, kind, value, x?, y?}
  static const signal = 'signal';

  /// {item, type, by}
  static const itemPicked = 'item_picked';

  /// {type, by}
  static const itemUsed = 'item_used';

  /// {player, ability}
  static const ability = 'ability';

  /// {hotspot, x, y} – Journalistin: Quelle markiert
  static const sources = 'sources';

  /// {count}
  static const labDone = 'lab_done';

  /// {player, hidden}
  static const hide = 'hide';

  /// {}
  static const ending = 'ending';

  /// {key} – z. B. not_host, too_far, inventory_full, cooldown, not_in_phase
  static const error = 'error';
}
