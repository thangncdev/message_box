// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DearBox';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get detailTitle => 'Message Detail';

  @override
  String get newMessage => 'New Message';

  @override
  String get editMessage => 'Edit Message';

  @override
  String get searchHint => 'Search...';

  @override
  String get newest => 'Newest';

  @override
  String get oldest => 'Oldest';

  @override
  String get edit => 'Edit';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Are you sure you want to delete this message?';

  @override
  String get saved => 'Saved';

  @override
  String get updated => 'Updated';

  @override
  String get pinned => 'Pinned';

  @override
  String get unpinned => 'Unpinned';

  @override
  String get emptyFeaturedText => 'Write what you want to remind yourself…';

  @override
  String get emptyFeaturedAction => 'Write your first message';

  @override
  String get noMessages => 'No messages';

  @override
  String lastUpdated(Object minutes) {
    return 'Last updated: $minutes min ago';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get followSystem => 'Follow system';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get writeSomething => 'Write something…';

  @override
  String get save => 'Save';

  @override
  String get errorEmpty => 'Content must not be empty';

  @override
  String get errorTooLong => 'Max 280 characters';

  @override
  String get settings => 'Settings';

  @override
  String get justNow => 'just now';

  @override
  String get minutesAgo => 'min ago';

  @override
  String get hoursAgo => 'h ago';
}
