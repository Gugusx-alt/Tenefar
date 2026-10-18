import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app/config.dart';
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
    final tema = Theme.of(context);

    return AppScaffold(
      titulo: 'Calculadora',
      children: [
        Secao(
          sobretitulo: 'Ferramenta',
          titulo: 'Calculadora de substituição proteica',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextoRico(
                'Escolha um alimento e informe a quantidade: a calculadora '
                'mostra quantos gramas da farinha de *Tenebrio molitor* '
                'fornecem a mesma quantidade de proteína.',
                estilo: tema.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              if (Config.valorProvisorio) ...[
                const SizedBox(height: 16),
                const _Alerta(
                  icone: Icons.warning_amber_rounded,
                  texto: TextosCalculadora.avisoProvisorio,
                ),
              ],
              const SizedBox(height: 24),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      controller: _abas,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.swap_horiz),
                          text: 'Substituir alimento',
                        ),
                        Tab(
                          icon: Icon(Icons.today_outlined),
                          text: 'Necessidade diária',
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.sizeOf(context).width < 600 ? 16 : 24,
                      ),
                      child: _abas.index == 0
                          ? const _AbaSubstituir()
                          : const _AbaNecessidade(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _Alerta(
                icone: Icons.health_and_safety_outlined,
                texto: TextosCalculadora.avisoFinal,
                discreto: true,
              ),
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
            if (restricoes.maxWidth >= 720) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: formulario),
                  const SizedBox(width: 24),
                  Expanded(flex: 9, child: resultado),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [formulario, const SizedBox(height: 20), resultado],
            );
          },
        ),
        const SizedBox(height: 28),
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
    final ctrl = context.watch<CalculadoraController>();
    final alimento = ctrl.alimento;
    final porcao = alimento?.porcao;
    final simbolo = alimento?.simboloUnidade ?? 'g';
    final emPorcoes = ctrl.modo == ModoQuantidade.porcoes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Passo(numero: 1, texto: 'Escolha o alimento'),
        const SizedBox(height: 12),
        BuscaAlimento(aoSelecionar: aoSelecionarAlimento),
        const SizedBox(height: 24),
        _Passo(numero: 2, texto: 'Informe a quantidade'),
        const SizedBox(height: 12),
        SegmentedButton<ModoQuantidade>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: ModoQuantidade.massa,
              label: Text(simbolo == 'ml' ? 'ml' : 'gramas'),
              icon: const Icon(Icons.scale_outlined),
            ),
            ButtonSegment(
              value: ModoQuantidade.porcoes,
              label: const Text('porções'),
              icon: const Icon(Icons.restaurant_outlined),
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
          style: tema.textTheme.headlineSmall,
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
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.restaurant,
                size: 18,
                color: tema.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '1 porção = ${porcao.descricao} '
                  '(${formatarCompacto(porcao.gramas)} $simbolo)',
                  style: tema.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
        if (alimento?.liquido ?? false) ...[
          const SizedBox(height: 6),
          Text(
            TextosCalculadora.notaMl,
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: ctrl.podeAdicionar ? ctrl.adicionarARefeicao : null,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar à refeição'),
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
    final tema = Theme.of(context);
    return Semantics(
      header: true,
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: tema.colorScheme.secondary,
            child: Text(
              '$numero',
              style: TextStyle(
                color: tema.colorScheme.onSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: tema.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de alimentos adicionados e totais.
class _Refeicao extends StatelessWidget {
  const _Refeicao();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final ctrl = context.watch<CalculadoraController>();
    final itens = ctrl.refeicao;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: esquema.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: esquema.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    'Montar refeição',
                    style: tema.textTheme.titleLarge,
                  ),
                ),
              ),
              if (itens.isNotEmpty)
                TextButton.icon(
                  onPressed: ctrl.limparRefeicao,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Limpar'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (itens.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Use "Adicionar à refeição" para somar vários alimentos e ver o '
                'total de proteína e de farinha equivalente.',
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            for (var i = 0; i < itens.length; i++)
              Dismissible(
                key: ObjectKey(itens[i]),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => ctrl.removerItem(i),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: esquema.errorContainer,
                  child: Icon(
                    Icons.delete_outline,
                    color: esquema.onErrorContainer,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(itens[i].alimento.nome),
                  subtitle: Text(
                    '${itens[i].descricaoQuantidade} · '
                    '${formatarGramas(itens[i].proteina)} de proteína · '
                    '${formatarGramas(itens[i].farinha)} de farinha',
                  ),
                  trailing: IconButton(
                    tooltip: 'Remover ${itens[i].alimento.nome}',
                    icon: const Icon(Icons.close),
                    onPressed: () => ctrl.removerItem(i),
                  ),
                ),
              ),
            const Divider(height: 24),
            Semantics(
              liveRegion: true,
              child: Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  _Total(
                    rotulo: 'Total de proteína',
                    valor: formatarGramas(ctrl.totalProteinaRefeicao),
                  ),
                  _Total(
                    rotulo: 'Total de farinha de *Tenebrio*',
                    valor: formatarGramas(ctrl.totalFarinhaRefeicao),
                    destaque: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
  final String valor;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextoRico(rotulo, estilo: tema.textTheme.bodyMedium),
        Text(
          valor,
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: destaque ? tema.colorScheme.primary : null,
          ),
        ),
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
    final esquema = tema.colorScheme;
    final ctrl = context.watch<CalculadoraController>();
    final proteina = ctrl.proteinaDiariaG;
    final farinha = ctrl.farinhaDiariaG;

    final campo = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('campo-peso'),
          controller: _peso,
          onChanged: ctrl.definirPeso,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
          ],
          style: tema.textTheme.headlineSmall,
          decoration: InputDecoration(
            labelText: 'Peso corporal (kg)',
            hintText: 'ex.: 70',
            suffixText: 'kg',
            errorText: ctrl.erroPeso,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          TextosCalculadora.notaNecessidade,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: esquema.onSurfaceVariant,
            height: 1.45,
          ),
        ),
      ],
    );

    final resultado = Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: esquema.primaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: esquema.primary.withValues(alpha: 0.25)),
        ),
        child: proteina == null || farinha == null
            ? Text(
                'Digite o peso para calcular a proteína mínima diária.',
                style: tema.textTheme.bodyLarge,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Proteína mínima por dia',
                    style: tema.textTheme.bodyLarge,
                  ),
                  Text(
                    formatarGramas(proteina),
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Divider(height: 28),
                  TextoRico(
                    'Farinha de *Tenebrio* que cobriria esse valor',
                    estilo: tema.textTheme.bodyLarge,
                  ),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formatarGramas(farinha),
                      style: tema.textTheme.displaySmall?.copyWith(
                        color: esquema.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '≈ ${formatarNumero(colheresDeSopa(farinha))} colheres de sopa',
                    style: tema.textTheme.titleMedium?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );

    return LayoutBuilder(
      builder: (context, restricoes) => restricoes.maxWidth >= 720
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: campo),
                const SizedBox(width: 24),
                Expanded(child: resultado),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [campo, const SizedBox(height: 20), resultado],
            ),
    );
  }
}

class _Alerta extends StatelessWidget {
  const _Alerta({
    required this.icone,
    required this.texto,
    this.discreto = false,
  });

  final IconData icone;
  final String texto;
  final bool discreto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final fundo = discreto
        ? esquema.surfaceContainerHighest
        : esquema.tertiaryContainer;
    final frente = discreto
        ? esquema.onSurfaceVariant
        : esquema.onTertiaryContainer;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: frente),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: frente, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
