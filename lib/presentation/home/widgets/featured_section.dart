import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/domain/entities/message.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/empty_state.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/assets/images/app_images.dart';
import 'package:message_box/l10n/app_localizations.dart';

class FeaturedSection extends ConsumerWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageState = ref.watch(messageProvider);
    final pinnedMessages = ref.watch(pinnedMessagesProvider);
    final allMessages = ref.watch(messagesListProvider);

    if (messageState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messageState.error != null) {
      return Text('Error: ${messageState.error}');
    }

    // Nếu không có message nào
    if (allMessages.isEmpty) {
      return EmptyState(
        text: AppLocalizations.of(context)!.emptyFeaturedText,
        actionLabel: AppLocalizations.of(context)!.emptyFeaturedAction,
        route: '/compose',
      );
    }

    // Ưu tiên hiển thị message đã ghim, nếu không có thì hiển thị message mới nhất
    final displayMessage = pinnedMessages.isNotEmpty
        ? pinnedMessages.first
        : allMessages.first;

    return _PinnedDisplay(
      message: displayMessage,
      isPinned: pinnedMessages.isNotEmpty,
    );
  }
}

class _PinnedDisplay extends StatelessWidget {
  final Message message;
  final bool isPinned;
  const _PinnedDisplay({required this.message, required this.isPinned});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<PastelPalette>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/detail/${message.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: (palette?.pinnedBg) ?? const Color(0xFFFFF2C6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: (palette?.borderColor) ?? const Color(0x14000000),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
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
                      isPinned ? 'Pinned' : 'Latest',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette?.accent,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Image.asset(AppImages.pin_paper, width: 24, height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
