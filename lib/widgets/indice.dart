import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'interacao.dart';
import 'texto_rico.dart';

/// Linha de um índice editorial (substitui a grade de cards).
/// No hover/foco: o título vai para itálico, um traço ocre entra antes dele
/// e a seta avança — como apontar uma entrada no sumário.
class LinhaIndice extends StatelessWidget {
  const LinhaIndice({
    super.key,
    required this.numero,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  final String numero;
  final String titulo;

  /// Aceita *itálico*.
  final String descricao;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    final duracao = duracaoMicro(context, 260);

    return Interativo(
      aoTocar: aoTocar,
      raio: 0,
      rotuloSemantico: '$titulo. ${semMarcadores(descricao)}',
      builder: (context, ativo) {
        final numeroW = Text(
          numero,
          style: m.mono.copyWith(fontSize: 13, color: m.textoSuave),
        );
        final tituloW = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: duracao,
              curve: Curves.easeOutCubic,
              width: ativo ? 28 : 0,
              height: 3,
              margin: EdgeInsets.only(right: ativo ? 14 : 0),
              color: m.destaque,
            ),
            Flexible(
              child: Text(
                titulo,
                style: tema.textTheme.headlineMedium
                    ?.copyWith(
                      fontStyle: ativo ? FontStyle.italic : FontStyle.normal,
                    )
                    .fonte,
              ),
            ),
          ],
        );
        final descricaoW = TextoRico(
          descricao,
          estilo: tema.textTheme.bodyMedium?.copyWith(color: m.textoSuave),
        );
        final seta = AnimatedSlide(
          duration: duracao,
          curve: Curves.easeOutCubic,
          offset: Offset(ativo ? 0.25 : 0, 0),
          child: Icon(Icons.arrow_forward, color: m.texto),
        );

        return ExcludeSemantics(
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: m.linha)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: LayoutBuilder(
              builder: (context, r) => r.maxWidth >= 640
                  ? Row(
                      children: [
                        SizedBox(width: 64, child: numeroW),
                        Expanded(flex: 5, child: tituloW),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: descricaoW),
                        const SizedBox(width: 24),
                        seta,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 44,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: numeroW,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tituloW,
                              const SizedBox(height: 6),
                              descricaoW,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: seta,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Lista de definições (rótulo mono à esquerda, valor à direita), com fios.
class ListaDefinicoes extends StatelessWidget {
  const ListaDefinicoes({super.key, required this.itens});

  /// Pares rótulo → valor; o valor aceita *itálico*.
  final List<(String, String)> itens;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    return LayoutBuilder(
      builder: (context, r) {
        final largo = r.maxWidth >= 560;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (rotulo, valor) in itens)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: m.linha)),
                ),
                child: Flex(
                  direction: largo ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: largo ? 180 : null,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: largo ? 3 : 0,
                          bottom: largo ? 0 : 4,
                        ),
                        child: Text(
                          rotulo.toUpperCase(),
                          style: m.mono.copyWith(
                            fontSize: 12,
                            letterSpacing: 1.1,
                            color: m.textoSuave,
                          ),
                        ),
                      ),
                    ),
                    if (largo)
                      Expanded(
                        child: TextoRico(
                          valor,
                          estilo: tema.textTheme.bodyLarge,
                        ),
                      )
                    else
                      TextoRico(valor, estilo: tema.textTheme.bodyLarge),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Item de lista numerada com fio superior: 01  Texto do item.
class ItemNumerado extends StatelessWidget {
  const ItemNumerado({
    super.key,
    required this.numero,
    required this.texto,
    this.estilo,
  });

  final int numero;

  /// Aceita *itálico*.
  final String texto;
  final TextStyle? estilo;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: m.linha)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                numero.toString().padLeft(2, '0'),
                style: m.mono.copyWith(fontSize: 13, color: m.textoSuave),
              ),
            ),
          ),
          Expanded(
            child: TextoRico(
              texto,
              estilo: estilo ?? Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
