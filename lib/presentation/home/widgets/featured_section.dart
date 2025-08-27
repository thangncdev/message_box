import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/empty_state.dart';

class FeaturedSection extends ConsumerWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(messagesStreamProvider);
    return stream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (items) {
        final Message? pinned = items
            .where((m) => m.pinned)
            .cast<Message?>()
            .firstWhere((m) => m != null, orElse: () => null);
        if (pinned == null) {
          return const EmptyState(
            text: 'Viết điều bạn muốn nhắc mình…',
            actionLabel: 'Viết lời nhắn đầu tiên',
            route: '/compose',
          );
        }
        return _PinnedDisplay(message: pinned);
      },
    );
  }
}

class _PinnedDisplay extends StatelessWidget {
  final Message message;
  const _PinnedDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C83FD), Color(0xFF96BAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: Text(
              message.content,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                height: 1.35,
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.push_pin,
              size: 20,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
