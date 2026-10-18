import 'package:flutter/material.dart';

/// Fade + leve deslocamento vertical na primeira exibição.
/// Desativado quando o sistema pede para reduzir animações.
class EntradaAnimada extends StatelessWidget {
  const EntradaAnimada({
    super.key,
    required this.child,
    this.duracao = const Duration(milliseconds: 450),
  });

  final Widget child;
  final Duration duracao;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duracao,
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, valor, child) => Opacity(
        opacity: valor,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - valor)),
          child: child,
        ),
      ),
    );
  }
}
