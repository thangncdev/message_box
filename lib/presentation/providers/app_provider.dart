import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/core/theme.dart';
import 'package:message_box/core/constants/shared_preferences_keys.dart';
import 'package:message_box/services/shared_preferences_service.dart';

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
      final prefsService = await SharedPreferencesService.getInstance();

      // Load theme setting
      final savedTheme = prefsService.getThemeKey(
        defaultValue: AppThemeKeys.honey,
      );

      // Load locale setting
      final savedLocaleCode = prefsService.getLocaleCode();
      Locale? savedLocale;
      if (savedLocaleCode.isNotEmpty) {
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
      final prefsService = await SharedPreferencesService.getInstance();
      await prefsService.setThemeKey(themeKey);

      state = state.copyWith(themeKey: themeKey);
    } catch (e) {
      state = state.copyWith(error: 'Failed to save theme: $e');
    }
  }

  /// Thay đổi ngôn ngữ
  Future<void> changeLocale(Locale? locale) async {
    try {
      final prefsService = await SharedPreferencesService.getInstance();

      if (locale != null) {
        await prefsService.setLocaleCode(locale.languageCode);
      } else {
        await prefsService.remove(SharedPreferencesKeys.localeCode);
      }

      state = state.copyWith(locale: locale);
    } catch (e) {
      state = state.copyWith(error: 'Failed to save locale: $e');
    }
  }

  /// Reset về setting mặc định
  Future<void> resetToDefaults() async {
    try {
      final prefsService = await SharedPreferencesService.getInstance();
      await prefsService.remove(SharedPreferencesKeys.themeKey);
      await prefsService.remove(SharedPreferencesKeys.localeCode);

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
