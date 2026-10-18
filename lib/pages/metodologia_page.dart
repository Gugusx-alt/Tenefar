import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/gantt_cronograma.dart';
import '../widgets/secao.dart';
import '../widgets/timeline_etapas.dart';

class MetodologiaPage extends StatelessWidget {
  const MetodologiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      titulo: 'Metodologia',
      children: [
        CabecalhoPagina(
          numero: '03',
          rotulo: 'Metodologia',
          titulo: 'Da criação das larvas ao *pó nutricional*.',
          introducao:
              'O processo foi pensado para ser de baixo custo e reproduzível '
              'em locais com pouca infraestrutura. São seis etapas, da criação '
              'controlada do *Tenebrio molitor* às análises do pó.',
        ),
        SecaoEditorial(
          numero: '01',
          rotulo: 'Etapas',
          child: TimelineEtapas(etapas: etapasMetodologia),
        ),
        SecaoEditorial(
          numero: '02',
          rotulo: 'Cronograma',
          titulo: '12 meses, de setembro a agosto.',
          child: GanttCronograma(
            atividades: cronograma,
            meses: mesesCronograma,
          ),
        ),
      ],
    );
  }
}
