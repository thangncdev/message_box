// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'DearBox';

  @override
  String get messagesTitle => 'Danh sách';

  @override
  String get detailTitle => 'Chi tiết lời nhắn';

  @override
  String get newMessage => 'Tạo lời nhắn';

  @override
  String get editMessage => 'Sửa lời nhắn';

  @override
  String get searchHint => 'Tìm một lời nhắn cũ...';

  @override
  String get newest => 'Mới nhất';

  @override
  String get oldest => 'Cũ nhất';

  @override
  String get edit => 'Sửa';

  @override
  String get pin => 'Ghim';

  @override
  String get unpin => 'Bỏ ghim';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirmDelete => 'Bạn có chắc muốn xóa lời nhắn này?';

  @override
  String get saved => 'Đã lưu';

  @override
  String get updated => 'Đã cập nhật';

  @override
  String get pinned => 'Đã ghim';

  @override
  String get unpinned => 'Bỏ ghim';

  @override
  String get emptyFeaturedText => 'Vài lời nhắn nhủ cho chính mình…';

  @override
  String get emptyFeaturedAction => 'Viết lời nhắn đầu tiên';

  @override
  String get noMessages => 'Chưa có lời nhắn';

  @override
  String lastUpdated(Object minutes) {
    return 'Cập nhật $minutes phút trước';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get followSystem => 'Theo hệ thống';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get writeSomething => 'Viết gì đó…';

  @override
  String get save => 'Lưu';

  @override
  String get errorEmpty => 'Nội dung không được để trống';

  @override
  String get errorTooLong => 'Tối đa 1000 ký tự';

  @override
  String get settings => 'Cài đặt';

  @override
  String get justNow => 'vừa xong';

  @override
  String get minutesAgo => 'phút trước';

  @override
  String get hoursAgo => 'giờ trước';

  @override
  String get yourPersonalMessageBox => 'Hộp tin nhắn cá nhân của bạn';

  @override
  String get makeChangesToYourMessage => 'Sửa lời nhắn của bạn';

  @override
  String get yourMessage => 'Lời nhắn của bạn';

  @override
  String get more => 'Thêm';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get rateThisApp => 'Đánh giá ứng dụng';

  @override
  String get settingsSubtitle => 'Tùy chỉnh và giao diện ứng dụng';

  @override
  String get feedbackSubtitle => 'Cho chúng tôi biết ý kiến của bạn';

  @override
  String get rateAppSubtitle => 'Để lại đánh giá trên cửa hàng';
}
