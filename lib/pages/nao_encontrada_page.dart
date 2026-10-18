import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/secao.dart';

/// Página 404.
class NaoEncontradaPage extends StatelessWidget {
  const NaoEncontradaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return AppScaffold(
      titulo: 'Página não encontrada',
      children: [
        Secao(
          espacoVertical: 96,
          child: Column(
            children: [
              Icon(
                Icons.travel_explore,
                size: 72,
                color: tema.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Página não encontrada',
                textAlign: TextAlign.center,
                style: tema.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'O endereço pode ter mudado ou estar incorreto.',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go(Rotas.inicio),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
