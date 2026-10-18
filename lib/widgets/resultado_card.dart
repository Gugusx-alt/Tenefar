import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/conteudo_projeto.dart';
import '../logic/formatacao.dart';
import '../state/calculadora_controller.dart';
import 'texto_rico.dart';

/// Resultado da substituição, atualizado enquanto a pessoa digita.
class ResultadoCard extends StatelessWidget {
  const ResultadoCard({super.key, required this.resultado});

  final ResultadoSubstituicao? resultado;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final r = resultado;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: esquema.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: esquema.primary.withValues(alpha: 0.25)),
      ),
      child: r == null
          ? const _Vazio()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  liveRegion: true,
                  container: true,
                  label:
                      'Resultado: ${formatarGramas(r.gramasAlimento, r.alimento.simboloUnidade)} '
                      'de ${r.alimento.nome} contêm ${formatarGramas(r.proteina)} de proteína. '
                      'Farinha de Tenebrio necessária: ${formatarGramas(r.farinha)}, '
                      'cerca de ${_colheres(r.colheres)}.',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Linha(
                        rotulo: 'Proteína contida no alimento',
                        valor: formatarGramas(r.proteina),
                      ),
                      const Divider(height: 28),
                      TextoRico(
                        'Farinha de *Tenebrio* necessária',
                        estilo: tema.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _NumeroAnimado(texto: formatarGramas(r.farinha)),
                      Text(
                        '≈ ${_colheres(r.colheres)}',
                        style: tema.textTheme.titleMedium?.copyWith(
                          color: esquema.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BarraComparacao(
                  rotulo: r.alimento.nome,
                  valor: r.gramasAlimento,
                  maximo: math.max(r.gramasAlimento, r.farinha),
                  texto: formatarGramas(
                    r.gramasAlimento,
                    r.alimento.simboloUnidade,
                  ),
                  cor: esquema.secondary,
                ),
                const SizedBox(height: 12),
                BarraComparacao(
                  rotulo: 'Farinha de *Tenebrio molitor*',
                  valor: r.farinha,
                  maximo: math.max(r.gramasAlimento, r.farinha),
                  texto: formatarGramas(r.farinha),
                  cor: esquema.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  '${r.alimento.nome}: ${formatarNumero(r.alimento.proteinaPor100g)} g '
                  'de proteína por 100 ${r.alimento.simboloUnidade}',
                  style: tema.textTheme.bodyMedium,
                ),
                Text(
                  TextosCalculadora.fonteTabela,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: esquema.onSurfaceVariant,
                  ),
                ),
                if (r.alimento.proteinaPor100g < 2) ...[
                  const SizedBox(height: 16),
                  _Observacao(texto: TextosCalculadora.pobreEmProteina),
                ],
              ],
            ),
    );
  }

  static String _colheres(double n) {
    final texto = formatarNumero(n);
    return '$texto ${texto == '1,0' ? 'colher' : 'colheres'} de sopa';
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        Icon(
          Icons.calculate_outlined,
          size: 48,
          color: tema.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Escolha um alimento e informe a quantidade para ver quanto de '
          'farinha fornece a mesma proteína.',
          textAlign: TextAlign.center,
          style: tema.textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Linha extends StatelessWidget {
  const _Linha({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(child: Text(rotulo, style: tema.textTheme.bodyLarge)),
        const SizedBox(width: 12),
        Text(
          valor,
          style: tema.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Número grande com transição suave quando o valor muda.
class _NumeroAnimado extends StatelessWidget {
  const _NumeroAnimado({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final semAnimacao = MediaQuery.disableAnimationsOf(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: semAnimacao
            ? Duration.zero
            : const Duration(milliseconds: 250),
        transitionBuilder: (child, animacao) => FadeTransition(
          opacity: animacao,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(animacao),
            child: child,
          ),
        ),
        child: FittedBox(
          key: ValueKey(texto),
          fit: BoxFit.scaleDown,
          child: Text(
            texto,
            style: tema.textTheme.displaySmall?.copyWith(
              color: tema.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra horizontal simples para comparar massas (sem biblioteca de gráficos).
class BarraComparacao extends StatelessWidget {
  const BarraComparacao({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.maximo,
    required this.texto,
    required this.cor,
  });

  /// Aceita *itálico*.
  final String rotulo;
  final double valor;
  final double maximo;
  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final fracao = maximo <= 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);
    final semAnimacao = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextoRico(
                rotulo,
                estilo: tema.textTheme.bodyMedium,
                maxLinhas: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              texto,
              style: tema.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 14,
            color: tema.colorScheme.surfaceContainerHighest,
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: fracao),
              duration: semAnimacao
                  ? Duration.zero
                  : const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, f, _) => FractionallySizedBox(
                widthFactor: valor > 0 ? math.max(f, 0.01) : 0,
                heightFactor: 1,
                child: ColoredBox(color: cor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Observacao extends StatelessWidget {
  const _Observacao({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tema.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: tema.colorScheme.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
