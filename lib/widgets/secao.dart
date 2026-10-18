import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'entrada_animada.dart';
import 'texto_rico.dart';

/// Medidas do layout responsivo.
class Layout {
  Layout._();

  /// A partir desta largura a navegação fica em linha na barra superior.
  static const double desktop = 900;

  /// Largura máxima do conteúdo.
  static const double larguraMaxima = 1200;

  /// Largura da coluna de rótulos das seções editoriais (telas largas).
  static const double colunaRotulo = 220;

  static double margem(double largura) {
    if (largura < 600) return 20;
    if (largura < 1100) return 40;
    return 56;
  }

  static bool largo(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Layout.desktop;
}

/// Tema invertido (texto claro sobre tinta) para os blocos escuros.
ThemeData temaBloco(BuildContext context) {
  final tema = Theme.of(context);
  final m = context.marca;
  final linha = Color.alphaBlend(
    m.blocoTexto.withValues(alpha: 0.16),
    m.blocoFundo,
  );
  return tema.copyWith(
    textTheme: tema.textTheme.apply(
      bodyColor: m.blocoTexto,
      displayColor: m.blocoTexto,
    ),
    iconTheme: IconThemeData(color: m.blocoTexto),
    dividerTheme: DividerThemeData(color: linha, thickness: 1, space: 1),
    colorScheme: tema.colorScheme.copyWith(
      primary: m.blocoTexto,
      onPrimary: m.blocoFundo,
      onSurface: m.blocoTexto,
      onSurfaceVariant: m.blocoTextoSuave,
      outlineVariant: linha,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: m.blocoTexto,
        foregroundColor: m.blocoFundo,
      ).merge(tema.filledButtonTheme.style),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: m.blocoTexto),
    ),
    extensions: [
      MarcaTema(
        fundo: m.blocoFundo,
        texto: m.blocoTexto,
        textoSuave: m.blocoTextoSuave,
        linha: linha,
        destaque: m.destaque,
        painel: Color.alphaBlend(
          m.blocoTexto.withValues(alpha: 0.06),
          m.blocoFundo,
        ),
        blocoFundo: m.fundo,
        blocoTexto: m.texto,
        blocoTextoSuave: m.textoSuave,
        mono: m.mono,
      ),
    ],
  );
}

/// Faixa de largura total com o conteúdo centralizado e limitado.
/// Com [escuro], o fundo é tinta e o texto, papel.
class Secao extends StatelessWidget {
  const Secao({
    super.key,
    required this.child,
    this.escuro = false,
    this.espacoVertical = 96,
    this.animar = true,
  });

  final Widget child;
  final bool escuro;
  final double espacoVertical;
  final bool animar;

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.sizeOf(context).width;
    Widget conteudo = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Layout.larguraMaxima),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Layout.margem(largura),
            vertical: largura < 600 ? espacoVertical * 0.6 : espacoVertical,
          ),
          child: animar ? EntradaAnimada(child: child) : child,
        ),
      ),
    );
    if (!escuro) return conteudo;
    final tema = temaBloco(context);
    return ColoredBox(
      color: context.marca.blocoFundo,
      child: Theme(
        data: tema,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: context.marca.blocoTexto),
          child: conteudo,
        ),
      ),
    );
  }
}

/// Rótulo monoespaçado de seção: ■ 01 — O PROBLEMA
class RotuloSecao extends StatelessWidget {
  const RotuloSecao({super.key, this.numero, required this.texto});

  final String? numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Semantics(
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, color: m.destaque),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              [?numero, texto.toUpperCase()].join('  —  '),
              style: m.mono.copyWith(
                fontSize: 12.5,
                letterSpacing: 1.3,
                color: m.textoSuave,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Seção com coluna lateral de rótulo (telas largas) — cria a assimetria do
/// layout. Em telas estreitas o rótulo fica acima do conteúdo.
class SecaoEditorial extends StatelessWidget {
  const SecaoEditorial({
    super.key,
    this.numero,
    required this.rotulo,
    this.titulo,
    required this.child,
    this.escuro = false,
    this.espacoVertical = 96,
    this.linhaSuperior = true,
  });

  final String? numero;
  final String rotulo;

  /// Título serifado; aceita *itálico*.
  final String? titulo;
  final Widget child;
  final bool escuro;
  final double espacoVertical;
  final bool linhaSuperior;

  @override
  Widget build(BuildContext context) {
    return Secao(
      escuro: escuro,
      espacoVertical: espacoVertical,
      child: LayoutBuilder(
        builder: (context, restricoes) {
          final tema = Theme.of(context);
          final largo = restricoes.maxWidth >= 860;
          final rotuloWidget = RotuloSecao(numero: numero, texto: rotulo);
          final corpo = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (titulo != null) ...[
                Semantics(
                  header: true,
                  child: TextoRico(
                    titulo!,
                    estilo: largo
                        ? tema.textTheme.displaySmall
                        : tema.textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.w300)
                              .fonte,
                  ),
                ),
                SizedBox(height: largo ? 40 : 28),
              ],
              child,
            ],
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (linhaSuperior) ...[
                const Divider(),
                SizedBox(height: largo ? 28 : 20),
              ],
              if (largo)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Layout.colunaRotulo,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 24),
                        child: rotuloWidget,
                      ),
                    ),
                    Expanded(child: corpo),
                  ],
                )
              else ...[
                rotuloWidget,
                const SizedBox(height: 20),
                corpo,
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Indicador "em andamento": ponto ocre que pulsa algumas vezes ao aparecer
/// (o projeto está vivo) e depois fica parado.
class StatusAndamento extends StatefulWidget {
  const StatusAndamento({super.key, required this.texto, this.detalhe});

  final String texto;
  final String? detalhe;

  @override
  State<StatusAndamento> createState() => _StatusAndamentoState();
}

class _StatusAndamentoState extends State<StatusAndamento>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulso = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  int _repeticoes = 0;

  @override
  void initState() {
    super.initState();
    _pulso.addStatusListener((status) {
      if (status == AnimationStatus.completed && ++_repeticoes < 4) {
        _pulso.forward(from: 0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context) && _repeticoes == 0) {
      _pulso.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final estilo = m.mono.copyWith(fontSize: 13, letterSpacing: 0.8);
    return Semantics(
      label: 'Status: ${widget.texto}. ${widget.detalhe ?? ''}',
      excludeSemantics: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 6,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: AnimatedBuilder(
              animation: _pulso,
              builder: (context, _) {
                final t = Curves.easeOut.transform(_pulso.value);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_pulso.isAnimating)
                      Container(
                        width: 10 + 12 * t,
                        height: 10 + 12 * t,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: m.destaque.withValues(alpha: 0.45 * (1 - t)),
                        ),
                      ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: m.destaque,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Text(
            widget.texto.toUpperCase(),
            style: estilo
                .copyWith(color: m.texto, fontWeight: FontWeight.w600)
                .fonte,
          ),
          if (widget.detalhe != null)
            Text(widget.detalhe!, style: estilo.copyWith(color: m.textoSuave)),
        ],
      ),
    );
  }
}

/// Cabeçalho das páginas internas: rótulo mono, título grande e uma
/// introdução recuada pela coluna de rótulos (assimetria intencional).
class CabecalhoPagina extends StatelessWidget {
  const CabecalhoPagina({
    super.key,
    required this.numero,
    required this.rotulo,
    required this.titulo,
    this.introducao,
    this.extra,
  });

  final String numero;
  final String rotulo;

  /// Aceita *itálico*.
  final String titulo;

  /// Aceita *itálico*.
  final String? introducao;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final largura = MediaQuery.sizeOf(context).width;
    final tamanho = largura < 600 ? 38.0 : (largura < 1100 ? 52.0 : 64.0);
    return Secao(
      espacoVertical: 72,
      child: LayoutBuilder(
        builder: (context, r) {
          final largo = r.maxWidth >= 860;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RotuloSecao(numero: numero, texto: rotulo),
              SizedBox(height: largo ? 40 : 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Semantics(
                  header: true,
                  child: TextoRico(
                    titulo,
                    estilo: tema.textTheme.displayMedium?.copyWith(
                      fontSize: tamanho,
                      letterSpacing: -tamanho * 0.028,
                    ),
                  ),
                ),
              ),
              if (introducao != null || extra != null) ...[
                SizedBox(height: largo ? 48 : 28),
                Padding(
                  padding: EdgeInsets.only(
                    left: largo ? Layout.colunaRotulo : 0,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (introducao != null)
                          TextoRico(
                            introducao!,
                            estilo: tema.textTheme.bodyLarge?.copyWith(
                              fontSize: 19,
                              height: 1.6,
                            ),
                          ),
                        if (extra != null) ...[
                          const SizedBox(height: 24),
                          extra!,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
