import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;

class ChatMessage {
  final String senderId;
  final String senderName;
  final String content;
  final bool isBot;
  final RoleType? senderRole; // Null if unknown/hidden
  final DateTime timestamp;

  const ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.isBot,
    this.senderRole,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'isBot': isBot,
      'senderRole': senderRole?.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      isBot: json['isBot'] as bool,
      senderRole: json['senderRole'] != null
          ? RoleType.values.firstWhere(
              (e) => e.toString() == json['senderRole'],
              orElse: () => RoleType.dorfbewohner)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
