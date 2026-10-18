import 'package:go_router/go_router.dart';

import '../pages/calculadora_page.dart';
import '../pages/equipe_page.dart';
import '../pages/inicio_page.dart';
import '../pages/metodologia_page.dart';
import '../pages/nao_encontrada_page.dart';
import '../pages/projeto_page.dart';
import '../pages/referencias_page.dart';

/// Caminhos das rotas, usados na navegação e no menu.
class Rotas {
  Rotas._();

  static const inicio = '/';
  static const projeto = '/projeto';
  static const metodologia = '/metodologia';
  static const calculadora = '/calculadora';
  static const equipe = '/equipe';
  static const referencias = '/referencias';
}

/// Item do menu de navegação (barra superior e Drawer).
class ItemMenu {
  final String rota;
  final String rotulo;
  const ItemMenu(this.rota, this.rotulo);
}

const itensMenu = [
  ItemMenu(Rotas.inicio, 'Início'),
  ItemMenu(Rotas.projeto, 'O Projeto'),
  ItemMenu(Rotas.metodologia, 'Metodologia'),
  ItemMenu(Rotas.calculadora, 'Calculadora'),
  ItemMenu(Rotas.equipe, 'Equipe'),
  ItemMenu(Rotas.referencias, 'Referências'),
];

GoRouter criarRouter({String rotaInicial = Rotas.inicio}) => GoRouter(
  initialLocation: rotaInicial,
  errorBuilder: (context, state) => const NaoEncontradaPage(),
  routes: [
    GoRoute(path: Rotas.inicio, builder: (_, _) => const InicioPage()),
    GoRoute(path: Rotas.projeto, builder: (_, _) => const ProjetoPage()),
    GoRoute(
      path: Rotas.metodologia,
      builder: (_, _) => const MetodologiaPage(),
    ),
    GoRoute(
      path: Rotas.calculadora,
      builder: (_, _) => const CalculadoraPage(),
    ),
    GoRoute(path: Rotas.equipe, builder: (_, _) => const EquipePage()),
    GoRoute(
      path: Rotas.referencias,
      builder: (_, _) => const ReferenciasPage(),
    ),
  ],
);
