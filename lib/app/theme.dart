import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta da marca TENEFAR.
///
/// Duas cores principais (tinta e papel, tiradas da logo) e um único
/// destaque forte (ocre "farinha dourada"). TROQUE AQUI as cores.
class Cores {
  Cores._();

  static const tinta = Color(0xFF1A2C30); // cor da logo
  static const papel = Color(0xFFF3EFE6);
  static const destaque = Color(0xFFE3A22E); // ocre: marca-texto, barras, foco

  static const papelClaro = Color(0xFFFAF8F3); // painéis no modo claro
  static const tintaProfunda = Color(0xFF0F1B1D); // fundo no modo escuro
  static const papelEscuro = Color(0xFFEDE8DD); // texto no modo escuro
}

/// Tokens da marca que não cabem no ColorScheme: tons derivados, fundo dos
/// blocos escuros e o estilo monoespaçado usado em rótulos e números.
@immutable
class MarcaTema extends ThemeExtension<MarcaTema> {
  const MarcaTema({
    required this.fundo,
    required this.texto,
    required this.textoSuave,
    required this.linha,
    required this.destaque,
    required this.painel,
    required this.blocoFundo,
    required this.blocoTexto,
    required this.blocoTextoSuave,
    required this.mono,
  });

  final Color fundo;
  final Color texto;
  final Color textoSuave;
  final Color linha;
  final Color destaque;
  final Color painel;
  final Color blocoFundo;
  final Color blocoTexto;
  final Color blocoTextoSuave;

  /// Base monoespaçada (sem cor): rótulos, metadados e números.
  final TextStyle mono;

  @override
  MarcaTema copyWith({TextStyle? mono}) => MarcaTema(
    fundo: fundo,
    texto: texto,
    textoSuave: textoSuave,
    linha: linha,
    destaque: destaque,
    painel: painel,
    blocoFundo: blocoFundo,
    blocoTexto: blocoTexto,
    blocoTextoSuave: blocoTextoSuave,
    mono: mono ?? this.mono,
  );

  @override
  MarcaTema lerp(MarcaTema? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return MarcaTema(
      fundo: c(fundo, other.fundo),
      texto: c(texto, other.texto),
      textoSuave: c(textoSuave, other.textoSuave),
      linha: c(linha, other.linha),
      destaque: c(destaque, other.destaque),
      painel: c(painel, other.painel),
      blocoFundo: c(blocoFundo, other.blocoFundo),
      blocoTexto: c(blocoTexto, other.blocoTexto),
      blocoTextoSuave: c(blocoTextoSuave, other.blocoTextoSuave),
      mono: TextStyle.lerp(mono, other.mono, t)!,
    );
  }
}

extension MarcaContexto on BuildContext {
  MarcaTema get marca => Theme.of(this).extension<MarcaTema>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData claro({bool usarGoogleFonts = true}) =>
      _construir(Brightness.light, usarGoogleFonts);

  static ThemeData escuro({bool usarGoogleFonts = true}) =>
      _construir(Brightness.dark, usarGoogleFonts);

  static Color _sobre(Color cor, double alfa, Color fundo) =>
      Color.alphaBlend(cor.withValues(alpha: alfa), fundo);

  static ThemeData _construir(Brightness brilho, bool usarGoogleFonts) {
    final claro = brilho == Brightness.light;
    final fundo = claro ? Cores.papel : Cores.tintaProfunda;
    final texto = claro ? Cores.tinta : Cores.papelEscuro;
    final blocoFundo = claro ? Cores.tinta : const Color(0xFF1F3438);
    final blocoTexto = claro ? Cores.papel : Cores.papelEscuro;

    final marca = MarcaTema(
      fundo: fundo,
      texto: texto,
      textoSuave: _sobre(texto, 0.70, fundo),
      linha: _sobre(texto, 0.14, fundo),
      destaque: Cores.destaque,
      painel: claro ? Cores.papelClaro : const Color(0xFF162629),
      blocoFundo: blocoFundo,
      blocoTexto: blocoTexto,
      blocoTextoSuave: _sobre(blocoTexto, 0.70, blocoFundo),
      mono: usarGoogleFonts
          ? GoogleFonts.ibmPlexMono(fontWeight: FontWeight.w500)
          : const TextStyle(fontFamily: 'monospace'),
    );

    final esquema =
        ColorScheme.fromSeed(
          seedColor: Cores.tinta,
          brightness: brilho,
        ).copyWith(
          primary: texto,
          onPrimary: fundo,
          primaryContainer: _sobre(texto, 0.08, fundo),
          onPrimaryContainer: texto,
          secondary: Cores.destaque,
          onSecondary: Cores.tinta,
          secondaryContainer: _sobre(Cores.destaque, 0.30, fundo),
          onSecondaryContainer: texto,
          tertiary: Cores.destaque,
          onTertiary: Cores.tinta,
          tertiaryContainer: _sobre(Cores.destaque, 0.20, fundo),
          onTertiaryContainer: texto,
          surface: fundo,
          onSurface: texto,
          onSurfaceVariant: marca.textoSuave,
          outline: _sobre(texto, 0.45, fundo),
          outlineVariant: marca.linha,
          surfaceContainerLowest: marca.painel,
          surfaceContainerLow: _sobre(texto, 0.03, fundo),
          surfaceContainer: _sobre(texto, 0.05, fundo),
          surfaceContainerHigh: _sobre(texto, 0.07, fundo),
          surfaceContainerHighest: _sobre(texto, 0.10, fundo),
          inverseSurface: texto,
          onInverseSurface: fundo,
          surfaceTint: Colors.transparent,
        );

    final tipografia = _tipografia(texto, usarGoogleFonts);
    final forma6 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    );
    final rotuloBotao = tipografia.labelLarge?.copyWith(fontSize: 15);

    return ThemeData(
      useMaterial3: true,
      brightness: brilho,
      colorScheme: esquema,
      textTheme: tipografia,
      scaffoldBackgroundColor: fundo,
      extensions: [marca],
      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        foregroundColor: texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 72,
      ),
      dividerTheme: DividerThemeData(
        color: marca.linha,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: texto,
          foregroundColor: fundo,
          disabledBackgroundColor: marca.linha,
          shape: forma6,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          textStyle: rotuloBotao,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: texto,
          side: BorderSide(color: texto, width: 1.2),
          shape: forma6,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          textStyle: rotuloBotao,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: texto,
          shape: forma6,
          textStyle: rotuloBotao,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: marca.painel,
        labelStyle: TextStyle(color: marca.textoSuave),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: esquema.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: texto, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: marca.linha),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: Cores.destaque,
        checkmarkColor: Cores.tinta,
        side: BorderSide(color: esquema.outline.withValues(alpha: 0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        labelStyle: tipografia.labelLarge,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: texto,
        unselectedLabelColor: marca.textoSuave,
        labelStyle: tipografia.labelLarge?.copyWith(fontSize: 15),
        dividerColor: marca.linha,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Cores.destaque, width: 3),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(forma6),
          side: WidgetStatePropertyAll(BorderSide(color: esquema.outline)),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? texto : null,
          ),
          foregroundColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.disabled)) return esquema.outline;
            return s.contains(WidgetState.selected) ? fundo : texto;
          }),
          textStyle: WidgetStatePropertyAll(tipografia.labelLarge),
        ),
      ),
      cardTheme: CardThemeData(
        color: marca.painel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: marca.linha),
        ),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: fundo, elevation: 0),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: texto,
        selectionColor: Cores.destaque.withValues(alpha: 0.4),
      ),
    );
  }

  /// TROQUE AQUI as fontes: Fraunces (títulos, pesos leves + itálico de
  /// ênfase) e Instrument Sans (texto). A mono fica em [MarcaTema.mono].
  static TextTheme _tipografia(Color cor, bool usarGoogleFonts) {
    TextStyle estilo(
      double tamanho,
      FontWeight peso,
      double altura,
      double espaco, {
      required bool serifada,
    }) {
      final base = TextStyle(
        fontSize: tamanho,
        fontWeight: peso,
        height: altura,
        letterSpacing: espaco,
        color: cor,
      );
      if (!usarGoogleFonts) return base;
      return serifada
          ? GoogleFonts.fraunces(textStyle: base)
          : GoogleFonts.instrumentSans(textStyle: base);
    }

    TextStyle serif(double t, FontWeight p, double a, double e) =>
        estilo(t, p, a, e, serifada: true);
    TextStyle sans(double t, FontWeight p, double a, [double e = 0]) =>
        estilo(t, p, a, e, serifada: false);

    return TextTheme(
      displayLarge: serif(96, FontWeight.w300, 0.98, -2.8),
      displayMedium: serif(64, FontWeight.w300, 1.02, -1.8),
      displaySmall: serif(46, FontWeight.w300, 1.08, -1.1),
      headlineLarge: serif(40, FontWeight.w400, 1.1, -0.8),
      headlineMedium: serif(32, FontWeight.w400, 1.15, -0.5),
      headlineSmall: serif(26, FontWeight.w400, 1.2, -0.3),
      titleLarge: serif(22, FontWeight.w500, 1.25, -0.2),
      titleMedium: sans(17, FontWeight.w600, 1.35),
      titleSmall: sans(15, FontWeight.w600, 1.35),
      bodyLarge: sans(17, FontWeight.w400, 1.6),
      bodyMedium: sans(15, FontWeight.w400, 1.55),
      bodySmall: sans(13, FontWeight.w400, 1.45),
      labelLarge: sans(14, FontWeight.w600, 1.3, 0.1),
      labelMedium: sans(12, FontWeight.w600, 1.3, 0.2),
      labelSmall: sans(11, FontWeight.w600, 1.3, 0.3),
    );
  }
}

/// O google_fonts registra cada peso/estilo como uma família separada
/// (ex.: "Fraunces_300"), então `copyWith(fontWeight/fontStyle)` sozinho não
/// troca o arquivo e o navegador "simula" negrito e itálico. Este ajuste
/// recarrega a variante certa — necessário para o itálico verdadeiro de
/// *Tenebrio molitor* e para os pesos leves dos títulos.
final Map<String, TextStyle Function({TextStyle? textStyle})> _fontesGoogle = {
  'Fraunces': ({textStyle}) => GoogleFonts.fraunces(textStyle: textStyle),
  'InstrumentSans': ({textStyle}) =>
      GoogleFonts.instrumentSans(textStyle: textStyle),
  'IBMPlexMono': ({textStyle}) => GoogleFonts.ibmPlexMono(textStyle: textStyle),
};

TextStyle ajustarFonte(TextStyle estilo) {
  final familias = estilo.fontFamilyFallback;
  if (familias == null || familias.isEmpty) return estilo;
  final construtor = _fontesGoogle[familias.first];
  return construtor == null ? estilo : construtor(textStyle: estilo);
}

extension AjusteFonte on TextStyle {
  /// Ver [ajustarFonte].
  TextStyle get fonte => ajustarFonte(this);
}
