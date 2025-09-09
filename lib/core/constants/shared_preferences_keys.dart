/// Constants for SharedPreferences keys
///
/// This class contains all the keys used for storing data in SharedPreferences.
/// Using constants helps prevent typos and makes the code more maintainable.
class SharedPreferencesKeys {
  // Private constructor to prevent instantiation
  SharedPreferencesKeys._();

  // Onboarding
  static const String seenOnboarding = 'seen_onboarding';

  // Theme
  static const String themeKey = 'theme_key';

  // Language/Locale
  static const String localeCode = 'locale_code';

  // Widget Guide
  static const String hasSeenWidgetGuide = 'has_seen_widget_guide';
  
  static const String hasSeenSuggestedMessageGuide = 'has_seen_suggested_message_guide';
}
