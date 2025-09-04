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
  String get searchHint => 'Search a old message...';

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
  String get emptyFeaturedText =>
      'Write a note you’d like to leave for yourself...';

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
  String get errorTooLong => 'Max 1000 characters';

  @override
  String get settings => 'Settings';

  @override
  String get justNow => 'just now';

  @override
  String get minutesAgo => 'min ago';

  @override
  String get hoursAgo => 'h ago';

  @override
  String get yourPersonalMessageBox => 'Your personal message box';

  @override
  String get makeChangesToYourMessage => 'Make changes to your message';

  @override
  String get yourMessage => 'Your message';

  @override
  String get more => 'More';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateThisApp => 'Rate this app';

  @override
  String get settingsSubtitle => 'App preferences and appearance';

  @override
  String get feedbackSubtitle => 'Tell us what you think';

  @override
  String get rateAppSubtitle => 'Leave a review on the store';

  @override
  String get widgetGuide => 'Widget Guide';

  @override
  String get widgetGuideSubtitle => 'How to add DearBox to Home Screen';

  @override
  String get guideAppBarTitle => 'Add DearBox Widget';

  @override
  String get guideTitle => 'How to add DearBox widget to the Home Screen';

  @override
  String get guideSubtitle => 'Quick steps to start brightening your day ✨';

  @override
  String get guideTitleIos =>
      'How to add DearBox widget to the Home Screen (iOS)';

  @override
  String get guideStepIosJiggle =>
      'Long press on an empty area until apps jiggle.';

  @override
  String get guideStepIosTapPlus => 'Tap the + button at the top-left corner.';

  @override
  String get guideStepIosFindInGallery =>
      'In Widget Gallery, scroll and find DearBox.';

  @override
  String get guideStepIosChooseStyle => 'Choose a widget style.';

  @override
  String get guideStepIosTapAddWidget => 'Tap Add Widget.';

  @override
  String get guideStepIosDragPosition => 'Drag it to your desired position.';

  @override
  String get guideStepIosTapDone => 'Tap Done at the top-right to finish.';

  @override
  String get guideStepLongPress => 'Long press on Home Screen.';

  @override
  String get guideStepSelectWidgets => 'Select "Widgets".';

  @override
  String get guideStepFindDearBox => 'Find "DearBox".';

  @override
  String get guideStepChooseStyle =>
      'Choose a style (Today’s Note / Random Quote).';

  @override
  String get guideStepTapAdd => 'Tap "Add".';

  @override
  String get guideStepPlaceAnywhere => 'Place it anywhere you like.';

  @override
  String get guideFooter => 'Let DearBox brighten your day ✨';

  @override
  String get done => 'Done';
}
