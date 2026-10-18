import 'package:flutter/material.dart';

import 'texto_rico.dart';

/// Card com ícone, título e texto. Se [aoTocar] for informado, o card inteiro
/// vira um link e mostra [rotuloAcao] no rodapé.
class CardInfo extends StatelessWidget {
  const CardInfo({
    super.key,
    required this.icone,
    required this.titulo,
    this.texto,
    this.aoTocar,
    this.rotuloAcao,
  });

  final IconData icone;

  /// Aceita *itálico*.
  final String titulo;
  final String? texto;
  final VoidCallback? aoTocar;
  final String? rotuloAcao;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final conteudo = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: esquema.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icone, color: esquema.onPrimaryContainer),
          ),
          const SizedBox(height: 14),
          TextoRico(
            titulo,
            estilo: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (texto != null) ...[
            const SizedBox(height: 6),
            TextoRico(
              texto!,
              estilo: tema.textTheme.bodyMedium?.copyWith(
                color: esquema.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (aoTocar != null && rotuloAcao != null) ...[
            const Spacer(),
            const SizedBox(height: 14),
            Row(
              children: [
                Flexible(
                  child: Text(
                    rotuloAcao!,
                    style: tema.textTheme.labelLarge?.copyWith(
                      color: esquema.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 18, color: esquema.primary),
              ],
            ),
          ],
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: aoTocar == null
          ? conteudo
          : Semantics(
              button: true,
              link: true,
              child: InkWell(onTap: aoTocar, child: conteudo),
            ),
    );
  }
}
