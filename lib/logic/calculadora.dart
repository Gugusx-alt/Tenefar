/// Funções puras da calculadora de substituição proteica.
///
/// Nada aqui depende do Flutter: tudo pode ser testado com `flutter test`
/// (ou `dart test`) sem montar widgets.
library;

import '../app/config.dart';
import '../models/alimento.dart';
import 'formatacao.dart';

/// Gramas de proteína contidos em [quantidadeGramas] de um alimento.
double proteinaDoAlimento(double quantidadeGramas, double proteinaPor100g) =>
    quantidadeGramas * proteinaPor100g / 100;

/// Gramas de farinha de Tenebrio molitor que fornecem [proteinaGramas] de proteína.
double farinhaNecessaria(
  double proteinaGramas, {
  double teorFarinhaPor100g = Config.proteinaFarinhaPor100g,
}) => proteinaGramas / (teorFarinhaPor100g / 100);

/// Quantas colheres de sopa correspondem a [gramasFarinha].
double colheresDeSopa(
  double gramasFarinha, {
  double gramasPorColher = Config.gramasColherSopaFarinha,
}) => gramasFarinha / gramasPorColher;

/// Proteína mínima diária (g) para um adulto sedentário de [pesoKg] quilos.
double proteinaDiaria(
  double pesoKg, {
  double gramasPorKg = Config.proteinaGPorKgDia,
}) => pesoKg * gramasPorKg;

// ---------------------------------------------------------------------------
// Texto e busca
// ---------------------------------------------------------------------------

const Map<String, String> _semAcento = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ç': 'c', 'ñ': 'n',
};

/// Converte para minúsculas e remove acentos: `normalizar('Feijão') == 'feijao'`.
String normalizar(String texto) {
  final buffer = StringBuffer();
  for (final char in texto.toLowerCase().trim().split('')) {
    buffer.write(_semAcento[char] ?? char);
  }
  return buffer.toString();
}

/// Filtra [lista] pelo texto [busca] (ignorando acentos e maiúsculas) e pelas
/// [categorias] selecionadas (vazio = todas). Cada palavra da busca precisa
/// aparecer no nome. Nomes que começam com a busca vêm primeiro.
List<Alimento> filtrarAlimentos(
  List<Alimento> lista,
  String busca, {
  Set<String> categorias = const {},
}) {
  final termo = normalizar(busca);
  final palavras = termo.split(RegExp(r'[\s,]+')).where((p) => p.isNotEmpty);
  final resultado = lista.where((a) {
    if (categorias.isNotEmpty && !categorias.contains(a.categoria)) {
      return false;
    }
    final nome = normalizar(a.nome);
    return palavras.every(nome.contains);
  }).toList();

  resultado.sort((a, b) {
    final aComeca = normalizar(a.nome).startsWith(termo) ? 0 : 1;
    final bComeca = normalizar(b.nome).startsWith(termo) ? 0 : 1;
    if (aComeca != bComeca) return aComeca - bComeca;
    return normalizar(a.nome).compareTo(normalizar(b.nome));
  });
  return resultado;
}

// ---------------------------------------------------------------------------
// Entrada numérica e validação
// ---------------------------------------------------------------------------

/// Lê um número aceitando vírgula ou ponto como separador decimal.
/// Retorna `null` se o texto não for um número válido.
double? lerNumero(String texto) {
  final limpo = texto.trim().replaceAll(' ', '').replaceAll(',', '.');
  if (limpo.isEmpty || '.'.allMatches(limpo).length > 1) return null;
  return double.tryParse(limpo);
}

/// Resultado da validação de um campo numérico: [valor] quando válido,
/// [erro] com a mensagem para o `errorText` quando inválido.
class Validacao {
  final double? valor;
  final String? erro;
  const Validacao.ok(double this.valor) : erro = null;
  const Validacao.erro(String this.erro) : valor = null;

  bool get valido => erro == null;
}

/// Valida a quantidade digitada na calculadora.
///
/// [gramasPorUnidade] é 1 quando a pessoa digita gramas/ml e o peso da porção
/// quando ela digita porções; o limite de [Config.quantidadeMaxima] vale para
/// o total em gramas/ml. Zero é aceito (o resultado mostra 0).
Validacao validarQuantidade(
  String texto, {
  double gramasPorUnidade = 1,
  String simbolo = 'g',
}) {
  if (texto.trim().isEmpty) {
    return const Validacao.erro('Informe a quantidade.');
  }
  final valor = lerNumero(texto);
  if (valor == null) {
    return const Validacao.erro('Digite um número válido (ex.: 150 ou 1,5).');
  }
  if (valor < 0) {
    return const Validacao.erro('A quantidade não pode ser negativa.');
  }
  if (valor * gramasPorUnidade > Config.quantidadeMaxima) {
    final maximo = formatarCompacto(Config.quantidadeMaxima);
    return Validacao.erro(
      gramasPorUnidade == 1
          ? 'O valor máximo é $maximo $simbolo.'
          : 'O total não pode passar de $maximo $simbolo.',
    );
  }
  return Validacao.ok(valor);
}

/// Valida o peso corporal (kg) da aba "Necessidade diária".
Validacao validarPeso(String texto) {
  if (texto.trim().isEmpty) return const Validacao.erro('Informe o peso.');
  final valor = lerNumero(texto);
  if (valor == null) {
    return const Validacao.erro('Digite um número válido (ex.: 70 ou 62,5).');
  }
  if (valor <= 0) {
    return const Validacao.erro('O peso deve ser maior que zero.');
  }
  if (valor > Config.pesoMaximoKg) {
    return Validacao.erro(
      'Informe um peso de até ${formatarCompacto(Config.pesoMaximoKg)} kg.',
    );
  }
  return Validacao.ok(valor);
}
