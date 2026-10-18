import 'package:flutter/material.dart';

import 'entrada_animada.dart';
import 'texto_rico.dart';

/// Medidas de layout responsivo usadas em todo o app.
class Layout {
  Layout._();

  /// A partir desta largura a navegação fica em linha na barra superior.
  static const double desktop = 900;

  /// Largura máxima do conteúdo centralizado.
  static const double larguraMaxima = 1100;

  static double margemHorizontal(double largura) => largura < 600 ? 16 : 24;
}

/// Faixa de conteúdo de largura total, com o conteúdo centralizado e limitado
/// a [Layout.larguraMaxima]. Opcionalmente mostra um sobretítulo e um título.
class Secao extends StatelessWidget {
  const Secao({
    super.key,
    required this.child,
    this.titulo,
    this.sobretitulo,
    this.decoracao,
    this.espacoVertical = 48,
  });

  final Widget child;

  /// Aceita *itálico* (ex.: nomes científicos).
  final String? titulo;
  final String? sobretitulo;
  final BoxDecoration? decoracao;
  final double espacoVertical;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final largura = MediaQuery.sizeOf(context).width;
    return DecoratedBox(
      decoration: decoracao ?? const BoxDecoration(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Layout.larguraMaxima),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Layout.margemHorizontal(largura),
              vertical: largura < 600 ? espacoVertical * 0.7 : espacoVertical,
            ),
            child: EntradaAnimada(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (sobretitulo != null) ...[
                    Text(
                      sobretitulo!.toUpperCase(),
                      style: tema.textTheme.labelLarge?.copyWith(
                        color: tema.colorScheme.secondary,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (titulo != null) ...[
                    Semantics(
                      header: true,
                      child: TextoRico(
                        titulo!,
                        estilo:
                            (largura < 600
                                    ? tema.textTheme.headlineSmall
                                    : tema.textTheme.headlineMedium)
                                ?.copyWith(color: tema.colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Selo arredondado de status, ex.: "Em andamento".
class SeloStatus extends StatelessWidget {
  const SeloStatus(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Status: $texto',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: esquema.tertiaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_top,
              size: 16,
              color: esquema.onTertiaryContainer,
            ),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                color: esquema.onTertiaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
