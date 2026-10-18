import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/conteudo_projeto.dart';

/// Objetivo de Desenvolvimento Sustentável: quadrado com a cor oficial da ONU
/// e o número, seguido do nome.
class OdsCard extends StatelessWidget {
  const OdsCard({super.key, required this.ods});

  final Ods ods;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    return Semantics(
      label: 'ODS ${ods.numero}: ${ods.nome}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: m.linha)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              color: Color(ods.cor),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomLeft,
              child: Text(
                '${ods.numero}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ODS ${ods.numero}',
                    style: m.mono.copyWith(fontSize: 12, color: m.textoSuave),
                  ),
                  const SizedBox(height: 2),
                  Text(ods.nome, style: tema.textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
