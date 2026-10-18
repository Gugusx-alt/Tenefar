import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import 'texto_rico.dart';

/// Linha do tempo vertical das etapas da metodologia.
class TimelineEtapas extends StatelessWidget {
  const TimelineEtapas({super.key, required this.etapas});

  final List<Etapa> etapas;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < etapas.length; i++)
          Semantics(
            container: true,
            label: 'Etapa ${i + 1} de ${etapas.length}: ${etapas[i].titulo}',
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: esquema.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            etapas[i].icone,
                            color: esquema.onPrimary,
                          ),
                        ),
                        if (i < etapas.length - 1)
                          Expanded(
                            child: Container(
                              width: 3,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: esquema.primary.withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: i < etapas.length - 1 ? 32 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ETAPA ${i + 1}',
                            style: tema.textTheme.labelMedium?.copyWith(
                              color: esquema.secondary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            etapas[i].titulo,
                            style: tema.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          TextoRico(
                            etapas[i].descricao,
                            estilo: tema.textTheme.bodyLarge?.copyWith(
                              color: esquema.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
