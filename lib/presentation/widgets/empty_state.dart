import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/assets/images/app_images.dart';
import 'package:message_box/core/theme.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final String? route;
  const EmptyState({
    super.key,
    required this.text,
    this.actionLabel,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/empty_message.json',
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            repeat: true, // lặp vô hạn
            reverse: false, // có chạy ngược không
            animate: true, // tự động play
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          if (actionLabel != null && route != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push(route!),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
