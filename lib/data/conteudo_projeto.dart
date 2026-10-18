// Textos do projeto exibidos no app.
//
// TROQUE AQUI os textos das páginas. Trechos entre asteriscos (*assim*)
// aparecem em itálico — use para nomes científicos, ex.: *Tenebrio molitor*.
// Campos entre colchetes ([assim]) são placeholders a preencher.

import 'package:flutter/material.dart' show IconData, Icons;

// ---------------------------------------------------------------------------
// Identificação
// ---------------------------------------------------------------------------

class InfoProjeto {
  InfoProjeto._();

  static const nomeCurto = 'TENEFAR';
  static const slogan = 'Nutrição que transforma';
  static const titulo =
      'Desenvolvimento de pó nutricional proteico à base de *Tenebrio molitor* '
      'para suporte nutricional em casos de desnutrição aguda';
  static const fraseImpacto =
      'Proteína de baixo custo e baixo impacto ambiental, a partir da '
      'larva-da-farinha, para quem mais precisa.';
  static const instituicao =
      'Universidade Estadual do Oeste do Paraná (Unioeste)';
  static const siglaInstituicao = 'Unioeste';
  static const programa =
      'Pró-Reitoria de Pesquisa e Pós-Graduação · Programa de Iniciação Científica (PIBIC)';
  static const area =
      'Ciências Agrárias > Ciência e Tecnologia de Alimentos > Tecnologia de Alimentos';
  static const palavrasChave = [
    '*Tenebrio molitor*',
    'Suplementação alimentar',
    'Desnutrição aguda',
  ];
  static const status = 'Em andamento';

  static const resumo =
      'A desnutrição aguda é um importante problema de saúde pública, '
      'principalmente em regiões com insegurança alimentar e crises '
      'humanitárias. O *Tenebrio molitor* (larva-da-farinha) é uma alternativa '
      'promissora por ter alto teor proteico, baixo custo de produção e baixo '
      'impacto ambiental. O projeto quer desenvolver um pó nutricional proteico '
      'de baixo custo a partir das larvas, com possível uso no suporte '
      'nutricional em casos de desnutrição aguda. As etapas são: criação '
      'controlada das larvas, processamento e obtenção do pó, e depois análises '
      'nutricionais, físico-químicas e microbiológicas, incluindo teor proteico '
      'e viabilidade de conservação.';

  static const resumoCurto =
      'Um pó nutricional proteico de baixo custo, obtido a partir de larvas de '
      '*Tenebrio molitor* criadas de forma controlada, desidratadas e '
      'trituradas, para avaliar seu uso no suporte nutricional em casos de '
      'desnutrição aguda.';
}

// ---------------------------------------------------------------------------
// Contato (aparece no rodapé) — PREENCHA AQUI
// ---------------------------------------------------------------------------

class Contato {
  Contato._();

  static const email = '[E-mail de contato]';
}

// ---------------------------------------------------------------------------
// O problema
// ---------------------------------------------------------------------------

class Problema {
  Problema._();

  static const paragrafos = [
    'A desnutrição aguda aumenta a mortalidade, prejudica o desenvolvimento '
        'físico e cognitivo e deixa as pessoas mais vulneráveis a infecções. '
        'A falta de proteína é um dos fatores mais críticos.',
    'As proteínas constroem e reparam músculos, formam tecidos, sustentam a '
        'defesa imunológica e mantêm o metabolismo.',
  ];

  static const recomendacao =
      'A recomendação média é de no mínimo 0,8 g de proteína por kg de peso '
      'corporal por dia para adultos sedentários (Varella, 2025).';
}

// ---------------------------------------------------------------------------
// Por que Tenebrio molitor
// ---------------------------------------------------------------------------

class Vantagem {
  final IconData icone;
  final String titulo;
  const Vantagem(this.icone, this.titulo);
}

const vantagensTenebrio = [
  Vantagem(Icons.fitness_center, 'Alto teor proteico'),
  Vantagem(Icons.science_outlined, 'Presença de aminoácidos essenciais'),
  Vantagem(Icons.sync_alt, 'Boa eficiência de conversão alimentar'),
  Vantagem(
    Icons.eco_outlined,
    'Menor impacto ambiental que as proteínas animais convencionais',
  ),
  Vantagem(Icons.savings_outlined, 'Baixo custo'),
  Vantagem(
    Icons.view_module_outlined,
    'Criação fácil, verticalizada e em espaços compactos',
  ),
  Vantagem(Icons.delete_outline, 'Pouca geração de resíduos'),
  Vantagem(
    Icons.recycling,
    'Uso de subprodutos agrícolas como alimento das larvas (economia circular)',
  ),
];

const fonteVantagens = '(Vieceli, 2023; Nascimento, 2024)';

// ---------------------------------------------------------------------------
// Objetivos
// ---------------------------------------------------------------------------

const objetivoGeral =
    'Desenvolver um pó nutricional proteico de baixo custo à base de '
    '*Tenebrio molitor* e avaliar seu potencial como matéria-prima para '
    'formulações alimentares destinadas ao suporte nutricional em casos de '
    'desnutrição aguda.';

const objetivosEspecificos = [
  'Criar larvas de *T. molitor* de forma controlada (padronização biológica, '
      'controle populacional, qualidade da matéria-prima)',
  'Acompanhar o ciclo biológico, separando larva, pupa e adulto',
  'Desenvolver um método acessível e de baixo custo para obter o pó a partir '
      'do processamento e da desidratação das larvas',
  'Avaliar a eficiência da desidratação térmica na conservação e na '
      'preservação dos nutrientes',
  'Determinar o teor proteico por meio de análises bromatológicas',
  'Avaliar umidade, estabilidade e condições de conservação',
  'Fazer análises microbiológicas para verificar a segurança sanitária',
  'Comparar os resultados com a literatura científica',
  'Investigar o potencial do inseto como fonte proteica sustentável e '
      'acessível para uso emergencial',
  'Analisar a viabilidade de usar o pó em produtos futuros, como tabletes '
      'nutricionais e suplementos emergenciais',
];

// ---------------------------------------------------------------------------
// ODS — cores oficiais da ONU
// ---------------------------------------------------------------------------

class Ods {
  final int numero;
  final String nome;

  /// Cor oficial (ARGB).
  final int cor;
  const Ods(this.numero, this.nome, this.cor);
}

const odsProjeto = [
  Ods(2, 'Fome Zero e Agricultura Sustentável', 0xFFDDA63A),
  Ods(3, 'Saúde e Bem-Estar', 0xFF4C9F38),
  Ods(9, 'Indústria, Inovação e Infraestrutura', 0xFFFD6925),
  Ods(10, 'Redução das Desigualdades', 0xFFDD1367),
  Ods(12, 'Consumo e Produção Responsáveis', 0xFFBF8B2E),
];

// ---------------------------------------------------------------------------
// Resultados
// ---------------------------------------------------------------------------

const textoResultados =
    'O projeto está em andamento. Os resultados (teor proteico, umidade, '
    'estabilidade e segurança microbiológica do pó) serão publicados ao final '
    'das análises.';

// ---------------------------------------------------------------------------
// Metodologia
// ---------------------------------------------------------------------------

class Etapa {
  final IconData icone;
  final String titulo;
  final String descricao;
  const Etapa(this.icone, this.titulo, this.descricao);
}

const etapasMetodologia = [
  Etapa(
    Icons.house_siding_outlined,
    'Criação',
    'Recipientes plásticos, ambiente escuro, cerca de 25 °C em estufa; '
        'substrato de farinha de aveia; papel toalha e fatias de batata para '
        'manter a umidade, trocados pelo menos 3 vezes por semana para evitar '
        'contaminação.',
  ),
  Etapa(
    Icons.category_outlined,
    'Separação por fases',
    'Bandejas separadas para larvas, pupas e adultos; acompanhamento semanal '
        'de crescimento e reprodução.',
  ),
  Etapa(
    Icons.ac_unit,
    'Abate',
    'Refrigeração em geladeira para reduzir a atividade aos poucos, seguida '
        'de congelamento definitivo (método menos agressivo).',
  ),
  Etapa(
    Icons.local_fire_department_outlined,
    'Desidratação',
    'Bandejas metálicas em forno elétrico ou estufa de secagem, entre 60 °C e '
        '90 °C, até o material ficar seco. Foi escolhido um método de baixo '
        'custo, no lugar da liofilização, para ser viável em lugares com pouca '
        'infraestrutura.',
  ),
  Etapa(
    Icons.blender_outlined,
    'Trituração e peneiramento',
    'Moinho de facas ou triturador de alta rotação até virar um pó fino e '
        'homogêneo; peneiramento para padronizar a granulometria; '
        'armazenamento em recipientes esterilizados.',
  ),
  Etapa(
    Icons.biotech_outlined,
    'Análises',
    'Bromatológicas (teor proteico pelo método de Kjeldahl, umidade, '
        'composição nutricional); físico-químicas (estabilidade, conservação); '
        'microbiológicas (coliformes, fungos e bactérias aeróbias).',
  ),
];

// ---------------------------------------------------------------------------
// Cronograma (12 meses, de setembro a agosto)
// ---------------------------------------------------------------------------

const mesesCronograma = [
  'Set', 'Out', 'Nov', 'Dez', 'Jan', 'Fev', //
  'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago',
];

class AtividadeCronograma {
  final String atividade;

  /// Índices dos meses em [mesesCronograma] (0 = Set ... 11 = Ago).
  final Set<int> meses;
  const AtividadeCronograma(this.atividade, this.meses);
}

const cronograma = [
  AtividadeCronograma('Início da criação de *T. molitor*', {0, 1}),
  AtividadeCronograma(
    'Acompanhamento do desenvolvimento biológico e reprodução',
    {2, 3, 4, 5},
  ),
  AtividadeCronograma('Primeiros testes de desidratação das larvas', {4, 5}),
  AtividadeCronograma('Desenvolvimento do pó nutricional proteico', {5}),
  AtividadeCronograma('Padronização da formulação obtida', {5, 6}),
  AtividadeCronograma('Análises bromatológicas', {6, 7}),
  AtividadeCronograma('Análises microbiológicas', {7, 8}),
  AtividadeCronograma('Organização e interpretação dos resultados', {9, 10}),
  AtividadeCronograma('Revisão e ajustes experimentais', {10, 11}),
];

// ---------------------------------------------------------------------------
// Referências
// ---------------------------------------------------------------------------

class Referencia {
  /// Texto da referência; trechos entre *asteriscos* ficam em itálico.
  final String texto;
  final String? url;
  const Referencia(this.texto, {this.url});
}

const referencias = [
  Referencia(
    'Hong, J., Han, T. & Kim, Y.Y. (2020). Mealworm (*Tenebrio molitor* '
    'larvae) as an alternative protein source for monogastric animal: '
    'A review. *Animals* 10, 2068.',
  ),
  Referencia(
    'Marques, C.G., Silva, J.R., Almeida, L.P. & Santos, M.F. (2021). '
    'Proteínas alternativas como ingrediente de enriquecimento de alimentos: '
    'uma revisão da larva de tenébrio comum (*Tenebrio molitor*). '
    '*Ciências Agrárias: o avanço da ciência no Brasil* 2.',
  ),
  Referencia(
    'Matos, F.M. & Castro, R.J.S. (2021). Insetos comestíveis como potenciais '
    'fontes de proteínas para obtenção de peptídeos bioativos. '
    '*Brazilian Journal of Food Technology* 24, e2020044.',
  ),
  Referencia(
    'Nogueira Júnior, A., Santos, E.W., Miguel, T.L., Costa, A.A. & '
    'Dantas, J.O. (2023). O consumo de *Tenebrio molitor* no combate à fome. '
    '*Revista Multidisciplinar de Educação e Meio Ambiente* 4, 1-6.',
  ),
  Referencia(
    'Pedroso, M.A.P., Schardong, I.S., Jiménez, M.S.E., Boff, J.S., '
    'Bernardi, O. & Richards, N.S.P.S. (2022). Teor de proteína: '
    '*Tenebrio molitor* & *Chrysodeixis includens*. In *Open Science '
    'Research III* (pp. 337-351). Guarujá: Editora Científica Digital.',
  ),
  Referencia(
    'Varella, M. (2025). Qual a quantidade ideal de proteínas diárias? '
    'Disponível em: drauziovarella.uol.com.br.',
    url: 'https://drauziovarella.uol.com.br/alimentacao/qual-a-quantidade-ideal-de-proteinas-diarias/',
  ),
  Referencia(
    'Vieceli, D.A. (2023). Cadeia produtiva e sustentável do Tenébrio '
    'Molitor. TCC, Engenharia de Produção, UNISINOS.',
  ),
  Referencia(
    'Xavier, C. (2021). *Tenebrio molitor* como fonte alternativa de '
    'proteína. TCC, Engenharia de Alimentos, UFSC.',
  ),
];

// ---------------------------------------------------------------------------
// Avisos da calculadora
// ---------------------------------------------------------------------------

class TextosCalculadora {
  TextosCalculadora._();

  static const avisoProvisorio =
      'O teor proteico da farinha usado no cálculo (50 g/100 g) é uma '
      'estimativa provisória da literatura e será atualizado com os '
      'resultados das análises do projeto.';

  static const avisoFinal =
      'Esta calculadora compara apenas a quantidade de proteína. Ela não '
      'considera calorias, perfil de aminoácidos, digestibilidade, vitaminas '
      'ou minerais, e não substitui orientação de nutricionista ou médico. '
      'O produto está em fase de pesquisa e ainda não é destinado ao consumo.';

  static const pobreEmProteina =
      'Este alimento é pobre em proteína, então a substituição pela farinha é '
      'pequena e pode não fazer sentido do ponto de vista nutricional.';

  static const notaMl = 'Para líquidos, considera-se 1 ml ≈ 1 g.';

  static const fonteTabela =
      'Fonte: tabelas de composição de alimentos de referência';

  static const notaNecessidade =
      'Referência média para adultos sedentários: no mínimo 0,8 g de proteína '
      'por kg de peso corporal por dia (Varella, 2025). Crianças, gestantes, '
      'idosos e pessoas em recuperação nutricional podem ter necessidades diferentes.';
}
