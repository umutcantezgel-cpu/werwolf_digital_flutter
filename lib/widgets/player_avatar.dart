import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String playerName;
  final bool isAlive;
  final bool isSelected;
  final VoidCallback? onTap;

  const PlayerAvatar({
    super.key,
    required this.playerName,
    this.isAlive = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAlive ? onTap : null,
      child: Opacity(
        opacity: isAlive ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.7)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: isAlive ? Colors.blueGrey : Colors.redAccent,
                child: Text(
                  playerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                playerName,
                style: TextStyle(
                  color: isAlive
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Colors.red,
                  decoration: isAlive
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
