import 'package:flutter/material.dart';

/// Theme keys for multiple pastel palettes
class AppThemeKeys {
  static const String lavender = 'lavender';
  static const String peach = 'peach';
  static const String mint = 'mint';
  static const String sky = 'sky';
  static const String honey = 'honey';
  static const String sand = 'sand';
  static const String moss = 'moss';
  static const String rosewood = 'rosewood';
}

/// Custom ThemeExtension to carry UI colors used across the app
@immutable
class PastelPalette extends ThemeExtension<PastelPalette> {
  final Color gradientStart;
  final Color gradientEnd;
  final Color searchFill;
  final Color cardA;
  final Color cardB;
  final Color pinnedBg;
  final Color accent;
  final Color onCard;
  final Color borderColor;

  const PastelPalette({
    required this.gradientStart,
    required this.gradientEnd,
    required this.searchFill,
    required this.cardA,
    required this.cardB,
    required this.pinnedBg,
    required this.accent,
    required this.onCard,
    required this.borderColor,
  });

  @override
  PastelPalette copyWith({
    Color? gradientStart,
    Color? gradientEnd,
    Color? searchFill,
    Color? cardA,
    Color? cardB,
    Color? pinnedBg,
    Color? accent,
    Color? onCard,
    Color? borderColor,
  }) {
    return PastelPalette(
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      searchFill: searchFill ?? this.searchFill,
      cardA: cardA ?? this.cardA,
      cardB: cardB ?? this.cardB,
      pinnedBg: pinnedBg ?? this.pinnedBg,
      accent: accent ?? this.accent,
      onCard: onCard ?? this.onCard,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ThemeExtension<PastelPalette> lerp(
    ThemeExtension<PastelPalette>? other,
    double t,
  ) {
    if (other is! PastelPalette) return this;
    return PastelPalette(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      searchFill: Color.lerp(searchFill, other.searchFill, t)!,
      cardA: Color.lerp(cardA, other.cardA, t)!,
      cardB: Color.lerp(cardB, other.cardB, t)!,
      pinnedBg: Color.lerp(pinnedBg, other.pinnedBg, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onCard: Color.lerp(onCard, other.onCard, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}

PastelPalette _palette(String key) {
  switch (key) {
    case AppThemeKeys.peach:
      return const PastelPalette(
        gradientStart: Color(0xFFFFF3EC),
        gradientEnd: Color(0xFFFFDFD1),
        searchFill: Color(0xFFFFEFE6),
        cardA: Color(0xFFFFF8F3),
        cardB: Color(0xFFFFE9E0),
        pinnedBg: Color(0xFFFFE0C7),
        accent: Color(0xFFFF7043), // fresh coral
        onCard: Color(0xFF3E2C29),
        borderColor: Color(0x14000000),
      );

    case AppThemeKeys.mint:
      return const PastelPalette(
        gradientStart: Color(0xFFE9FFF5),
        gradientEnd: Color(0xFFC8F0E0),
        searchFill: Color(0xFFD9F7ED),
        cardA: Color(0xFFF6FFFA),
        cardB: Color(0xFFEBFFF5),
        pinnedBg: Color(0xFFDDF6E1),
        accent: Color(0xFF20BFA9), // aqua teal
        onCard: Color(0xFF224239),
        borderColor: Color(0x14000000),
      );

    case AppThemeKeys.sky:
      return const PastelPalette(
        gradientStart: Color.fromARGB(255, 238, 244, 250),
        gradientEnd: Color.fromARGB(255, 196, 229, 246),
        searchFill: Color(0xFFD9EBFF),
        cardA: Color(0xFFF7FBFF),
        cardB: Color(0xFFE6F2FF),
        pinnedBg: Color(0xFFCCE4FF),
        accent: Color(0xFF4A90E2), // soft vivid blue
        onCard: Color(0xFF2C3E55),
        borderColor: Color(0x14000000),
      );

    case AppThemeKeys.honey:
      return const PastelPalette(
        gradientStart: Color(0xFFFFFAEC),
        gradientEnd: Color(0xFFFFEFC7),
        searchFill: Color(0xFFFFF6DA),
        cardA: Color(0xFFFFFBF2),
        cardB: Color(0xFFFFF2DE),
        pinnedBg: Color(0xFFFFEDC2),
        accent: Color(0xFFF9A825), // honey gold
        onCard: Color(0xFF3E3429),
        borderColor: Color(0x14000000),
      );
    case AppThemeKeys.sand:
      return const PastelPalette(
        gradientStart: Color(0xFFFFF8F2), // nền sáng dịu
        gradientEnd: Color(0xFFF5E6CA), // beige ấm
        searchFill: Color(0xFFFFF2E0), // search box nhạt
        cardA: Color(0xFFFFFAF5), // card sáng
        cardB: Color(0xFFFDF1E0), // card hơi trầm
        pinnedBg: Color(0xFFFFE7C2), // note ghim ấm áp
        accent: Color(0xFF8D6E63), // accent nâu hiện đại
        onCard: Color(0xFF3E3A35), // chữ tối, dễ đọc
        borderColor: Color(0x14000000), // border nhẹ
      );

    case AppThemeKeys.moss:
      return const PastelPalette(
        gradientStart: Color(0xFFF2FFF9), // xanh nhạt
        gradientEnd: Color(0xFFD9EFE2), // xanh moss pastel
        searchFill: Color(0xFFE8F7ED),
        cardA: Color(0xFFF8FFFA),
        cardB: Color(0xFFEFFAF2),
        pinnedBg: Color(0xFFDDEBCF), // highlight nhấn vàng-xanh
        accent: Color(0xFF4CAF50), // xanh lá hiện đại
        onCard: Color(0xFF2F3B30),
        borderColor: Color(0x14000000),
      );

    case AppThemeKeys.rosewood:
      return const PastelPalette(
        gradientStart: Color(0xFFFFF0F3), // hồng nhạt
        gradientEnd: Color(0xFFF9E0E6), // hồng phấn
        searchFill: Color(0xFFFFE6EB),
        cardA: Color(0xFFFFF6F7),
        cardB: Color(0xFFFFECEF),
        pinnedBg: Color(0xFFFFDFE4),
        accent: Color(0xFFD81B60), // hồng đậm, sang
        onCard: Color(0xFF3A2F34),
        borderColor: Color(0x14000000),
      );

    case AppThemeKeys.lavender:
    default:
      return const PastelPalette(
        gradientStart: Color(0xFFF6E9FF),
        gradientEnd: Color(0xFFE1D4FF),
        searchFill: Color(0xFFEDE4FF),
        cardA: Color(0xFFF9F5FF),
        cardB: Color(0xFFEFE6FF),
        pinnedBg: Color(0xFFE7DBFF),
        accent: Color(0xFF9C8CFF), // soft purple accent
        onCard: Color(0xFF362F4A),
        borderColor: Color(0x14000000),
      );
  }
}

ThemeData buildAppTheme(String key) {
  final pastel = _palette(key);
  // Base tonal colors derived from accent
  final primary = pastel.accent;
  const background = Color(0xFFFCFCFE);

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: primary,
      surface: background,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'ShantellSans',
    extensions: <ThemeExtension<dynamic>>[pastel],
  );

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
      elevation: 0,
      backgroundColor: background,
      foregroundColor: const Color(0xFF3E3A52),
    ),
    scaffoldBackgroundColor: background,
    cardTheme: base.cardTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1.5,
      margin: const EdgeInsets.all(0),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Expose available themes
const List<String> availableThemes = <String>[
  AppThemeKeys.lavender,
  AppThemeKeys.peach,
  AppThemeKeys.mint,
  AppThemeKeys.sky,
  AppThemeKeys.honey,
  AppThemeKeys.sand,
  AppThemeKeys.moss,
  AppThemeKeys.rosewood,
];
