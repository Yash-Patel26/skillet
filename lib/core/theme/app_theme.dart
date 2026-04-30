import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color cream = Color(0xFFFAF6F1);
  static const Color paper = Color(0xFFF5EFE4);
  static const Color paperDeep = Color(0xFFEFE6D5);
  static const Color ink = Color(0xFF1A1612);
  static const Color ash = Color(0xFF6B6357);
  static const Color sage = Color(0xFF8B8478);
  static const Color hairline = Color(0xFFE3D9C5);
  static const Color terracotta = Color(0xFFD6633A);
  static const Color saffron = Color(0xFFE8A33D);
  static const Color rust = Color(0xFF7A2E1F);

  static const Color primary = terracotta;
  static const Color primaryDark = rust;
  static const Color accent = saffron;
  static const Color surface = cream;
  static const Color surfaceDeep = paper;

  static const fontFallback = <String>[
    'Roboto',
    'Noto Sans',
    'Noto Sans Devanagari',
    'Noto Sans Arabic',
    'sans-serif',
  ];

  static TextStyle serif({
    required double size,
    FontWeight weight = FontWeight.w600,
    bool italic = false,
    double? height,
    double? letterSpacing,
    Color color = ink,
  }) {
    return GoogleFonts.fraunces(
      fontSize: size,
      fontWeight: weight,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).copyWith(
      fontFamilyFallback: fontFallback,
    );
  }

  static TextStyle sans({
    required double size,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = ink,
  }) {
    return GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).copyWith(
      fontFamilyFallback: fontFallback,
    );
  }

  static TextStyle eyebrow({Color color = ash, double size = 11}) {
    return sans(
      size: size,
      weight: FontWeight.w600,
      letterSpacing: 2.4,
      color: color,
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.light,
      surface: cream,
      primary: terracotta,
    );

    final tt = TextTheme(
      displayLarge: serif(size: 56, weight: FontWeight.w700, height: 1.05, letterSpacing: -1.2),
      displayMedium: serif(size: 44, weight: FontWeight.w700, height: 1.08, letterSpacing: -0.8),
      displaySmall: serif(size: 36, weight: FontWeight.w700, height: 1.1, letterSpacing: -0.6),
      headlineLarge: serif(size: 32, weight: FontWeight.w600, height: 1.12, letterSpacing: -0.5),
      headlineMedium: serif(size: 26, weight: FontWeight.w600, height: 1.18, letterSpacing: -0.3),
      headlineSmall: serif(size: 22, weight: FontWeight.w600, height: 1.22, letterSpacing: -0.2),
      titleLarge: serif(size: 19, weight: FontWeight.w600, height: 1.3, letterSpacing: -0.1),
      titleMedium: serif(size: 16, weight: FontWeight.w600, height: 1.35),
      titleSmall: sans(size: 14, weight: FontWeight.w600, height: 1.35),
      bodyLarge: sans(size: 15, height: 1.55),
      bodyMedium: sans(size: 14, height: 1.55),
      bodySmall: sans(size: 12, height: 1.5, color: ash),
      labelLarge: sans(size: 14, weight: FontWeight.w600, height: 1.2, letterSpacing: 0.2),
      labelMedium: sans(size: 12, weight: FontWeight.w500, height: 1.2, letterSpacing: 0.4),
      labelSmall: sans(size: 11, weight: FontWeight.w600, height: 1.2, letterSpacing: 1.6),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      textTheme: tt,
      iconTheme: const IconThemeData(color: ink, size: 20),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        surfaceTintColor: cream,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: serif(size: 22, weight: FontWeight.w600),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
          backgroundColor: const WidgetStatePropertyAll(ink),
          foregroundColor: const WidgetStatePropertyAll(cream),
          textStyle: WidgetStatePropertyAll(
            sans(size: 14, weight: FontWeight.w600, letterSpacing: 1.6),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(color: hairline),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: TextTheme(
        bodyLarge: sans(size: 15, color: cream),
        bodyMedium: sans(size: 14, color: cream),
        titleLarge: serif(size: 19, weight: FontWeight.w600, color: cream),
      ),
    );
  }
}