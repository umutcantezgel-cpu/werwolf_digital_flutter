import 'package:flutter/material.dart';
import '../models/role.dart';
import 'cinematic_role_reveal.dart';
import 'role_card.dart';

class RoleDetailsModal extends StatelessWidget {
  final Role role;
  final String heroTag;

  const RoleDetailsModal({
    super.key,
    required this.role,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black54, // Dimmed background
        body: Center(
          child: Hero(
            tag: heroTag,

            // Fix for Hero transition overflow issues with custom widgets
            // We can wrap child in Material to ensure text rendering works during flight
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                child: toHeroContext.widget,
              );
            },

            child: Material(
              color: Colors.transparent,
              child: CinematicRoleReveal(
                front: RoleCard(
                    role: role,
                    isRevealed: false), // Start with back (matches icon)
                back:
                    RoleCard(role: role, isRevealed: true), // Flip to see info

                // Wait, if I want to "Tap to flip", CardFlipAnimation handles it.
                // But if I want to close the modal, I also caught onTap on background.
                // CardFlipAnimation captures onTap on itself.
              ),
            ),
          ),
        ),
      ),
    );
  }
}
