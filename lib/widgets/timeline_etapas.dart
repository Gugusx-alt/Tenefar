import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import 'texto_rico.dart';

/// Linha do tempo vertical das etapas da metodologia: número mono, fio
/// vertical, ícone e título serifado.
class TimelineEtapas extends StatelessWidget {
  const TimelineEtapas({super.key, required this.etapas});

  final List<Etapa> etapas;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < etapas.length; i++)
          Semantics(
            container: true,
            label: 'Etapa ${i + 1} de ${etapas.length}: ${etapas[i].titulo}',
            child: Stack(
              children: [
                // Fio que liga esta etapa à próxima.
                if (i < etapas.length - 1)
                  Positioned(
                    left: 3.5,
                    top: 44,
                    bottom: 0,
                    width: 1,
                    child: ColoredBox(color: m.linha),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i < etapas.length - 1 ? 48 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 56,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (i + 1).toString().padLeft(2, '0'),
                              style: m.mono.copyWith(
                                fontSize: 13,
                                color: m.textoSuave,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(width: 8, height: 8, color: m.destaque),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(etapas[i].icone, size: 22, color: m.texto),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    etapas[i].titulo,
                                    style: tema.textTheme.headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 640),
                              child: TextoRico(
                                etapas[i].descricao,
                                estilo: tema.textTheme.bodyLarge?.copyWith(
                                  color: m.textoSuave,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
