import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Quebra [texto] em spans, colocando em itálico os trechos entre asteriscos.
///
/// `'O *Tenebrio molitor* é...'` → "O " + itálico("Tenebrio molitor") + " é...".
List<InlineSpan> spansComItalico(String texto, {TextStyle? estilo}) {
  final partes = texto.split('*');
  return [
    for (var i = 0; i < partes.length; i++)
      if (partes[i].isNotEmpty)
        TextSpan(
          text: partes[i],
          style: i.isOdd
              ? (estilo ?? const TextStyle())
                    .copyWith(fontStyle: FontStyle.italic)
                    .fonte
              : estilo,
        ),
  ];
}

/// Remove os marcadores de itálico, para rótulos de acessibilidade.
String semMarcadores(String texto) => texto.replaceAll('*', '');

/// Texto que aceita trechos em itálico marcados com *asteriscos*.
/// Use sempre que houver nomes científicos (ex.: *Tenebrio molitor*).
class TextoRico extends StatelessWidget {
  const TextoRico(
    this.texto, {
    super.key,
    this.estilo,
    this.alinhamento,
    this.maxLinhas,
  });

  final String texto;
  final TextStyle? estilo;
  final TextAlign? alinhamento;
  final int? maxLinhas;

  @override
  Widget build(BuildContext context) {
    // Estilo completo (herdado + local) para que o itálico carregue a
    // variante itálica real da fonte.
    final base = DefaultTextStyle.of(context).style.merge(estilo).fonte;
    return Text.rich(
      TextSpan(children: spansComItalico(texto, estilo: base)),
      style: base,
      textAlign: alinhamento,
      maxLines: maxLinhas,
      overflow: maxLinhas == null ? null : TextOverflow.ellipsis,
    );
  }
}
