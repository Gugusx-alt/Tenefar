import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/gantt_cronograma.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';
import '../widgets/timeline_etapas.dart';

class MetodologiaPage extends StatelessWidget {
  const MetodologiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return AppScaffold(
      titulo: 'Metodologia',
      children: [
        Secao(
          sobretitulo: 'Metodologia',
          titulo: 'Da criação das larvas ao pó nutricional',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextoRico(
                'O processo foi pensado para ser de baixo custo e reproduzível '
                'em locais com pouca infraestrutura. São seis etapas, da criação '
                'controlada do *Tenebrio molitor* às análises do pó.',
                estilo: tema.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              const SizedBox(height: 32),
              const TimelineEtapas(etapas: etapasMetodologia),
            ],
          ),
        ),
        Secao(
          titulo: 'Cronograma',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '12 meses de execução, de setembro a agosto.',
                style: tema.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              const GanttCronograma(
                atividades: cronograma,
                meses: mesesCronograma,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
