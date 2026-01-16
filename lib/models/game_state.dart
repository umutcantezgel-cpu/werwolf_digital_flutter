import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/config/constants.dart';
import 'package:werwolf_digital_flutter/models/night_action.dart';

class GameState {
  final String roomCode;
  final List<Player> players;
  final GamePhase gamePhase;
  final int round;
  final String narration;

  // New fields for game logic
  final List<NightAction> nightActions;
  final List<String>
      pendingActionPlayerIds; // Players who still need to act this phase
  final Map<String, dynamic>
      roleData; // Generic store for role state (e.g. { 'witch_healed': true })
  final List<String> deadPlayerIdsThisRound;
  final String? lastSoundEffect; // e.g. 'wolf_howl.mp3'
  final Map<String, String> currentVotes; // voterId -> targetId

  final String? lastKilledPlayerId;

  const GameState({
    required this.roomCode,
    required this.players,
    required this.gamePhase,
    this.round = 1,
    this.narration = '',
    this.nightActions = const [],
    this.pendingActionPlayerIds = const [],
    this.roleData = const {},
    this.deadPlayerIdsThisRound = const [],
    this.lastSoundEffect,
    this.currentVotes = const {},
    this.lastKilledPlayerId,
  });

  // Initial game state
  factory GameState.initial() {
    return const GameState(
      roomCode: '',
      players: [],
      gamePhase: GamePhase.lobby,
    );
  }

  GameState copyWith({
    String? roomCode,
    List<Player>? players,
    GamePhase? gamePhase,
    int? round,
    String? narration,
    List<NightAction>? nightActions,
    List<String>? pendingActionPlayerIds,
    Map<String, dynamic>? roleData,
    List<String>? deadPlayerIdsThisRound,
    String? lastSoundEffect,
    Map<String, String>? currentVotes,
    String? lastKilledPlayerId,
  }) {
    return GameState(
      roomCode: roomCode ?? this.roomCode,
      players: players ?? this.players,
      gamePhase: gamePhase ?? this.gamePhase,
      round: round ?? this.round,
      narration: narration ?? this.narration,
      nightActions: nightActions ?? this.nightActions,
      pendingActionPlayerIds:
          pendingActionPlayerIds ?? this.pendingActionPlayerIds,
      roleData: roleData ?? this.roleData,
      deadPlayerIdsThisRound:
          deadPlayerIdsThisRound ?? this.deadPlayerIdsThisRound,
      lastSoundEffect: lastSoundEffect ?? this.lastSoundEffect,
      currentVotes: currentVotes ?? this.currentVotes,
      lastKilledPlayerId: lastKilledPlayerId ?? this.lastKilledPlayerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'players': players.map((p) => p.toJson()).toList(),
      'gamePhase': gamePhase.toString().split('.').last,
      'round': round,
      'narration': narration,
      'nightActions': nightActions.map((a) => a.toJson()).toList(),
      'pendingActionPlayerIds': pendingActionPlayerIds,
      'roleData': roleData,
      'deadPlayerIdsThisRound': deadPlayerIdsThisRound,
      'lastSoundEffect': lastSoundEffect,
      'currentVotes': currentVotes,
      'lastKilledPlayerId': lastKilledPlayerId,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      roomCode: json['roomCode'] as String? ?? '',
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => Player.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      gamePhase: GamePhase.values.firstWhere(
        (e) => e.toString().split('.').last == json['gamePhase'],
        orElse: () => GamePhase.lobby,
      ),
      round: json['round'] as int? ?? 1,
      narration: json['narration'] as String? ?? '',
      nightActions: (json['nightActions'] as List<dynamic>?)
              ?.map((a) => NightAction.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      pendingActionPlayerIds:
          List<String>.from(json['pendingActionPlayerIds'] ?? []),
      roleData: Map<String, dynamic>.from(json['roleData'] ?? {}),
      deadPlayerIdsThisRound:
          List<String>.from(json['deadPlayerIdsThisRound'] ?? []),
      lastSoundEffect: json['lastSoundEffect'] as String?,
      currentVotes: Map<String, String>.from(json['currentVotes'] ?? {}),
      lastKilledPlayerId: json['lastKilledPlayerId'] as String?,
    );
  }
}
