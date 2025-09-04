import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:message_box/core/theme.dart';

/// App state class chứa tất cả trạng thái chung của ứng dụng
class AppState {
  final Locale? locale;
  final String themeKey;
  final bool isInitialized;
  final String? error;

  const AppState({
    this.locale,
    this.themeKey = AppThemeKeys.honey,
    this.isInitialized = false,
    this.error,
  });

  AppState copyWith({
    Locale? locale,
    String? themeKey,
    bool? isInitialized,
    String? error,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      themeKey: themeKey ?? this.themeKey,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error ?? this.error,
    );
  }
}

/// AppProvider quản lý trạng thái chung của ứng dụng
class AppProvider extends StateNotifier<AppState> {
  AppProvider() : super(const AppState()) {
    _initialize();
  }

  /// Khởi tạo app và load các setting đã lưu
  Future<void> _initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme setting
      final savedTheme = prefs.getString('theme_key') ?? AppThemeKeys.honey;

      // Load locale setting
      final savedLocaleCode = prefs.getString('locale_code');
      Locale? savedLocale;
      if (savedLocaleCode != null) {
        savedLocale = Locale(savedLocaleCode);
      }

      state = state.copyWith(
        themeKey: savedTheme,
        locale: savedLocale,
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize app: $e',
        isInitialized: true,
      );
    }
  }

  /// Thay đổi theme
  Future<void> changeTheme(String themeKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_key', themeKey);

      state = state.copyWith(themeKey: themeKey);
    } catch (e) {
      state = state.copyWith(error: 'Failed to save theme: $e');
    }
  }

  /// Thay đổi ngôn ngữ
  Future<void> changeLocale(Locale? locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (locale != null) {
        await prefs.setString('locale_code', locale.languageCode);
      } else {
        await prefs.remove('locale_code');
      }

      state = state.copyWith(locale: locale);
    } catch (e) {
      state = state.copyWith(error: 'Failed to save locale: $e');
    }
  }

  /// Reset về setting mặc định
  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('theme_key');
      await prefs.remove('locale_code');

      state = state.copyWith(themeKey: AppThemeKeys.honey, locale: null);
    } catch (e) {
      state = state.copyWith(error: 'Failed to reset settings: $e');
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider instance
final appProvider = StateNotifierProvider<AppProvider, AppState>((ref) {
  return AppProvider();
});

/// Convenience providers để dễ sử dụng
final currentLocaleProvider = Provider<Locale?>((ref) {
  return ref.watch(appProvider).locale;
});

final currentThemeKeyProvider = Provider<String>((ref) {
  return ref.watch(appProvider).themeKey;
});

final isAppInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appProvider).isInitialized;
});

final appErrorProvider = Provider<String?>((ref) {
  return ref.watch(appProvider).error;
});
