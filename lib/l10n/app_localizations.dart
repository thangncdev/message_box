import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DearBox'**
  String get appTitle;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Message Detail'**
  String get detailTitle;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @editMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit Message'**
  String get editMessage;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get confirmDelete;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @unpinned.
  ///
  /// In en, this message translates to:
  /// **'Unpinned'**
  String get unpinned;

  /// No description provided for @emptyFeaturedText.
  ///
  /// In en, this message translates to:
  /// **'Write a note you’d like to leave for yourself...'**
  String get emptyFeaturedText;

  /// No description provided for @emptyFeaturedAction.
  ///
  /// In en, this message translates to:
  /// **'Write your first message'**
  String get emptyFeaturedAction;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {minutes} min ago'**
  String lastUpdated(Object minutes);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write something…'**
  String get writeSomething;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @errorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Content must not be empty'**
  String get errorEmpty;

  /// No description provided for @errorTooLong.
  ///
  /// In en, this message translates to:
  /// **'Max 1000 characters'**
  String get errorTooLong;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'min ago'**
  String get minutesAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'h ago'**
  String get hoursAgo;

  /// No description provided for @yourPersonalMessageBox.
  ///
  /// In en, this message translates to:
  /// **'Note it. Own it'**
  String get yourPersonalMessageBox;

  /// No description provided for @makeChangesToYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Update your message'**
  String get makeChangesToYourMessage;

  /// No description provided for @widgetGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Display your message on home screen!'**
  String get widgetGuideTitle;

  /// No description provided for @widgetGuideDescription.
  ///
  /// In en, this message translates to:
  /// **'You can add a widget to your home screen to quickly view your message without opening the app.'**
  String get widgetGuideDescription;

  /// No description provided for @widgetGuideButton.
  ///
  /// In en, this message translates to:
  /// **'View Guide'**
  String get widgetGuideButton;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'Dear Box'**
  String get introTitle1;

  /// No description provided for @introContent1.
  ///
  /// In en, this message translates to:
  /// **'A box for your thoughts'**
  String get introContent1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'Write & Reflect'**
  String get introTitle2;

  /// No description provided for @introContent2.
  ///
  /// In en, this message translates to:
  /// **'Write your reminders, encouragement, or positive messages you want to send to yourself.'**
  String get introContent2;

  /// No description provided for @introTitle3.
  ///
  /// In en, this message translates to:
  /// **'Always by Your Side'**
  String get introTitle3;

  /// No description provided for @introContent3.
  ///
  /// In en, this message translates to:
  /// **'Quickly view your message from your home screen and notification as a warm reminder every day'**
  String get introContent3;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get settingsSubtitle;

  /// No description provided for @widgetGuide.
  ///
  /// In en, this message translates to:
  /// **'Widget Guide'**
  String get widgetGuide;

  /// No description provided for @widgetGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how to add widget'**
  String get widgetGuideSubtitle;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts with us'**
  String get feedbackSubtitle;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rateThisApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get rateAppSubtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @guideTitleIos.
  ///
  /// In en, this message translates to:
  /// **'How to Add Widget'**
  String get guideTitleIos;

  /// No description provided for @guideStepIosJiggle.
  ///
  /// In en, this message translates to:
  /// **'Long press on an empty area of your home screen until apps start jiggling'**
  String get guideStepIosJiggle;

  /// No description provided for @guideStepIosTapPlus.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button in the top-left corner'**
  String get guideStepIosTapPlus;

  /// No description provided for @guideStepIosFindInGallery.
  ///
  /// In en, this message translates to:
  /// **'Search for \'DearBox\' in the widget gallery'**
  String get guideStepIosFindInGallery;

  /// No description provided for @guideStepIosChooseStyle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred widget style and size'**
  String get guideStepIosChooseStyle;

  /// No description provided for @guideStepIosTapAddWidget.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Widget\' to add it to your home screen'**
  String get guideStepIosTapAddWidget;

  /// No description provided for @guideStepIosDragPosition.
  ///
  /// In en, this message translates to:
  /// **'Drag the widget to your desired position'**
  String get guideStepIosDragPosition;

  /// No description provided for @guideStepIosTapDone.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Done\' in the top-right corner to finish'**
  String get guideStepIosTapDone;

  /// No description provided for @guideTitle.
  ///
  /// In en, this message translates to:
  /// **'Widget Setup Guide'**
  String get guideTitle;

  /// No description provided for @guideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow these steps to add DearBox widget to your home screen'**
  String get guideSubtitle;

  /// No description provided for @guideFooter.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact us for support'**
  String get guideFooter;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language to get started'**
  String get selectLanguageSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @suggestedMessages.
  ///
  /// In en, this message translates to:
  /// **'Suggested Message'**
  String get suggestedMessages;

  /// No description provided for @guideSuggestedMessage.
  ///
  /// In en, this message translates to:
  /// **'📌 You can refer to some available messages here'**
  String get guideSuggestedMessage;

  /// No description provided for @copiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedClipboard;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
