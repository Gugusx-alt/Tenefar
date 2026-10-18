import 'package:flutter/foundation.dart';

import '../logic/calculadora.dart';
import '../logic/formatacao.dart';
import '../models/alimento.dart';
import '../models/item_refeicao.dart';

/// Como a quantidade está sendo informada.
enum ModoQuantidade { massa, porcoes }

/// Resultado de uma substituição já calculada.
class ResultadoSubstituicao {
  final Alimento alimento;
  final double gramasAlimento;
  final double proteina;
  final double farinha;
  final double colheres;

  const ResultadoSubstituicao({
    required this.alimento,
    required this.gramasAlimento,
    required this.proteina,
    required this.farinha,
    required this.colheres,
  });
}

/// Estado da calculadora (Provider + ChangeNotifier).
///
/// Guarda o que a pessoa digitou como texto e deriva o resultado com as
/// funções puras de `lib/logic/calculadora.dart`.
class CalculadoraController extends ChangeNotifier {
  Alimento? _alimento;
  String _quantidadeTexto = '';
  bool _quantidadeEditada = false;
  ModoQuantidade _modo = ModoQuantidade.massa;
  final Set<String> _categorias = {};
  final List<ItemRefeicao> _refeicao = [];
  String _pesoTexto = '';

  Alimento? get alimento => _alimento;
  String get quantidadeTexto => _quantidadeTexto;
  ModoQuantidade get modo => _modo;
  Set<String> get categorias => Set.unmodifiable(_categorias);
  List<ItemRefeicao> get refeicao => List.unmodifiable(_refeicao);
  String get pesoTexto => _pesoTexto;

  // ----- Substituir alimento -----

  /// Seleciona o alimento. Se o campo de quantidade estiver vazio, sugere
  /// 100 g/ml (ou 1 porção) para o resultado aparecer na hora.
  void selecionarAlimento(Alimento? alimento) {
    _alimento = alimento;
    if (alimento != null) {
      if (_modo == ModoQuantidade.porcoes && alimento.porcao == null) {
        _modo = ModoQuantidade.massa;
        _quantidadeTexto = '100';
        _quantidadeEditada = false;
      } else if (_quantidadeTexto.trim().isEmpty) {
        _quantidadeTexto = _modo == ModoQuantidade.porcoes ? '1' : '100';
        _quantidadeEditada = false;
      }
    }
    notifyListeners();
  }

  void definirQuantidade(String texto) {
    _quantidadeTexto = texto;
    _quantidadeEditada = true;
    notifyListeners();
  }

  /// Troca entre gramas/ml e porções, convertendo o valor já digitado.
  void definirModo(ModoQuantidade modo) {
    final porcao = _alimento?.porcao;
    if (modo == _modo || (modo == ModoQuantidade.porcoes && porcao == null)) {
      return;
    }
    final gramasAtuais = gramasAlimento;
    _modo = modo;
    if (modo == ModoQuantidade.porcoes) {
      final porcoes = gramasAtuais == null || gramasAtuais <= 0
          ? 1.0
          : gramasAtuais / porcao!.gramas;
      _quantidadeTexto = formatarParaCampo(porcoes);
    } else {
      _quantidadeTexto = formatarParaCampo(
        gramasAtuais ?? porcao?.gramas ?? 100,
      );
    }
    _quantidadeEditada = false;
    notifyListeners();
  }

  void alternarCategoria(String categoria) {
    if (!_categorias.remove(categoria)) _categorias.add(categoria);
    notifyListeners();
  }

  void limparCategorias() {
    _categorias.clear();
    notifyListeners();
  }

  /// Gramas (ou ml) que correspondem a 1 unidade digitada no campo.
  double get _gramasPorUnidade =>
      _modo == ModoQuantidade.porcoes ? _alimento?.porcao?.gramas ?? 1 : 1;

  Validacao get _validacao => validarQuantidade(
    _quantidadeTexto,
    gramasPorUnidade: _gramasPorUnidade,
    simbolo: _alimento?.simboloUnidade ?? 'g',
  );

  /// Mensagem para o `errorText` do campo de quantidade (só depois que a
  /// pessoa começa a digitar).
  String? get erroQuantidade => _quantidadeEditada ? _validacao.erro : null;

  /// Quantidade em gramas/ml, ou `null` se a entrada for inválida.
  double? get gramasAlimento {
    final valor = _validacao.valor;
    return valor == null ? null : valor * _gramasPorUnidade;
  }

  ResultadoSubstituicao? get resultado {
    final alimento = _alimento;
    final gramas = gramasAlimento;
    if (alimento == null || gramas == null) return null;
    final proteina = proteinaDoAlimento(gramas, alimento.proteinaPor100g);
    final farinha = farinhaNecessaria(proteina);
    return ResultadoSubstituicao(
      alimento: alimento,
      gramasAlimento: gramas,
      proteina: proteina,
      farinha: farinha,
      colheres: colheresDeSopa(farinha),
    );
  }

  bool get podeAdicionar => (resultado?.gramasAlimento ?? 0) > 0;

  void adicionarARefeicao() {
    final r = resultado;
    if (r == null || r.gramasAlimento <= 0) return;
    final simbolo = r.alimento.simboloUnidade;
    final gramasTexto = formatarGramas(r.gramasAlimento, simbolo);
    final porcao = r.alimento.porcao;
    final descricao = _modo == ModoQuantidade.porcoes && porcao != null
        ? '${formatarCompacto(_validacao.valor!)} × ${porcao.descricao} ($gramasTexto)'
        : gramasTexto;
    _refeicao.add(
      ItemRefeicao(
        alimento: r.alimento,
        gramas: r.gramasAlimento,
        descricaoQuantidade: descricao,
      ),
    );
    notifyListeners();
  }

  void removerItem(int indice) {
    _refeicao.removeAt(indice);
    notifyListeners();
  }

  void limparRefeicao() {
    _refeicao.clear();
    notifyListeners();
  }

  double get totalProteinaRefeicao =>
      _refeicao.fold(0, (soma, item) => soma + item.proteina);

  double get totalFarinhaRefeicao =>
      _refeicao.fold(0, (soma, item) => soma + item.farinha);

  // ----- Necessidade diária -----

  void definirPeso(String texto) {
    _pesoTexto = texto;
    notifyListeners();
  }

  String? get erroPeso =>
      _pesoTexto.isEmpty ? null : validarPeso(_pesoTexto).erro;

  double? get pesoKg => validarPeso(_pesoTexto).valor;

  double? get proteinaDiariaG {
    final peso = pesoKg;
    return peso == null ? null : proteinaDiaria(peso);
  }

  double? get farinhaDiariaG {
    final proteina = proteinaDiariaG;
    return proteina == null ? null : farinhaNecessaria(proteina);
  }
}
