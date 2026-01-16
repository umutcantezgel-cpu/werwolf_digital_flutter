import 'role.dart';

enum ActionType { kill, see, heal, poison, protect, link, shoot, none }

class NightAction {
  final String playerId;
  final RoleType role;
  final ActionType actionType;
  final String? targetId;
  final DateTime timestamp;

  const NightAction({
    required this.playerId,
    required this.role,
    required this.actionType,
    this.targetId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'role': role.toString().split('.').last,
      'actionType': actionType.toString().split('.').last,
      'targetId': targetId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NightAction.fromJson(Map<String, dynamic> json) {
    return NightAction(
      playerId: json['playerId'] as String,
      role: RoleType.values
          .firstWhere((e) => e.toString().split('.').last == json['role']),
      actionType: ActionType.values.firstWhere(
          (e) => e.toString().split('.').last == json['actionType']),
      targetId: json['targetId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
