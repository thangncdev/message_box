import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  const HomeAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 48, height: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'DearBox',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              height: 1.1,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.push('/setting'),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
