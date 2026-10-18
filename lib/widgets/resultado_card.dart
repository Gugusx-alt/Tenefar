import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import '../logic/formatacao.dart';
import '../state/calculadora_controller.dart';
import 'secao.dart';
import 'texto_rico.dart';

/// Painel escuro (tinta) onde ficam os resultados da calculadora.
class PainelResultado extends StatelessWidget {
  const PainelResultado({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: m.blocoFundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: temaBloco(context),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: m.blocoTexto),
          child: child,
        ),
      ),
    );
  }
}

/// Valor que "conta" do número anterior até o novo — a pessoa vê a farinha
/// crescer ou diminuir conforme digita.
class NumeroContado extends StatelessWidget {
  const NumeroContado({
    super.key,
    required this.valor,
    required this.formatar,
    this.estilo,
  });

  final double valor;
  final String Function(double) formatar;
  final TextStyle? estilo;

  @override
  Widget build(BuildContext context) {
    final semAnimacao = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: valor),
      duration: semAnimacao ? Duration.zero : const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(formatar(v), style: estilo),
    );
  }
}

/// Rótulo mono pequeno usado dentro dos painéis.
class RotuloMono extends StatelessWidget {
  const RotuloMono(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Text(
      texto.toUpperCase(),
      style: m.mono.copyWith(
        fontSize: 12,
        letterSpacing: 1.2,
        color: m.textoSuave,
      ),
    );
  }
}

/// Resultado da substituição, atualizado enquanto a pessoa digita.
class ResultadoCard extends StatelessWidget {
  const ResultadoCard({super.key, required this.resultado});

  final ResultadoSubstituicao? resultado;

  @override
  Widget build(BuildContext context) {
    final r = resultado;
    return PainelResultado(
      child: r == null ? const _Vazio() : _Preenchido(r: r),
    );
  }

  static String colheres(double n) {
    final texto = formatarNumero(n);
    return '$texto ${texto == '1,0' ? 'colher' : 'colheres'} de sopa';
  }
}

class _Preenchido extends StatelessWidget {
  const _Preenchido({required this.r});

  final ResultadoSubstituicao r;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final simbolo = r.alimento.simboloUnidade;
    final maximo = math.max(r.gramasAlimento, r.farinha);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          container: true,
          label:
              'Resultado: ${formatarGramas(r.gramasAlimento, simbolo)} '
              'de ${r.alimento.nome} contêm ${formatarGramas(r.proteina)} de '
              'proteína. Farinha de Tenebrio necessária: '
              '${formatarGramas(r.farinha)}, cerca de '
              '${ResultadoCard.colheres(r.colheres)}.',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RotuloMono('Proteína contida no alimento'),
              const SizedBox(height: 4),
              NumeroContado(
                valor: r.proteina,
                formatar: formatarGramas,
                estilo: m.mono
                    .copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: m.texto,
                    )
                    .fonte,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              TextoRico(
                'Farinha de *Tenebrio* necessária',
                estilo: tema.textTheme.titleMedium,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: NumeroContado(
                  valor: r.farinha,
                  formatar: formatarGramas,
                  estilo: tema.textTheme.displayMedium
                      ?.copyWith(color: m.destaque, fontWeight: FontWeight.w400)
                      .fonte,
                ),
              ),
              Text(
                '≈ ${ResultadoCard.colheres(r.colheres)}',
                style: m.mono.copyWith(fontSize: 14, color: m.textoSuave),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        BarraComparacao(
          rotulo: r.alimento.nome,
          valor: r.gramasAlimento,
          maximo: maximo,
          texto: formatarGramas(r.gramasAlimento, simbolo),
          cor: m.texto.withValues(alpha: 0.55),
        ),
        const SizedBox(height: 14),
        BarraComparacao(
          rotulo: 'Farinha de *Tenebrio molitor*',
          valor: r.farinha,
          maximo: maximo,
          texto: formatarGramas(r.farinha),
          cor: m.destaque,
        ),
        const SizedBox(height: 24),
        Text(
          '${formatarNumero(r.alimento.proteinaPor100g)} g de proteína por '
          '100 $simbolo · ${TextosCalculadora.fonteTabela}',
          style: tema.textTheme.bodySmall?.copyWith(color: m.textoSuave),
        ),
        if (r.alimento.proteinaPor100g < 2) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: m.destaque, width: 3)),
            ),
            child: Text(
              TextosCalculadora.pobreEmProteina,
              style: tema.textTheme.bodyMedium,
            ),
          ),
        ],
      ],
    );
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RotuloMono('Resultado'),
        const SizedBox(height: 16),
        Text(
          'Escolha um alimento e informe a quantidade.',
          style: tema.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w300)
              .fonte,
        ),
        const SizedBox(height: 10),
        TextoRico(
          'O painel mostra quanto de farinha de *Tenebrio molitor* fornece a '
          'mesma proteína.',
          estilo: tema.textTheme.bodyMedium?.copyWith(
            color: context.marca.textoSuave,
          ),
        ),
      ],
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
    final m = context.marca;
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
                estilo: tema.textTheme.bodySmall,
                maxLinhas: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(texto, style: m.mono.copyWith(fontSize: 12.5, color: m.texto)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 10,
          color: m.linha,
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: fracao),
            duration: semAnimacao
                ? Duration.zero
                : const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            builder: (context, f, _) => FractionallySizedBox(
              widthFactor: valor > 0 ? math.max(f, 0.01) : 0,
              heightFactor: 1,
              child: ColoredBox(color: cor),
            ),
          ),
        ),
      ],
    );
  }
}
