import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';

/// Card de um Objetivo de Desenvolvimento Sustentável com a cor oficial.
class OdsCard extends StatelessWidget {
  const OdsCard({super.key, required this.ods});

  final Ods ods;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Semantics(
      label: 'ODS ${ods.numero}: ${ods.nome}',
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Color(ods.cor),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'ODS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${ods.numero}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                ods.nome,
                style: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
