import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/models/chat_message.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class InGameChat extends StatefulWidget {
  const InGameChat({super.key});

  @override
  State<InGameChat> createState() => _InGameChatState();
}

class _InGameChatState extends State<InGameChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<GameProvider>();
    // Add player message
    // In real multiplayer, this would go to server.
    // In solo, we just add it to local history.
    provider.addMessage(ChatMessage(
      senderId: 'player', // TODO: Get actual ID
      senderName: 'Du',
      content: text,
      isBot: false,
      timestamp: DateTime.now(),
    ));

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.nightBlack.withValues(alpha: 0.95), // Corrected
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: DesignColors.nightSubtle), // Corrected
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline,
                    color: DesignColors.moonPrimary), // Corrected
                const SizedBox(width: 8),
                const Text(
                  'Dorfplatz',
                  style: TextStyle(
                    fontFamily: DesignTypography.fontDisplay,
                    fontSize: DesignTypography.text3xl, // Corrected
                    color: DesignColors.moonPrimary, // Corrected
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: DesignColors.moonPrimary), // Corrected
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, provider, child) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                if (provider.chatHistory.isEmpty) {
                  return const Center(
                    child: Text(
                      'Noch keine Nachrichten...',
                      style: TextStyle(
                        fontFamily: DesignTypography.fontBody,
                        fontSize: DesignTypography.textBase,
                        color: DesignColors.nightSubtle, // Corrected
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.chatHistory.length,
                  itemBuilder: (context, index) {
                    return _MessageBubble(message: provider.chatHistory[index]);
                  },
                );
              },
            ),
          ),

          // Input
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                        color: DesignColors.moonPrimary), // Corrected
                    decoration: InputDecoration(
                      hintText: 'Nachricht schreiben...',
                      hintStyle: TextStyle(
                          color: DesignColors.moonPrimary
                              .withValues(alpha: 0.5)), // Corrected
                      filled: true,
                      fillColor: DesignColors.nightMid,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: DesignColors.dayBright), // Corrected
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;
    final isMe = !isBot; // For now simplified

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? DesignColors.nightSubtle
              : DesignColors.nightMid, // Corrected
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? Radius.zero : null,
            bottomLeft: !isMe ? Radius.zero : null,
          ),
          border: isBot
              ? Border.all(
                  color: DesignColors.dayBright
                      .withValues(alpha: 0.3)) // Corrected
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBot) ...[
              Text(
                message.senderName,
                style: const TextStyle(
                  fontFamily: DesignTypography.fontBody,
                  fontSize: DesignTypography.textSm,
                  color: DesignColors.dayBright, // Corrected
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              message.content,
              style: const TextStyle(
                fontFamily: DesignTypography.fontBody,
                fontSize: DesignTypography.textBase,
                color: DesignColors.moonPrimary, // Corrected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
