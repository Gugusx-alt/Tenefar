import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../data/conteudo_projeto.dart';
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
    final esquema = Theme.of(context).colorScheme;
    final largo = MediaQuery.sizeOf(context).width >= Layout.desktop;
    // Lido do GoRouter (e não de GoRouterState) para funcionar também na 404.
    final rotaAtual = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .path;

    return Title(
      title: '$titulo · ${InfoProjeto.nomeCurto}',
      color: esquema.primary,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: largo ? 24 : 0,
          title: const _Marca(),
          actions: largo
              ? [
                  for (final item in itensMenu)
                    _LinkMenu(item: item, ativo: item.rota == rotaAtual),
                  const SizedBox(width: 16),
                ]
              : null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: esquema.outlineVariant),
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

/// Logotipo textual. TROQUE AQUI por uma imagem, se houver logo oficial.
class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Semantics(
      link: true,
      label: '${InfoProjeto.nomeCurto}, ir para o início',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(Rotas.inicio),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: esquema.primary,
                child: Icon(Icons.eco, size: 18, color: esquema.onPrimary),
              ),
              const SizedBox(width: 10),
              const Text(InfoProjeto.nomeCurto),
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
    final esquema = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        selected: ativo,
        child: TextButton(
          onPressed: () => context.go(item.rota),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            backgroundColor: ativo ? esquema.secondaryContainer : null,
            foregroundColor: ativo
                ? esquema.onSecondaryContainer
                : esquema.onSurface,
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: ativo ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          child: Text(item.rotulo),
        ),
      ),
    );
  }
}

class _MenuLateral extends StatelessWidget {
  const _MenuLateral({required this.rotaAtual});

  final String rotaAtual;

  static const _icones = {
    Rotas.inicio: Icons.home_outlined,
    Rotas.projeto: Icons.lightbulb_outline,
    Rotas.metodologia: Icons.timeline,
    Rotas.calculadora: Icons.calculate_outlined,
    Rotas.equipe: Icons.groups_outlined,
    Rotas.referencias: Icons.menu_book_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final indice = itensMenu.indexWhere((i) => i.rota == rotaAtual);
    return NavigationDrawer(
      selectedIndex: indice < 0 ? null : indice,
      onDestinationSelected: (i) {
        Navigator.of(context).pop();
        context.go(itensMenu[i].rota);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Text(
            InfoProjeto.nomeCurto,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        for (final item in itensMenu)
          NavigationDrawerDestination(
            icon: Icon(_icones[item.rota]),
            label: Text(item.rotulo),
          ),
      ],
    );
  }
}

class _Rodape extends StatelessWidget {
  const _Rodape();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final estiloTitulo = tema.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: esquema.onSurface,
    );
    final estiloTexto = tema.textTheme.bodyMedium?.copyWith(
      color: esquema.onSurfaceVariant,
    );

    return Container(
      color: esquema.surfaceContainerHighest,
      child: Secao(
        espacoVertical: 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 48,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(InfoProjeto.nomeCurto, style: estiloTitulo),
                      const SizedBox(height: 4),
                      Text(InfoProjeto.slogan, style: estiloTexto),
                      const SizedBox(height: 8),
                      Text(
                        'UTFPR · PIBIC · ${DateTime.now().year}',
                        style: estiloTexto,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contato', style: estiloTitulo),
                      const SizedBox(height: 4),
                      Text(Equipe.email, style: estiloTexto),
                      Text(Equipe.campus, style: estiloTexto),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Links rápidos', style: estiloTitulo),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: [
                        for (final item in itensMenu.skip(1))
                          TextButton(
                            onPressed: () => context.go(item.rota),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            child: Text(item.rotulo),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Projeto de Iniciação Científica · ${InfoProjeto.instituicao}',
              style: tema.textTheme.bodySmall?.copyWith(
                color: esquema.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
