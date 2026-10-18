import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/card_info.dart';
import '../widgets/grade_responsiva.dart';
import '../widgets/ods_card.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final corpo = tema.textTheme.bodyLarge?.copyWith(height: 1.6);

    return AppScaffold(
      titulo: 'O Projeto',
      children: [
        // ----- Cabeçalho -----
        Secao(
          sobretitulo: 'O Projeto',
          decoracao: BoxDecoration(
            color: esquema.primaryContainer.withValues(alpha: 0.35),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: TextoRico(
                  InfoProjeto.titulo,
                  estilo: tema.textTheme.headlineSmall?.copyWith(height: 1.25),
                ),
              ),
              const SizedBox(height: 16),
              TextoRico(InfoProjeto.resumo, estilo: corpo),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final palavra in InfoProjeto.palavrasChave)
                    Chip(label: TextoRico(palavra)),
                ],
              ),
            ],
          ),
        ),

        // ----- O problema -----
        Secao(
          titulo: 'O problema',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final p in Problema.paragrafos) ...[
                Text(p, style: corpo),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: esquema.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.monitor_weight_outlined,
                      size: 36,
                      color: esquema.onSecondaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        Problema.recomendacao,
                        style: tema.textTheme.titleMedium?.copyWith(
                          color: esquema.onSecondaryContainer,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ----- Por que Tenebrio molitor -----
        Secao(
          titulo: 'Por que *Tenebrio molitor*?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GradeResponsiva(
                larguraMinimaItem: 220,
                children: [
                  for (final v in vantagensTenebrio)
                    CardInfo(icone: v.icone, titulo: v.titulo),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Fontes: $fonteVantagens',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // ----- Objetivos -----
        Secao(
          titulo: 'Objetivos',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: esquema.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OBJETIVO GERAL',
                      style: tema.textTheme.labelLarge?.copyWith(
                        color: esquema.onPrimary.withValues(alpha: 0.85),
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextoRico(
                      objetivoGeral,
                      estilo: tema.textTheme.titleLarge?.copyWith(
                        color: esquema.onPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Objetivos específicos', style: tema.textTheme.titleLarge),
              const SizedBox(height: 16),
              GradeResponsiva(
                larguraMinimaItem: 300,
                maxColunas: 2,
                espaco: 12,
                children: [
                  for (var i = 0; i < objetivosEspecificos.length; i++)
                    _ObjetivoItem(
                      numero: i + 1,
                      texto: objetivosEspecificos[i],
                    ),
                ],
              ),
            ],
          ),
        ),

        // ----- ODS -----
        Secao(
          titulo: 'Objetivos de Desenvolvimento Sustentável',
          child: GradeResponsiva(
            larguraMinimaItem: 180,
            maxColunas: 5,
            children: [for (final ods in odsProjeto) OdsCard(ods: ods)],
          ),
        ),

        // ----- Resultados -----
        Secao(
          titulo: 'Resultados',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SeloStatus(InfoProjeto.status),
                  const SizedBox(height: 14),
                  Text(textoResultados, style: corpo),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ObjetivoItem extends StatelessWidget {
  const _ObjetivoItem({required this.numero, required this.texto});

  final int numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: esquema.secondaryContainer,
              child: Text(
                '$numero',
                style: TextStyle(
                  color: esquema.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextoRico(
                texto,
                estilo: tema.textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
