import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Logo do TENEFAR. Os PNGs têm fundo transparente e são pintados com a cor do
/// texto atual, então funcionam no modo claro, no escuro e nos blocos escuros.
/// TROQUE AQUI os arquivos em assets/images/ se a logo mudar.
class LogoEmblema extends StatelessWidget {
  const LogoEmblema({super.key, required this.altura, this.cor});

  final double altura;
  final Color? cor;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/logo_emblema.png',
    height: altura,
    color: cor ?? context.marca.texto,
    colorBlendMode: BlendMode.srcIn,
    filterQuality: FilterQuality.medium,
    semanticLabel: 'Logo TENEFAR',
  );
}

/// Logo completa: emblema + "TENEFAR" + "Nutrição que transforma".
class LogoCompleto extends StatelessWidget {
  const LogoCompleto({super.key, required this.altura, this.cor});

  final double altura;
  final Color? cor;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/logo_completo.png',
    height: altura,
    color: cor ?? context.marca.texto,
    colorBlendMode: BlendMode.srcIn,
    filterQuality: FilterQuality.medium,
    semanticLabel: 'TENEFAR — Nutrição que transforma',
  );
}
