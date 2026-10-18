import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alimentos.dart';
import '../logic/calculadora.dart';
import '../logic/formatacao.dart';
import '../models/alimento.dart';
import '../state/calculadora_controller.dart';

/// Busca de alimento com `Autocomplete` + filtros de categoria.
/// A busca ignora acentos e maiúsculas ("feijao" encontra "Feijão").
class BuscaAlimento extends StatefulWidget {
  const BuscaAlimento({super.key, required this.aoSelecionar});

  /// Chamado com o alimento escolhido, ou `null` quando a pessoa apaga ou
  /// altera o texto da busca.
  final ValueChanged<Alimento?> aoSelecionar;

  @override
  State<BuscaAlimento> createState() => _BuscaAlimentoState();
}

class _BuscaAlimentoState extends State<BuscaAlimento> {
  late final TextEditingController _texto;
  final FocusNode _foco = FocusNode();
  bool _ignorarMudanca = false;

  @override
  void initState() {
    super.initState();
    final atual = context.read<CalculadoraController>().alimento;
    _texto = TextEditingController(text: atual?.nome ?? '');
    _texto.addListener(_aoMudarTexto);
  }

  @override
  void dispose() {
    _texto.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _aoMudarTexto() {
    if (_ignorarMudanca) return;
    final selecionado = context.read<CalculadoraController>().alimento;
    if (selecionado != null && _texto.text != selecionado.nome) {
      widget.aoSelecionar(null);
    }
  }

  void _alternarCategoria(String categoria) {
    context.read<CalculadoraController>().alternarCategoria(categoria);
    // O Autocomplete só recalcula as opções quando o texto muda; este "toque"
    // no texto força a lista a refletir o novo filtro de categoria.
    _ignorarMudanca = true;
    final texto = _texto.text;
    _texto.text = '$texto ';
    _texto.text = texto;
    _ignorarMudanca = false;
    _foco.requestFocus();
  }

  Iterable<Alimento> _opcoes(TextEditingValue valor) {
    final categorias = context.read<CalculadoraController>().categorias;
    if (valor.text.trim().isEmpty && categorias.isEmpty) return const [];
    return filtrarAlimentos(alimentos, valor.text, categorias: categorias);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final categorias = context.select<CalculadoraController, Set<String>>(
      (c) => c.categorias,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Autocomplete<Alimento>(
          textEditingController: _texto,
          focusNode: _foco,
          displayStringForOption: (a) => a.nome,
          optionsBuilder: _opcoes,
          onSelected: (alimento) {
            widget.aoSelecionar(alimento);
            _foco.unfocus();
          },
          fieldViewBuilder: (context, controller, foco, aoEnviar) =>
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, valor, _) => TextField(
                  key: const Key('campo-busca-alimento'),
                  controller: controller,
                  focusNode: foco,
                  style: tema.textTheme.titleMedium,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => aoEnviar(),
                  decoration: InputDecoration(
                    labelText: 'Alimento',
                    hintText: 'Digite para buscar, ex.: feijão',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: valor.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              controller.clear();
                              widget.aoSelecionar(null);
                            },
                          ),
                  ),
                ),
              ),
          optionsViewBuilder: (context, aoEscolher, opcoes) =>
              _ListaOpcoes(opcoes: opcoes, aoEscolher: aoEscolher),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Filtrar por categoria',
                style: tema.textTheme.labelLarge?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (categorias.isNotEmpty)
              TextButton(
                onPressed: () =>
                    context.read<CalculadoraController>().limparCategorias(),
                child: const Text('Limpar filtros'),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final categoria in Categorias.todas)
              FilterChip(
                label: Text(categoria),
                selected: categorias.contains(categoria),
                onSelected: (_) => _alternarCategoria(categoria),
              ),
          ],
        ),
      ],
    );
  }
}

class _ListaOpcoes extends StatelessWidget {
  const _ListaOpcoes({required this.opcoes, required this.aoEscolher});

  final Iterable<Alimento> opcoes;
  final AutocompleteOnSelected<Alimento> aoEscolher;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final destacado = AutocompleteHighlightedOption.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 6),
            shrinkWrap: true,
            itemCount: opcoes.length,
            itemBuilder: (context, i) {
              final alimento = opcoes.elementAt(i);
              return ListTile(
                selected: i == destacado,
                selectedTileColor: tema.colorScheme.secondaryContainer,
                title: Text(alimento.nome),
                subtitle: Text(
                  '${alimento.categoria} · '
                  '${formatarNumero(alimento.proteinaPor100g)} g de proteína / '
                  '100 ${alimento.simboloUnidade}',
                ),
                onTap: () => aoEscolher(alimento),
              );
            },
          ),
        ),
      ),
    );
  }
}
