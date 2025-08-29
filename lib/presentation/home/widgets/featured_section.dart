import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/empty_state.dart';
import 'package:message_box/core/theme.dart';

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
    final palette = theme.extension<PastelPalette>();
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: (palette?.pinnedBg) ?? const Color(0xFFFFF2C6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (palette?.borderColor) ?? const Color(0x14000000),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: theme.textTheme.titleMedium?.copyWith(
                color: (palette?.onCard) ?? Color(0xFF3E3A52),
                height: 1.35,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              'Pinned',
              style: theme.textTheme.bodySmall?.copyWith(
                color: palette?.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
