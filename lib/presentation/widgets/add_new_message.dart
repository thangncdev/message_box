import 'package:flutter/material.dart';
import 'package:message_box/core/theme.dart';

class AddNewMessageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;

  const AddNewMessageButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.edit,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: palette.gradientEnd,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        color: palette.accent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Center(
            child: Icon(Icons.edit, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
