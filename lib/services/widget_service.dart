import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around `home_widget` to manage widget state and updates.
class WidgetService {
  // TODO: Replace with your App Group ID for iOS + macOS
  static const String appGroupId =
      "group.app.dearbox"; // e.g. group.com.company.dearbox
  static const String iOSWidgetName = "DearBoxWidget";
  static const String androidWidgetName = "DearBoxWidget";

  // Keys used by the widget to read data
  static const String keyMode = 'dearbox_mode'; // 'random' | 'latest'
  static const String keyMessageId = 'dearbox_message_id';
  static const String keyMessageContent = 'dearbox_message_content';

  static void init() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  /// Save widget mode in SharedPreferences and HomeWidget storage
  static Future<void> saveWidgetState({required String mode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMode, mode);
    await HomeWidget.saveWidgetData<String>(keyMode, mode);
  }

  /// Update widget data and trigger reload. Optionally pass a specific message id and content.
  static Future<void> updateWidget({String? messageId, String? content}) async {
    if (messageId != null) {
      await HomeWidget.saveWidgetData<String>(keyMessageId, messageId);
    }
    if (content != null) {
      await HomeWidget.saveWidgetData<String>(keyMessageContent, content);
    }
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }
}
