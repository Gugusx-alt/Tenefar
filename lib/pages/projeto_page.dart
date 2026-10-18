import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/grade_responsiva.dart';
import '../widgets/indice.dart';
import '../widgets/marca_texto.dart';
import '../widgets/ods_card.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final corpo = tema.textTheme.bodyLarge;

    return AppScaffold(
      titulo: 'Projeto',
      children: [
        CabecalhoPagina(
          numero: '02',
          rotulo: 'Projeto',
          titulo: InfoProjeto.titulo,
          introducao: InfoProjeto.resumo,
          extra: Text(
            InfoProjeto.palavrasChave
                .map(semMarcadores)
                .join('  /  ')
                .toUpperCase(),
            style: m.mono.copyWith(
              fontSize: 12,
              letterSpacing: 1.2,
              color: m.textoSuave,
            ),
          ),
        ),

        // ----- O problema -----
        SecaoEditorial(
          numero: '01',
          rotulo: 'O problema',
          titulo: 'Desnutrição aguda e a falta de proteína',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final p in Problema.paragrafos) ...[
                      Text(p, style: corpo),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const _Recomendacao(),
            ],
          ),
        ),

        // ----- Por que Tenebrio molitor -----
        SecaoEditorial(
          numero: '02',
          rotulo: 'Vantagens',
          titulo: 'Por que *Tenebrio molitor*?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GradeResponsiva(
                larguraMinimaItem: 300,
                maxColunas: 2,
                espaco: 40,
                espacoVertical: 0,
                children: [
                  for (var i = 0; i < vantagensTenebrio.length; i++)
                    ItemNumerado(
                      numero: i + 1,
                      texto: vantagensTenebrio[i].titulo,
                      estilo: tema.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500)
                          .fonte,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'FONTES: ${fonteVantagens.toUpperCase()}',
                style: m.mono.copyWith(fontSize: 12, color: m.textoSuave),
              ),
            ],
          ),
        ),

        // ----- Objetivos -----
        SecaoEditorial(
          numero: '03',
          rotulo: 'Objetivos',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'OBJETIVO GERAL',
                style: m.mono.copyWith(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: m.textoSuave,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 28),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: m.destaque, width: 3)),
                ),
                child: TextoRico(
                  objetivoGeral,
                  estilo: tema.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w300, height: 1.3)
                      .fonte,
                ),
              ),
              const SizedBox(height: 64),
              Text(
                'OBJETIVOS ESPECÍFICOS',
                style: m.mono.copyWith(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: m.textoSuave,
                ),
              ),
              const SizedBox(height: 12),
              GradeResponsiva(
                larguraMinimaItem: 300,
                maxColunas: 2,
                espaco: 40,
                espacoVertical: 0,
                children: [
                  for (var i = 0; i < objetivosEspecificos.length; i++)
                    ItemNumerado(numero: i + 1, texto: objetivosEspecificos[i]),
                ],
              ),
            ],
          ),
        ),

        // ----- ODS -----
        SecaoEditorial(
          numero: '04',
          rotulo: 'ODS',
          titulo: 'Objetivos de Desenvolvimento Sustentável',
          child: GradeResponsiva(
            larguraMinimaItem: 240,
            maxColunas: 3,
            espaco: 32,
            espacoVertical: 0,
            children: [for (final ods in odsProjeto) OdsCard(ods: ods)],
          ),
        ),

        // ----- Resultados -----
        SecaoEditorial(
          numero: '05',
          rotulo: 'Resultados',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusAndamento(texto: InfoProjeto.status),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  textoResultados,
                  style: tema.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w300)
                      .fonte,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A recomendação de 0,8 g/kg/dia como número grande, com marca-texto.
class _Recomendacao extends StatelessWidget {
  const _Recomendacao();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final largura = MediaQuery.sizeOf(context).width;
    final numero = MarcaTexto(
      atraso: 0.2,
      child: Text(
        '0,8 g',
        style: tema.textTheme.displayLarge
            ?.copyWith(
              fontSize: largura < 600 ? 72 : 112,
              fontWeight: FontWeight.w400,
            )
            .fonte,
      ),
    );
    final legenda = Text(
      Problema.recomendacao,
      style: tema.textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w500, height: 1.5)
          .fonte,
    );
    return Semantics(
      container: true,
      child: LayoutBuilder(
        builder: (context, r) => r.maxWidth >= 640
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  numero,
                  const SizedBox(width: 40),
                  Expanded(child: legenda),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [numero, const SizedBox(height: 16), legenda],
              ),
      ),
    );
  }
}
