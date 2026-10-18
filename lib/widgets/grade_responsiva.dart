import 'package:flutter/material.dart';

/// Grade que calcula o número de colunas pela largura disponível.
/// Os itens de uma mesma linha ficam com a mesma altura.
class GradeResponsiva extends StatelessWidget {
  const GradeResponsiva({
    super.key,
    required this.children,
    this.larguraMinimaItem = 260,
    this.maxColunas = 4,
    this.espaco = 16,
  });

  final List<Widget> children;
  final double larguraMinimaItem;
  final int maxColunas;
  final double espaco;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricoes) {
        final colunas =
            ((restricoes.maxWidth + espaco) ~/ (larguraMinimaItem + espaco))
                .clamp(1, maxColunas);
        final linhas = <Widget>[];
        for (var i = 0; i < children.length; i += colunas) {
          final itens = children.sublist(
            i,
            (i + colunas).clamp(0, children.length),
          );
          linhas.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < colunas; j++) ...[
                    if (j > 0) SizedBox(width: espaco),
                    Expanded(
                      child: j < itens.length ? itens[j] : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < linhas.length; i++) ...[
              if (i > 0) SizedBox(height: espaco),
              linhas[i],
            ],
          ],
        );
      },
    );
  }
}
