import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/interacao.dart';
import '../widgets/secao.dart';

/// Página 404.
class NaoEncontradaPage extends StatelessWidget {
  const NaoEncontradaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titulo: 'Página não encontrada',
      children: [
        const CabecalhoPagina(
          numero: '404',
          rotulo: 'Página não encontrada',
          titulo: 'Esta página *não existe*.',
          introducao: 'O endereço pode ter mudado ou estar incorreto.',
        ),
        Secao(
          espacoVertical: 0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: LinkSeta(
                rotulo: 'Voltar ao início',
                aoTocar: () => context.go(Rotas.inicio),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
