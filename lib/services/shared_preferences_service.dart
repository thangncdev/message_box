import 'package:shared_preferences/shared_preferences.dart';
import 'package:message_box/core/constants/shared_preferences_keys.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Onboarding
  Future<bool> setSeenOnboarding(bool value) async {
    return await _prefs!.setBool(SharedPreferencesKeys.seenOnboarding, value);
  }

  bool getSeenOnboarding() {
    return _prefs!.getBool(SharedPreferencesKeys.seenOnboarding) ?? false;
  }

  // Theme
  Future<bool> setThemeKey(String themeKey) async {
    return await _prefs!.setString(SharedPreferencesKeys.themeKey, themeKey);
  }

  String getThemeKey({String defaultValue = 'honey'}) {
    return _prefs!.getString(SharedPreferencesKeys.themeKey) ?? defaultValue;
  }

  // Language/Locale
  Future<bool> setLocaleCode(String localeCode) async {
    return await _prefs!.setString(
      SharedPreferencesKeys.localeCode,
      localeCode,
    );
  }

  String getLocaleCode({String defaultValue = ''}) {
    return _prefs!.getString(SharedPreferencesKeys.localeCode) ?? defaultValue;
  }

  bool hasSelectedLanguage() {
    final localeCode = getLocaleCode();
    return localeCode.isNotEmpty;
  }

  // Widget Guide
  Future<bool> setHasSeenWidgetGuide(bool value) async {
    return await _prefs!.setBool(
      SharedPreferencesKeys.hasSeenWidgetGuide,
      value,
    );
  }

  bool getHasSeenWidgetGuide() {
    return _prefs!.getBool(SharedPreferencesKeys.hasSeenWidgetGuide) ?? false;
  }

  // Generic methods for other preferences
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs!.getBool(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs!.getString(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs!.getInt(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs!.getDouble(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  List<String> getStringList(String key, {List<String>? defaultValue}) {
    return _prefs!.getStringList(key) ?? defaultValue ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  Set<String> getKeys() {
    return _prefs!.getKeys();
  }

  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
