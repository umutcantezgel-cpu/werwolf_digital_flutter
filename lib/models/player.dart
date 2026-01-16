import 'package:werwolf_digital_flutter/models/role.dart';

class Player {
  final String id; // Unique identifier (e.g., from network service)
  final String name;
  RoleType role;
  bool isAlive;
  bool isHost;

  Player({
    required this.id,
    required this.name,
    this.role = RoleType.unassigned,
    this.isAlive = true,
    this.isHost = false,
  });

  // Method to create a copy with updated values
  Player copyWith({
    String? id,
    String? name,
    RoleType? role,
    bool? isAlive,
    bool? isHost,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isAlive: isAlive ?? this.isAlive,
      isHost: isHost ?? this.isHost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.toString().split('.').last,
      'isAlive': isAlive,
      'isHost': isHost,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      role: RoleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => RoleType.unassigned,
      ),
      isAlive: json['isAlive'] as bool? ?? true,
      isHost: json['isHost'] as bool? ?? false,
    );
  }
}
