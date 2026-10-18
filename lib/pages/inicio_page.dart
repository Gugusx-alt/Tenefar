import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/card_info.dart';
import '../widgets/grade_responsiva.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    return AppScaffold(
      titulo: 'Início',
      children: [
        // ----- Hero -----
        Secao(
          espacoVertical: 64,
          decoracao: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                esquema.primaryContainer.withValues(alpha: 0.55),
                esquema.surface,
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, restricoes) {
              const ilustracao = _IlustracaoHero();
              if (restricoes.maxWidth >= 820) {
                return const Row(
                  children: [
                    Expanded(child: _TextoHero()),
                    SizedBox(width: 40),
                    ilustracao,
                  ],
                );
              }
              return const _TextoHero();
            },
          ),
        ),

        // ----- Resumo -----
        Secao(
          sobretitulo: 'Sobre o projeto',
          titulo: 'Proteína acessível a partir da larva-da-farinha',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextoRico(
                InfoProjeto.resumoCurto,
                estilo: tema.textTheme.titleMedium?.copyWith(
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              _LinhaInfo(
                icone: Icons.account_balance_outlined,
                texto: InfoProjeto.instituicao,
              ),
              _LinhaInfo(
                icone: Icons.school_outlined,
                texto: InfoProjeto.programa,
              ),
              _LinhaInfo(
                icone: Icons.category_outlined,
                texto: InfoProjeto.area,
              ),
            ],
          ),
        ),

        // ----- Destaques -----
        Secao(
          espacoVertical: 16,
          child: GradeResponsiva(
            larguraMinimaItem: 230,
            children: [
              CardInfo(
                icone: Icons.lightbulb_outline,
                titulo: 'O Projeto',
                texto:
                    'O problema da desnutrição aguda, os objetivos e os ODS '
                    'ligados à pesquisa.',
                rotuloAcao: 'Ver o projeto',
                aoTocar: () => context.go(Rotas.projeto),
              ),
              CardInfo(
                icone: Icons.timeline,
                titulo: 'Metodologia',
                texto:
                    'Da criação das larvas às análises do pó, com o '
                    'cronograma de 12 meses.',
                rotuloAcao: 'Ver as etapas',
                aoTocar: () => context.go(Rotas.metodologia),
              ),
              CardInfo(
                icone: Icons.calculate_outlined,
                titulo: 'Calculadora',
                texto:
                    'Compare a proteína de um alimento com a da farinha de '
                    '*Tenebrio molitor*.',
                rotuloAcao: 'Calcular',
                aoTocar: () => context.go(Rotas.calculadora),
              ),
              CardInfo(
                icone: Icons.menu_book_outlined,
                titulo: 'Referências',
                texto: 'Os estudos que fundamentam o projeto.',
                rotuloAcao: 'Ver referências',
                aoTocar: () => context.go(Rotas.referencias),
              ),
            ],
          ),
        ),

        // ----- Chamada para a calculadora -----
        Secao(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: esquema.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quanto de farinha tem a proteína do seu prato?',
                        style: tema.textTheme.headlineSmall?.copyWith(
                          color: esquema.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Escolha um alimento, informe a quantidade e veja a '
                        'equivalência em gramas e colheres de sopa.',
                        style: tema.textTheme.bodyLarge?.copyWith(
                          color: esquema.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: esquema.onPrimary,
                    foregroundColor: esquema.primary,
                  ),
                  onPressed: () => context.go(Rotas.calculadora),
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Usar a calculadora'),
                ),
              ],
            ),
          ),
        ),

        // ----- Status -----
        Secao(
          espacoVertical: 24,
          decoracao: BoxDecoration(
            color: esquema.tertiaryContainer.withValues(alpha: 0.4),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const SeloStatus(InfoProjeto.status),
              Text(
                'Status: em andamento. Os resultados serão publicados ao final '
                'das análises.',
                style: tema.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextoHero extends StatelessWidget {
  const _TextoHero();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estreito = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INICIAÇÃO CIENTÍFICA · UTFPR',
          style: tema.textTheme.labelLarge?.copyWith(
            color: tema.colorScheme.secondary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: TextoRico(
            InfoProjeto.titulo,
            estilo:
                (estreito
                        ? tema.textTheme.headlineSmall
                        : tema.textTheme.headlineLarge)
                    ?.copyWith(height: 1.2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          InfoProjeto.fraseImpacto,
          style: tema.textTheme.titleMedium?.copyWith(
            color: tema.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final palavra in InfoProjeto.palavrasChave)
              Chip(
                avatar: const Icon(Icons.tag, size: 18),
                label: TextoRico(palavra),
              ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => context.go(Rotas.projeto),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Conheça o projeto'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.go(Rotas.calculadora),
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('Usar a calculadora'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Ilustração simples feita com ícones (sem fotos de insetos).
/// TROQUE AQUI por uma imagem em assets/images/, se quiser.
class _IlustracaoHero extends StatelessWidget {
  const _IlustracaoHero();

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    Widget satelite(IconData icone, Color fundo, Color frente) => Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: fundo,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icone, color: frente, size: 34),
    );

    return ExcludeSemantics(
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: esquema.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: esquema.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.eco, size: 80, color: esquema.onPrimary),
            ),
            Positioned(
              top: 8,
              right: 28,
              child: satelite(
                Icons.science_outlined,
                esquema.secondary,
                esquema.onSecondary,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 12,
              child: satelite(
                Icons.restaurant_outlined,
                esquema.tertiaryContainer,
                esquema.onTertiaryContainer,
              ),
            ),
            Positioned(
              bottom: 28,
              right: 6,
              child: satelite(Icons.public, esquema.surface, esquema.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: tema.colorScheme.secondary),
          const SizedBox(width: 10),
          Expanded(child: Text(texto, style: tema.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
