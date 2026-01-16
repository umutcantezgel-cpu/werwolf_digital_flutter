import 'package:flutter/material.dart';
import '../models/role.dart';

import 'role_details_modal.dart';

class RoleIcon extends StatelessWidget {
  final Role role;
  final String heroTag = 'role_card_hero';

  const RoleIcon({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            barrierColor: Colors.black54,
            pageBuilder: (context, _, __) => RoleDetailsModal(
              role: role,
              heroTag: heroTag,
            ),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          width: 50,
          height: 70, // Aspect ratio roughly similar to card
          decoration: BoxDecoration(
            color:
                role.color?.withValues(alpha: 0.2) ?? const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: role.color?.withValues(alpha: 0.5) ?? Colors.white24,
                width: 1),
            boxShadow: [
              BoxShadow(
                color: (role.color ?? Colors.black).withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Center(
            child: Icon(role.icon ?? Icons.help_outline,
                color: role.color ?? Colors.white54, size: 24),
          ),
        ),
      ),
    );
  }
}
