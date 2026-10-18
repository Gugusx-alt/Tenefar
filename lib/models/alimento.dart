enum Unidade { g, ml }

/// Porção caseira de um alimento, ex.: "1 filé" = 100 g.
class Porcao {
  final String descricao; // ex.: "1 filé"
  final double gramas; // ex.: 100
  const Porcao(this.descricao, this.gramas);
}

class Alimento {
  final String id;
  final String nome;
  final String categoria;

  /// Gramas de proteína por 100 g (ou 100 ml, se [unidade] for [Unidade.ml]).
  final double proteinaPor100g;
  final Unidade unidade;
  final Porcao? porcao;

  const Alimento({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.proteinaPor100g,
    this.unidade = Unidade.g,
    this.porcao,
  });

  bool get liquido => unidade == Unidade.ml;

  /// Símbolo da unidade de massa/volume ("g" ou "ml").
  String get simboloUnidade => liquido ? 'ml' : 'g';

  @override
  String toString() => nome;
}
