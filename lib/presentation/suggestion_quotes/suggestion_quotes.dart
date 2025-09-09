import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/l10n/app_localizations.dart';
import 'package:message_box/presentation/providers.dart';
import 'package:message_box/presentation/widgets/base_app_bar.dart';
import 'package:message_box/presentation/widgets/base_screen.dart';
import 'package:flutter/services.dart';
import 'package:message_box/l10n/app_localizations.dart';

// Quotes in English + Vietnamese (3 per category)
// Categories + Quotes with EN + VI
final Map<Map<String, String>, List<Map<String, String>>>
quotesByCategory = const {
  {"en": "🌱 Life & Growth", "vi": "🌱 Cuộc sống & Phát triển"}: [
    {
      "en": "Be yourself; everyone else is already taken.",
      "vi": "Hãy là chính mình; tất cả những người khác đã có bản sao rồi.",
    },
    {
      "en": "In the middle of every difficulty lies opportunity.",
      "vi": "Trong mỗi khó khăn đều ẩn chứa cơ hội.",
    },
    {
      "en": "Do what you can, with what you have, where you are.",
      "vi":
          "Hãy làm những gì bạn có thể, với những gì bạn có, ở nơi bạn đang đứng.",
    },
  ],
  {"en": "💪 Courage & Resilience", "vi": "💪 Dũng cảm & Kiên cường"}: [
    {
      "en": "It always seems impossible until it’s done.",
      "vi": "Mọi thứ luôn có vẻ bất khả thi cho đến khi nó hoàn thành.",
    },
    {
      "en": "Fall seven times and stand up eight.",
      "vi": "Ngã bảy lần, đứng dậy tám lần.",
    },
    {
      "en": "Courage is not the absence of fear, but the triumph over it.",
      "vi": "Dũng cảm không phải là không có sợ hãi, mà là chiến thắng nó.",
    },
  ],
  {"en": "🧠 Wisdom & Perspective", "vi": "🧠 Trí tuệ & Góc nhìn"}: [
    {
      "en": "Knowing yourself is the beginning of all wisdom.",
      "vi": "Hiểu rõ chính mình là khởi đầu của mọi trí tuệ.",
    },
    {
      "en": "Happiness depends upon ourselves.",
      "vi": "Hạnh phúc phụ thuộc vào chính chúng ta.",
    },
    {
      "en":
          "Do not go where the path may lead, go instead where there is no path and leave a trail.",
      "vi":
          "Đừng đi theo con đường có sẵn, hãy đi nơi chưa có đường và để lại dấu vết.",
    },
  ],
  {"en": "🌍 Inspiration & Legacy", "vi": "🌍 Truyền cảm hứng & Di sản"}: [
    {
      "en": "Be the change that you wish to see in the world.",
      "vi": "Hãy trở thành sự thay đổi mà bạn muốn thấy trong thế giới này.",
    },
    {
      "en": "The best way to predict the future is to invent it.",
      "vi": "Cách tốt nhất để dự đoán tương lai là tạo ra nó.",
    },
    {
      "en":
          "What you do makes a difference, and you have to decide what kind of difference you want to make.",
      "vi":
          "Những gì bạn làm đều tạo ra sự khác biệt, và bạn phải quyết định bạn muốn tạo ra sự khác biệt như thế nào.",
    },
  ],
};

class SuggestionQuotesScreen extends ConsumerWidget {
  const SuggestionQuotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final currentLocale = appState.locale;

    return BaseScrollableScreen(
      appBar: GradientAppBar(
        title: AppLocalizations.of(context)!.suggestedMessages,
      ),
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),

        ...quotesByCategory.entries.map((entry) {
          final category = entry.key;
          final quotes = entry.value;

          return ExpansionTile(
            title: Text(
              category[currentLocale?.languageCode ?? "en"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: quotes.map((quote) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        quote[currentLocale?.languageCode ?? "en"] ?? "",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                quote[currentLocale?.languageCode ?? "en"] ??
                                "",
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.copiedClipboard,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.copy),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
