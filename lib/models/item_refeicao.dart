import '../logic/calculadora.dart';
import 'alimento.dart';

/// Um alimento adicionado à refeição montada na calculadora.
class ItemRefeicao {
  final Alimento alimento;

  /// Quantidade em gramas (ou ml) já convertida, mesmo quando informada em porções.
  final double gramas;

  /// Texto da quantidade como a pessoa informou, ex.: "2 × 1 filé (200 g)".
  final String descricaoQuantidade;

  const ItemRefeicao({
    required this.alimento,
    required this.gramas,
    required this.descricaoQuantidade,
  });

  double get proteina => proteinaDoAlimento(gramas, alimento.proteinaPor100g);

  double get farinha => farinhaNecessaria(proteina);
}
