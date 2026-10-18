import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import 'texto_rico.dart';

/// Gráfico de Gantt do cronograma feito só com widgets.
/// Em telas estreitas rola na horizontal dentro do próprio card.
class GanttCronograma extends StatefulWidget {
  const GanttCronograma({
    super.key,
    required this.atividades,
    required this.meses,
  });

  final List<AtividadeCronograma> atividades;
  final List<String> meses;

  @override
  State<GanttCronograma> createState() => _GanttCronogramaState();
}

class _GanttCronogramaState extends State<GanttCronograma> {
  static const _larguraRotulo = 280.0;
  static const _larguraMes = 52.0;
  static const _alturaLinha = 52.0;

  final _rolagem = ScrollController();

  @override
  void dispose() {
    _rolagem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    final cabecalho = Row(
      children: [
        SizedBox(
          width: _larguraRotulo,
          child: Text(
            'Atividade',
            style: tema.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        for (final mes in widget.meses)
          SizedBox(
            width: _larguraMes,
            child: Text(
              mes,
              textAlign: TextAlign.center,
              style: tema.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: esquema.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );

    final linhas = <Widget>[
      for (var i = 0; i < widget.atividades.length; i++)
        _linha(context, widget.atividades[i], par: i.isEven),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Scrollbar(
          controller: _rolagem,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _rolagem,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [cabecalho, const SizedBox(height: 8), ...linhas],
            ),
          ),
        ),
      ),
    );
  }

  Widget _linha(
    BuildContext context,
    AtividadeCronograma atividade, {
    required bool par,
  }) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final nomesMeses = [
      for (var m = 0; m < widget.meses.length; m++)
        if (atividade.meses.contains(m)) widget.meses[m],
    ];

    return Semantics(
      label: '${semMarcadores(atividade.atividade)}: ${nomesMeses.join(', ')}',
      excludeSemantics: true,
      child: Container(
        height: _alturaLinha,
        color: par ? esquema.surfaceContainerLow : null,
        child: Row(
          children: [
            SizedBox(
              width: _larguraRotulo,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: TextoRico(
                  atividade.atividade,
                  estilo: tema.textTheme.bodyMedium,
                  maxLinhas: 2,
                ),
              ),
            ),
            for (var m = 0; m < widget.meses.length; m++)
              SizedBox(
                width: _larguraMes,
                height: _alturaLinha,
                // Linha-guia na divisa entre os meses (DecoratedBox não soma a
                // borda como padding, então a barra cobre a linha).
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: esquema.outlineVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  child: atividade.meses.contains(m)
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 14,
                            bottom: 14,
                            left: atividade.meses.contains(m - 1) ? 0 : 3,
                            right: atividade.meses.contains(m + 1) ? 0 : 3,
                          ),
                          decoration: BoxDecoration(
                            color: esquema.primary,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(
                                atividade.meses.contains(m - 1) ? 0 : 8,
                              ),
                              right: Radius.circular(
                                atividade.meses.contains(m + 1) ? 0 : 8,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
