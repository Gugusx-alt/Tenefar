import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cores e tipografia do app.
///
/// TROQUE AQUI as cores: [Cores.semente] gera a paleta Material 3; as demais
/// ajustam os tons terrosos (fundo aveia e secundária marrom-dourada).
class Cores {
  Cores._();

  static const semente = Color(0xFF3F7D4E); // verde de destaque
  static const secundariaClaro = Color(0xFF8A5F28); // marrom-dourado
  static const secundariaEscuro = Color(0xFFE0B878);
  static const fundoClaro = Color(0xFFF7F2E7); // bege/aveia
  static const fundoEscuro = Color(0xFF171A15);
  // Terciária âmbar: avisos e selo "Em andamento".
  static const avisoClaro = Color(0xFFFBE3BE);
  static const avisoTextoClaro = Color(0xFF4A2800);
  static const avisoEscuro = Color(0xFF5A3A0E);
  static const avisoTextoEscuro = Color(0xFFFFDDB0);
}

class AppTheme {
  AppTheme._();

  static ThemeData claro({bool usarGoogleFonts = true}) =>
      _construir(Brightness.light, usarGoogleFonts);

  static ThemeData escuro({bool usarGoogleFonts = true}) =>
      _construir(Brightness.dark, usarGoogleFonts);

  static ThemeData _construir(Brightness brilho, bool usarGoogleFonts) {
    final claro = brilho == Brightness.light;
    final esquema = ColorScheme.fromSeed(
      seedColor: Cores.semente,
      brightness: brilho,
      secondary: claro ? Cores.secundariaClaro : Cores.secundariaEscuro,
      onSecondary: claro ? Colors.white : const Color(0xFF3A2606),
      surface: claro ? Cores.fundoClaro : Cores.fundoEscuro,
      tertiaryContainer: claro ? Cores.avisoClaro : Cores.avisoEscuro,
      onTertiaryContainer: claro
          ? Cores.avisoTextoClaro
          : Cores.avisoTextoEscuro,
    );

    final base = ThemeData(colorScheme: esquema, useMaterial3: true);
    final texto = usarGoogleFonts
        ? _tipografia(base.textTheme)
        : base.textTheme;

    return base.copyWith(
      textTheme: texto,
      scaffoldBackgroundColor: esquema.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.surface,
        foregroundColor: esquema.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        titleTextStyle: texto.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: esquema.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: claro ? Colors.white : esquema.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: esquema.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: claro ? Colors.white : esquema.surfaceContainerHighest,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          textStyle: texto.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          textStyle: texto.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: DividerThemeData(color: esquema.outlineVariant),
    );
  }

  /// TROQUE AQUI as fontes: serifada nos títulos, sans-serif no texto.
  static TextTheme _tipografia(TextTheme base) {
    // Estilo a estilo (e não com GoogleFonts.xxxTextTheme) porque o
    // google_fonts 9 usa o TextTheme do pacote material_ui; TextStyle é comum aos dois.
    TextStyle? serif(TextStyle? estilo) =>
        GoogleFonts.fraunces(textStyle: estilo, fontWeight: FontWeight.w600);
    TextStyle? sans(TextStyle? estilo) =>
        GoogleFonts.nunitoSans(textStyle: estilo);
    return base.copyWith(
      displayLarge: serif(base.displayLarge),
      displayMedium: serif(base.displayMedium),
      displaySmall: serif(base.displaySmall),
      headlineLarge: serif(base.headlineLarge),
      headlineMedium: serif(base.headlineMedium),
      headlineSmall: serif(base.headlineSmall),
      titleLarge: serif(base.titleLarge),
      titleMedium: sans(base.titleMedium),
      titleSmall: sans(base.titleSmall),
      bodyLarge: sans(base.bodyLarge),
      bodyMedium: sans(base.bodyMedium),
      bodySmall: sans(base.bodySmall),
      labelLarge: sans(base.labelLarge),
      labelMedium: sans(base.labelMedium),
      labelSmall: sans(base.labelSmall),
    );
  }
}
