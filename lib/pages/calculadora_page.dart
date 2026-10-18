import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app/config.dart';
import '../app/theme.dart';
import '../data/conteudo_projeto.dart';
import '../logic/calculadora.dart';
import '../logic/formatacao.dart';
import '../models/alimento.dart';
import '../state/calculadora_controller.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/busca_alimento.dart';
import '../widgets/resultado_card.dart';
import '../widgets/secao.dart';
import '../widgets/texto_rico.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage>
    with SingleTickerProviderStateMixin {
  late final TabController _abas = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _abas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final estreito = MediaQuery.sizeOf(context).width < 600;

    return AppScaffold(
      titulo: 'Calculadora',
      children: [
        CabecalhoPagina(
          numero: '04',
          rotulo: 'Calculadora',
          titulo: 'Calculadora de substituição *proteica*',
          introducao:
              'Escolha um alimento e informe a quantidade: a calculadora '
              'mostra quantos gramas da farinha de *Tenebrio molitor* '
              'fornecem a mesma quantidade de proteína.',
          extra: Config.valorProvisorio
              ? const _Nota(
                  rotulo: 'Valor provisório',
                  texto: TextosCalculadora.avisoProvisorio,
                )
              : null,
        ),
        Secao(
          espacoVertical: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: m.painel,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: m.linha),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      controller: _abas,
                      tabs: const [
                        Tab(text: 'Substituir alimento'),
                        Tab(text: 'Necessidade diária'),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(estreito ? 16 : 32),
                      child: _abas.index == 0
                          ? const _AbaSubstituir()
                          : const _AbaNecessidade(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const _Nota(
                rotulo: 'Aviso',
                texto: TextosCalculadora.avisoFinal,
                discreta: true,
              ),
              const SizedBox(height: 72),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Aba "Substituir alimento"
// ---------------------------------------------------------------------------

class _AbaSubstituir extends StatefulWidget {
  const _AbaSubstituir();

  @override
  State<_AbaSubstituir> createState() => _AbaSubstituirState();
}

class _AbaSubstituirState extends State<_AbaSubstituir> {
  late final TextEditingController _quantidade = TextEditingController(
    text: context.read<CalculadoraController>().quantidadeTexto,
  );

  @override
  void dispose() {
    _quantidade.dispose();
    super.dispose();
  }

  /// Copia para o campo o texto que o controller definiu (ex.: ao trocar de unidade).
  void _sincronizarCampo() {
    final texto = context.read<CalculadoraController>().quantidadeTexto;
    if (_quantidade.text != texto) {
      _quantidade.value = TextEditingValue(
        text: texto,
        selection: TextSelection.collapsed(offset: texto.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CalculadoraController>();
    final formulario = _Formulario(
      quantidade: _quantidade,
      aoSelecionarAlimento: (alimento) {
        ctrl.selecionarAlimento(alimento);
        _sincronizarCampo();
      },
      aoMudarModo: (modo) {
        ctrl.definirModo(modo);
        _sincronizarCampo();
      },
    );
    final resultado = ResultadoCard(resultado: ctrl.resultado);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, restricoes) {
            if (restricoes.maxWidth >= 760) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: formulario),
                  const SizedBox(width: 40),
                  Expanded(flex: 9, child: resultado),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [formulario, const SizedBox(height: 24), resultado],
            );
          },
        ),
        const SizedBox(height: 40),
        const _Refeicao(),
      ],
    );
  }
}

class _Formulario extends StatelessWidget {
  const _Formulario({
    required this.quantidade,
    required this.aoSelecionarAlimento,
    required this.aoMudarModo,
  });

  final TextEditingController quantidade;
  final ValueChanged<Alimento?> aoSelecionarAlimento;
  final ValueChanged<ModoQuantidade> aoMudarModo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final ctrl = context.watch<CalculadoraController>();
    final alimento = ctrl.alimento;
    final porcao = alimento?.porcao;
    final simbolo = alimento?.simboloUnidade ?? 'g';
    final emPorcoes = ctrl.modo == ModoQuantidade.porcoes;
    final nota = tema.textTheme.bodySmall?.copyWith(color: m.textoSuave);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Passo(numero: 1, texto: 'Escolha o alimento'),
        const SizedBox(height: 14),
        BuscaAlimento(aoSelecionar: aoSelecionarAlimento),
        const SizedBox(height: 36),
        const _Passo(numero: 2, texto: 'Informe a quantidade'),
        const SizedBox(height: 14),
        SegmentedButton<ModoQuantidade>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: ModoQuantidade.massa,
              label: Text(simbolo == 'ml' ? 'ml' : 'gramas'),
            ),
            ButtonSegment(
              value: ModoQuantidade.porcoes,
              label: const Text('porções'),
              enabled: porcao != null,
              tooltip: porcao == null
                  ? 'Este alimento não tem porção caseira cadastrada'
                  : null,
            ),
          ],
          selected: {ctrl.modo},
          onSelectionChanged: (s) => aoMudarModo(s.first),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('campo-quantidade'),
          controller: quantidade,
          enabled: alimento != null,
          onChanged: ctrl.definirQuantidade,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
          ],
          style: m.mono.copyWith(fontSize: 24, color: m.texto),
          decoration: InputDecoration(
            labelText: emPorcoes
                ? 'Quantidade de porções'
                : 'Quantidade (${simbolo == 'ml' ? 'ml' : 'gramas'})',
            hintText: emPorcoes ? 'ex.: 1 ou 1,5' : 'ex.: 150',
            suffixText: emPorcoes ? 'porção(ões)' : simbolo,
            errorText: ctrl.erroQuantidade,
            helperText: alimento == null
                ? 'Escolha um alimento primeiro.'
                : 'Use vírgula ou ponto para decimais.',
          ),
        ),
        if (porcao != null) ...[
          const SizedBox(height: 12),
          Text(
            '1 porção = ${porcao.descricao} '
            '(${formatarCompacto(porcao.gramas)} $simbolo)',
            style: m.mono.copyWith(fontSize: 13, color: m.texto),
          ),
        ],
        if (alimento?.liquido ?? false) ...[
          const SizedBox(height: 6),
          Text(TextosCalculadora.notaMl, style: nota),
        ],
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: ctrl.podeAdicionar ? ctrl.adicionarARefeicao : null,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Adicionar à refeição'),
          ),
        ),
      ],
    );
  }
}

class _Passo extends StatelessWidget {
  const _Passo({required this.numero, required this.texto});

  final int numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Semantics(
      header: true,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            color: m.destaque,
            child: Text(
              '$numero',
              style: m.mono
                  .copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Cores.tinta,
                  )
                  .fonte,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}

/// Lista de alimentos adicionados e totais, no estilo de uma nota/recibo.
class _Refeicao extends StatelessWidget {
  const _Refeicao();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final ctrl = context.watch<CalculadoraController>();
    final itens = ctrl.refeicao;
    final mono = m.mono.copyWith(fontSize: 13, color: m.textoSuave);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'Montar refeição',
                  style: tema.textTheme.headlineMedium,
                ),
              ),
            ),
            if (itens.isNotEmpty)
              TextButton.icon(
                onPressed: ctrl.limparRefeicao,
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Limpar'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (itens.isEmpty)
          Text(
            'Use "Adicionar à refeição" para somar vários alimentos e ver o '
            'total de proteína e de farinha equivalente.',
            style: tema.textTheme.bodyMedium?.copyWith(color: m.textoSuave),
          )
        else ...[
          const SizedBox(height: 8),
          for (var i = 0; i < itens.length; i++)
            Dismissible(
              key: ObjectKey(itens[i]),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => ctrl.removerItem(i),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: m.destaque.withValues(alpha: 0.35),
                child: Icon(Icons.delete_outline, color: m.texto),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: m.linha)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itens[i].alimento.nome,
                            style: tema.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${itens[i].descricaoQuantidade} · '
                            '${formatarGramas(itens[i].proteina)} de proteína · '
                            '${formatarGramas(itens[i].farinha)} de farinha',
                            style: mono,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remover ${itens[i].alimento.nome}',
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => ctrl.removerItem(i),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: m.texto, width: 1.5)),
            ),
            child: Semantics(
              liveRegion: true,
              child: Wrap(
                spacing: 56,
                runSpacing: 16,
                children: [
                  _Total(
                    rotulo: 'Total de proteína',
                    valor: ctrl.totalProteinaRefeicao,
                  ),
                  _Total(
                    rotulo: 'Total de farinha de *Tenebrio*',
                    valor: ctrl.totalFarinhaRefeicao,
                    destaque: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.rotulo,
    required this.valor,
    this.destaque = false,
  });

  final String rotulo;
  final double valor;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final numero = NumeroContado(
      valor: valor,
      formatar: formatarGramas,
      estilo: tema.textTheme.headlineLarge,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextoRico(
          rotulo,
          estilo: tema.textTheme.bodyMedium?.copyWith(color: m.textoSuave),
        ),
        const SizedBox(height: 4),
        // O total de farinha recebe o marca-texto ocre, como no resto do site.
        if (destaque)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: m.destaque, width: 4)),
            ),
            child: numero,
          )
        else
          numero,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Aba "Necessidade diária"
// ---------------------------------------------------------------------------

class _AbaNecessidade extends StatefulWidget {
  const _AbaNecessidade();

  @override
  State<_AbaNecessidade> createState() => _AbaNecessidadeState();
}

class _AbaNecessidadeState extends State<_AbaNecessidade> {
  late final TextEditingController _peso = TextEditingController(
    text: context.read<CalculadoraController>().pesoTexto,
  );

  @override
  void dispose() {
    _peso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final m = context.marca;
    final ctrl = context.watch<CalculadoraController>();
    final proteina = ctrl.proteinaDiariaG;
    final farinha = ctrl.farinhaDiariaG;

    final campo = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Passo(numero: 1, texto: 'Informe o peso corporal'),
        const SizedBox(height: 14),
        TextFormField(
          key: const Key('campo-peso'),
          controller: _peso,
          onChanged: ctrl.definirPeso,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
          ],
          style: m.mono.copyWith(fontSize: 24, color: m.texto),
          decoration: InputDecoration(
            labelText: 'Peso corporal (kg)',
            hintText: 'ex.: 70',
            suffixText: 'kg',
            errorText: ctrl.erroPeso,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          TextosCalculadora.notaNecessidade,
          style: tema.textTheme.bodyMedium?.copyWith(color: m.textoSuave),
        ),
      ],
    );

    final resultado = Semantics(
      liveRegion: true,
      container: true,
      child: PainelResultado(
        child: proteina == null || farinha == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RotuloMono('Resultado'),
                  const SizedBox(height: 16),
                  Text(
                    'Digite o peso para calcular a proteína mínima diária.',
                    style: tema.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w300)
                        .fonte,
                  ),
                ],
              )
            : Builder(
                builder: (context) {
                  final mb = context.marca;
                  final tb = Theme.of(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const RotuloMono('Proteína mínima por dia'),
                      const SizedBox(height: 4),
                      NumeroContado(
                        valor: proteina,
                        formatar: formatarGramas,
                        estilo: mb.mono
                            .copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: mb.texto,
                            )
                            .fonte,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      TextoRico(
                        'Farinha de *Tenebrio* que cobriria esse valor',
                        estilo: tb.textTheme.titleMedium,
                      ),
                      FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: NumeroContado(
                          valor: farinha,
                          formatar: formatarGramas,
                          estilo: tb.textTheme.displayMedium
                              ?.copyWith(
                                color: mb.destaque,
                                fontWeight: FontWeight.w400,
                              )
                              .fonte,
                        ),
                      ),
                      Text(
                        '≈ ${ResultadoCard.colheres(colheresDeSopa(farinha))}',
                        style: mb.mono.copyWith(
                          fontSize: 14,
                          color: mb.textoSuave,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );

    return LayoutBuilder(
      builder: (context, restricoes) => restricoes.maxWidth >= 760
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 11, child: campo),
                const SizedBox(width: 40),
                Expanded(flex: 9, child: resultado),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [campo, const SizedBox(height: 24), resultado],
            ),
    );
  }
}

/// Nota com fio ocre à esquerda e rótulo mono.
class _Nota extends StatelessWidget {
  const _Nota({
    required this.rotulo,
    required this.texto,
    this.discreta = false,
  });

  final String rotulo;
  final String texto;
  final bool discreta;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: discreta ? m.linha : m.destaque, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rotulo.toUpperCase(),
              style: m.mono.copyWith(
                fontSize: 12,
                letterSpacing: 1.2,
                color: m.textoSuave,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              texto,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: discreta ? m.textoSuave : m.texto),
            ),
          ],
        ),
      ),
    );
  }
}
