import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/grade_responsiva.dart';
import '../widgets/secao.dart';

/// Os nomes e contatos vêm de `Equipe` em lib/data/conteudo_projeto.dart.
class EquipePage extends StatelessWidget {
  const EquipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return AppScaffold(
      titulo: 'Equipe',
      children: [
        Secao(
          sobretitulo: 'Equipe',
          titulo: 'Quem faz o projeto',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${InfoProjeto.instituicao} · ${InfoProjeto.programa}',
                style: tema.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const GradeResponsiva(
                larguraMinimaItem: 300,
                maxColunas: 3,
                children: [
                  _CardPessoa(
                    icone: Icons.person_outline,
                    papel: 'Estudante de Iniciação Científica',
                    nome: Equipe.estudante,
                  ),
                  _CardPessoa(
                    icone: Icons.school_outlined,
                    papel: 'Orientação',
                    nome: Equipe.orientador,
                  ),
                  _CardPessoa(
                    icone: Icons.location_city_outlined,
                    papel: 'Câmpus',
                    nome: Equipe.campus,
                  ),
                  _CardPessoa(
                    icone: Icons.groups_outlined,
                    papel: 'Grupo de pesquisa',
                    nome: Equipe.grupoPesquisa,
                  ),
                  _CardPessoa(
                    icone: Icons.mail_outline,
                    papel: 'Contato',
                    nome: Equipe.email,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardPessoa extends StatelessWidget {
  const _CardPessoa({
    required this.icone,
    required this.papel,
    required this.nome,
  });

  final IconData icone;
  final String papel;
  final String nome;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: esquema.primaryContainer,
              child: Icon(icone, color: esquema.onPrimaryContainer, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    papel,
                    style: tema.textTheme.labelLarge?.copyWith(
                      color: esquema.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    nome,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
