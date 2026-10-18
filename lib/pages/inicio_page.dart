import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/config.dart';
import '../app/router.dart';
import '../app/theme.dart';
import '../data/alimentos.dart';
import '../data/conteudo_projeto.dart';
import '../logic/calculadora.dart';
import '../logic/formatacao.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/indice.dart';
import '../widgets/interacao.dart';
import '../widgets/logo.dart';
import '../widgets/marca_texto.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titulo: 'Início',
      children: [
        const Secao(espacoVertical: 72, child: _Abertura()),
        SecaoEditorial(
          numero: '01',
          rotulo: 'Resumo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextoRico(
                InfoProjeto.resumoCurto,
                estilo: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w300)
                    .fonte,
              ),
              const SizedBox(height: 48),
              ListaDefinicoes(
                itens: [
                  ('Instituição', InfoProjeto.instituicao),
                  ('Programa', InfoProjeto.programa),
                  ('Área', InfoProjeto.area),
                  ('Palavras-chave', InfoProjeto.palavrasChave.join(' · ')),
                ],
              ),
            ],
          ),
        ),
        SecaoEditorial(
          numero: '02',
          rotulo: 'Explorar',
          espacoVertical: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(),
              LinhaIndice(
                numero: '02',
                titulo: 'Projeto',
                descricao:
                    'O problema da desnutrição aguda, os objetivos e os '
                    'ODS ligados à pesquisa.',
                aoTocar: () => context.go(Rotas.projeto),
              ),
              LinhaIndice(
                numero: '03',
                titulo: 'Metodologia',
                descricao:
                    'Da criação das larvas às análises do pó, com o '
                    'cronograma de 12 meses.',
                aoTocar: () => context.go(Rotas.metodologia),
              ),
              LinhaIndice(
                numero: '04',
                titulo: 'Calculadora',
                descricao:
                    'Compare a proteína de um alimento com a da farinha '
                    'de *Tenebrio molitor*.',
                aoTocar: () => context.go(Rotas.calculadora),
              ),
              LinhaIndice(
                numero: '05',
                titulo: 'Referências',
                descricao: 'Os estudos que fundamentam o projeto.',
                aoTocar: () => context.go(Rotas.referencias),
              ),
            ],
          ),
        ),
        const Secao(escuro: true, child: _ChamadaCalculadora()),
      ],
    );
  }
}

/// Abertura da página: tipografia grande, logo deslocada e status.
class _Abertura extends StatelessWidget {
  const _Abertura();

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    final largura = MediaQuery.sizeOf(context).width;
    final tamanho = largura < 600 ? 52.0 : (largura < 1100 ? 76.0 : 104.0);
    final display = tema.textTheme.displayLarge?.copyWith(
      fontSize: tamanho,
      letterSpacing: -tamanho * 0.028,
    );
    final meta = m.mono.copyWith(
      fontSize: 12.5,
      letterSpacing: 1.3,
      color: m.textoSuave,
    );

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          label: InfoProjeto.slogan,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nutrição que', style: display),
              MarcaTexto(
                child: Text(
                  'transforma.',
                  style: display
                      ?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      )
                      .fonte,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: largura < 600 ? 36 : 56),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PESQUISA', style: meta),
              const SizedBox(height: 10),
              TextoRico(
                InfoProjeto.titulo,
                estilo: tema.textTheme.bodyLarge?.copyWith(
                  fontSize: 19,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 28,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  BotaoSeta(
                    rotulo: 'Conheça o projeto',
                    aoTocar: () => context.go(Rotas.projeto),
                  ),
                  LinkSeta(
                    rotulo: 'Usar a calculadora',
                    aoTocar: () => context.go(Rotas.calculadora),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, r) {
        final largo = r.maxWidth >= 860;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 24,
              runSpacing: 6,
              children: [
                Text(
                  'PIBIC · ${InfoProjeto.siglaInstituicao.toUpperCase()}',
                  style: meta,
                ),
                Text('CIÊNCIA E TECNOLOGIA DE ALIMENTOS', style: meta),
              ],
            ),
            SizedBox(height: largo ? 64 : 40),
            if (largo)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: texto),
                  // Logo deslocada para baixo: quebra o alinhamento de propósito.
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: LogoEmblema(
                          altura: r.maxWidth >= 1000 ? 280 : 210,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              const Align(
                alignment: Alignment.centerRight,
                child: LogoEmblema(altura: 96),
              ),
              const SizedBox(height: 24),
              texto,
            ],
            SizedBox(height: largo ? 88 : 56),
            const Divider(),
            const SizedBox(height: 20),
            const StatusAndamento(
              texto: InfoProjeto.status,
              detalhe: 'Resultados serão publicados ao final das análises.',
            ),
          ],
        );
      },
    );
  }
}

/// Bloco escuro com um exemplo real calculado pela própria calculadora.
class _ChamadaCalculadora extends StatelessWidget {
  const _ChamadaCalculadora();

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    final exemplo = alimentos.firstWhere(
      (a) => a.id == 'frango-peito-grelhado',
    );
    const gramas = 100.0;
    final proteina = proteinaDoAlimento(gramas, exemplo.proteinaPor100g);
    final farinha = farinhaNecessaria(proteina);
    final mono = m.mono.copyWith(fontSize: 13, color: m.textoSuave);

    final chamada = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RotuloSecao(numero: '04', texto: 'Calculadora'),
        const SizedBox(height: 28),
        Text(
          'Quanto de farinha tem a proteína do seu prato?',
          style: tema.textTheme.displaySmall,
        ),
        const SizedBox(height: 20),
        Text(
          'Escolha um alimento, informe a quantidade e veja a equivalência em '
          'gramas e colheres de sopa.',
          style: tema.textTheme.bodyLarge?.copyWith(color: m.textoSuave),
        ),
        const SizedBox(height: 32),
        BotaoSeta(
          rotulo: 'Fazer meu cálculo',
          aoTocar: () => context.go(Rotas.calculadora),
        ),
      ],
    );

    final equacao = Semantics(
      label:
          'Exemplo: ${formatarGramas(gramas)} de ${exemplo.nome} têm '
          '${formatarGramas(proteina)} de proteína, o mesmo que cerca de '
          '${formatarGramas(farinha)} de farinha de Tenebrio molitor.',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.only(left: 28),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: m.destaque, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXEMPLO', style: mono.copyWith(letterSpacing: 1.3)),
            const SizedBox(height: 16),
            Text(
              '${formatarCompacto(gramas)} g · ${exemplo.nome}',
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('= ${formatarGramas(proteina)} de proteína', style: mono),
            const SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '≈ ${formatarGramas(farinha)}',
                style: tema.textTheme.displayMedium
                    ?.copyWith(color: m.destaque, fontWeight: FontWeight.w400)
                    .fonte,
              ),
            ),
            TextoRico(
              'de farinha de *Tenebrio molitor*',
              estilo: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Teor provisório da farinha: '
              '${formatarCompacto(Config.proteinaFarinhaPor100g)} g/100 g',
              style: mono.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, r) => r.maxWidth >= 860
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 6, child: chamada),
                const SizedBox(width: 72),
                Expanded(flex: 4, child: equacao),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [chamada, const SizedBox(height: 48), equacao],
            ),
    );
  }
}
