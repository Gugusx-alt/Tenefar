import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import 'interacao.dart';
import 'logo.dart';
import 'secao.dart';

/// Layout comum a todas as páginas: barra superior (links em linha em telas
/// largas, Drawer em telas estreitas), conteúdo rolável e rodapé.
///
/// [children] são faixas de largura total (normalmente [Secao]s).
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.titulo, required this.children});

  /// Título da aba do navegador (o nome do projeto é acrescentado).
  final String titulo;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final largo = Layout.largo(context);
    final largura = MediaQuery.sizeOf(context).width;
    // Lido do GoRouter (e não de GoRouterState) para funcionar também na 404.
    final rotaAtual = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .path;

    return Title(
      title: '$titulo · ${InfoProjeto.nomeCurto}',
      color: Cores.tinta,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: largo ? Layout.margem(largura) : 4,
          // FittedBox: se o menu ocupar quase toda a barra, a marca encolhe
          // em vez de estourar.
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: _Marca(),
          ),
          actions: largo
              ? [
                  for (final item in itensMenu)
                    _LinkMenu(item: item, ativo: item.rota == rotaAtual),
                  SizedBox(width: Layout.margem(largura) - 12),
                ]
              : null,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(),
          ),
        ),
        drawer: largo ? null : _MenuLateral(rotaAtual: rotaAtual),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [...children, const _Rodape()],
          ),
        ),
      ),
    );
  }
}

class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Interativo(
      aoTocar: () => context.go(Rotas.inicio),
      rotuloSemantico: '${InfoProjeto.nomeCurto}, ir para o início',
      builder: (context, ativo) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                // O emblema "acena" de leve no hover.
                turns: ativo ? -0.02 : 0,
                duration: duracaoMicro(context, 300),
                curve: Curves.easeOutBack,
                child: const LogoEmblema(altura: 34),
              ),
              const SizedBox(width: 12),
              Text(
                InfoProjeto.nomeCurto,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: m.texto,
                    )
                    .fonte,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkMenu extends StatelessWidget {
  const _LinkMenu({required this.item, required this.ativo});

  final ItemMenu item;
  final bool ativo;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Semantics(
      selected: ativo,
      child: Interativo(
        aoTocar: () => context.go(item.rota),
        builder: (context, hover) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.rotulo,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(
                      fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                      color: ativo || hover ? m.texto : m.textoSuave,
                    )
                    .fonte,
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: duracaoMicro(context),
                curve: Curves.easeOutCubic,
                height: 2,
                width: ativo ? 20 : (hover ? 12 : 0),
                color: ativo ? m.destaque : m.texto,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuLateral extends StatelessWidget {
  const _MenuLateral({required this.rotaAtual});

  final String rotaAtual;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 24, 20, 24),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: LogoEmblema(altura: 48),
            ),
            const SizedBox(height: 36),
            for (var i = 0; i < itensMenu.length; i++)
              Semantics(
                selected: itensMenu[i].rota == rotaAtual,
                child: Interativo(
                  aoTocar: () {
                    Navigator.of(context).pop();
                    context.go(itensMenu[i].rota);
                  },
                  builder: (context, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: m.mono.copyWith(
                              fontSize: 12,
                              color: m.textoSuave,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            itensMenu[i].rotulo,
                            style: tema.textTheme.headlineSmall
                                ?.copyWith(
                                  fontStyle: itensMenu[i].rota == rotaAtual
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                )
                                .fonte,
                          ),
                        ),
                        if (itensMenu[i].rota == rotaAtual)
                          Container(width: 8, height: 8, color: m.destaque),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Rodape extends StatelessWidget {
  const _Rodape();

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final tema = Theme.of(context);
    final rotulo = m.mono.copyWith(
      fontSize: 12,
      letterSpacing: 1.2,
      color: m.textoSuave,
    );
    final texto = tema.textTheme.bodyMedium?.copyWith(color: m.textoSuave);

    final navegacao = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NAVEGAR', style: rotulo),
        const SizedBox(height: 12),
        for (final item in itensMenu)
          LinkSeta(
            rotulo: item.rotulo,
            aoTocar: () => context.go(item.rota),
            estilo: tema.textTheme.bodyLarge,
          ),
      ],
    );

    final projeto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROJETO', style: rotulo),
        const SizedBox(height: 12),
        Text(InfoProjeto.instituicao, style: texto),
        const SizedBox(height: 6),
        Text('Programa de Iniciação Científica (PIBIC)', style: texto),
        const SizedBox(height: 20),
        Text('CONTATO', style: rotulo),
        const SizedBox(height: 12),
        SelectableText(Contato.email, style: texto),
      ],
    );

    return Secao(
      espacoVertical: 72,
      animar: false,
      child: LayoutBuilder(
        builder: (context, restricoes) {
          final largo = restricoes.maxWidth >= 860;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(),
              const SizedBox(height: 48),
              if (largo)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LogoCompleto(altura: 150),
                      ),
                    ),
                    Expanded(flex: 3, child: navegacao),
                    Expanded(flex: 4, child: projeto),
                  ],
                )
              else ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: LogoCompleto(altura: 120),
                ),
                const SizedBox(height: 40),
                navegacao,
                const SizedBox(height: 32),
                projeto,
              ],
              const SizedBox(height: 56),
              Text(
                '${InfoProjeto.nomeCurto} · ${InfoProjeto.siglaInstituicao} · '
                'PIBIC · ${DateTime.now().year}',
                style: rotulo,
              ),
            ],
          );
        },
      ),
    );
  }
}
