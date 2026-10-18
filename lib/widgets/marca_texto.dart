import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Marca-texto ocre que "risca" a parte de baixo do texto, da esquerda para a
/// direita, quando ele aparece — como se destacasse o dado num caderno de
/// laboratório. Sem animação quando o sistema pede menos movimento.
class MarcaTexto extends StatefulWidget {
  const MarcaTexto({
    super.key,
    required this.child,
    this.atraso = 0.35,
    this.altura = 0.34,
  });

  final Widget child;

  /// Fração da animação (0–1) antes de a faixa começar a crescer.
  final double atraso;

  /// Altura da faixa em relação ao texto.
  final double altura;

  @override
  State<MarcaTexto> createState() => _MarcaTextoState();
}

class _MarcaTextoState extends State<MarcaTexto>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _progresso = CurvedAnimation(
    parent: _controle,
    curve: Interval(widget.atraso, 1, curve: Curves.easeInOutCubic),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controle.value = 1;
    } else if (_controle.isDismissed) {
      _controle.forward();
    }
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cor = context.marca.destaque;
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _progresso,
            builder: (context, _) => Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                widthFactor: _progresso.value,
                heightFactor: widget.altura,
                child: ColoredBox(
                  // No modo escuro o texto é claro: faixa mais suave.
                  color: cor.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.55
                        : 0.85,
                  ),
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
