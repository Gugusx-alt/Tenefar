/// Constantes editáveis do app.
///
/// Este arquivo não depende do Flutter, para poder ser usado pelas funções
/// puras de `lib/logic/` e pelos testes unitários.
class Config {
  Config._();

  /// Teor de proteína da farinha de Tenebrio molitor (g de proteína por 100 g de farinha).
  /// VALOR PROVISÓRIO, baseado na ordem de grandeza relatada na literatura para larva desidratada.
  /// Substituir pelo resultado da análise de Kjeldahl do projeto quando ela estiver pronta.
  static const double proteinaFarinhaPor100g = 50;

  /// Mudar para false quando houver o valor medido (esconde o aviso na calculadora).
  static const bool valorProvisorio = true;

  /// Peso aproximado de 1 colher de sopa da farinha (g). PROVISÓRIO: medir na prática.
  static const double gramasColherSopaFarinha = 10;

  /// Recomendação mínima média de proteína para adultos sedentários (Varella, 2025).
  static const double proteinaGPorKgDia = 0.8;

  /// Quantidade máxima aceita na calculadora (g ou ml).
  static const double quantidadeMaxima = 5000;

  /// Peso corporal máximo aceito na aba "Necessidade diária" (kg).
  static const double pesoMaximoKg = 400;
}
