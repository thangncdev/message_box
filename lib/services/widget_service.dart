import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = "group.com.thangnc.MessageBox";
  static const String iOSWidgetName = "MessageBox";
  static const String androidWidgetName = "DearBox";

  static const String dataKey = "message_from_flutter_app";

  static void init() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> updateWidget({String? content}) async {
    await HomeWidget.saveWidgetData(dataKey, content);
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }
}
