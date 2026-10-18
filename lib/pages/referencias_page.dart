import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/interacao.dart';
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
    final m = context.marca;

    return AppScaffold(
      titulo: 'Referências',
      children: [
        const CabecalhoPagina(
          numero: '05',
          rotulo: 'Referências',
          titulo: 'Bibliografia',
        ),
        SecaoEditorial(
          rotulo: '${referencias.length} obras',
          espacoVertical: 24,
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < referencias.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      border: i == 0
                          ? null
                          : Border(top: BorderSide(color: m.linha)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 52,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '[${i + 1}]',
                              style: m.mono.copyWith(
                                fontSize: 13,
                                color: m.textoSuave,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextoRico(
                                referencias[i].texto,
                                estilo: tema.textTheme.bodyLarge,
                              ),
                              if (referencias[i].url != null)
                                LinkSeta(
                                  rotulo: 'Abrir link',
                                  icone: Icons.north_east,
                                  aoTocar: () =>
                                      _abrir(context, referencias[i].url!),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 72),
      ],
    );
  }
}
