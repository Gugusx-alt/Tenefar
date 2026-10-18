import 'package:intl/intl.dart';

final NumberFormat _umaCasa = NumberFormat('#,##0.0', 'pt_BR');

/// Formata no padrão brasileiro com 1 casa decimal: 1234.56 → "1.234,6".
String formatarNumero(double valor) => _umaCasa.format(valor);

/// Formata gramas: 64 → "64,0 g".
String formatarGramas(double valor, [String simbolo = 'g']) =>
    '${formatarNumero(valor)} $simbolo';

/// Formata números "redondos" sem casas decimais: 100 → "100", 2.5 → "2,5".
String formatarCompacto(double valor) {
  if (valor == valor.roundToDouble()) {
    return NumberFormat('#,##0', 'pt_BR').format(valor);
  }
  return NumberFormat('#,##0.##', 'pt_BR').format(valor);
}

/// Formata um valor para preencher um campo de texto: sem separador de
/// milhar (que seria lido como decimal), até 2 casas: 1500 → "1500", 2.5 → "2,5".
String formatarParaCampo(double valor) =>
    NumberFormat('0.##', 'pt_BR').format(valor);
