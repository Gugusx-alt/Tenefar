import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class ReferenciasPage extends StatelessWidget {
  const ReferenciasPage({super.key});

  Future<void> _abrir(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    return AppScaffold(
      titulo: 'Referências',
      children: [
        Secao(
          sobretitulo: 'Referências',
          titulo: 'Bibliografia do projeto',
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < referencias.length; i++) ...[
                  if (i > 0) const Divider(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${i + 1}.',
                          style: tema.textTheme.titleMedium?.copyWith(
                            color: esquema.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextoRico(
                              referencias[i].texto,
                              estilo: tema.textTheme.bodyLarge?.copyWith(
                                height: 1.55,
                              ),
                            ),
                            if (referencias[i].url != null) ...[
                              const SizedBox(height: 6),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () =>
                                    _abrir(context, referencias[i].url!),
                                icon: const Icon(Icons.open_in_new, size: 18),
                                label: const Text('Abrir link'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
