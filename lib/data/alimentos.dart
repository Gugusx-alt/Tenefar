// Base de dados dos alimentos da calculadora.
//
// Valores em gramas de proteína por 100 g (ou por 100 ml, quando
// `unidade: Unidade.ml`). Fonte: tabelas de composição de alimentos de
// referência.
//
// COMO ADICIONAR UM ALIMENTO: copie uma linha da mesma categoria, dê um `id`
// único (minúsculas, sem acento, com hífens), ajuste nome, proteína e, se
// houver, a porção caseira. O teste `test/calculadora_test.dart` verifica se
// os ids são únicos e se nenhum valor é negativo.

import '../models/alimento.dart';

/// Nomes das categorias, na ordem em que aparecem nos filtros.
class Categorias {
  Categorias._();

  static const carnes = 'Carnes e aves';
  static const peixes = 'Peixes e frutos do mar';
  static const ovosLaticinios = 'Ovos e laticínios';
  static const leguminosas = 'Leguminosas e soja';
  static const oleaginosas = 'Oleaginosas';
  static const verduras = 'Verduras e legumes';
  static const frutas = 'Frutas';
  static const cereais = 'Cereais e outros';
  static const suplementos = 'Suplementos';

  static const todas = [
    carnes,
    peixes,
    ovosLaticinios,
    leguminosas,
    oleaginosas,
    verduras,
    frutas,
    cereais,
    suplementos,
  ];
}

const List<Alimento> alimentos = [
  // ----- Carnes e aves -----
  Alimento(
    id: 'carne-bovina-acem-moido-cozido',
    nome: 'Carne bovina, acém moído cozido',
    categoria: Categorias.carnes,
    proteinaPor100g: 26.7,
    porcao: Porcao('5 colheres de sopa', 90),
  ),
  Alimento(
    id: 'carne-bovina-file-mignon-grelhado',
    nome: 'Carne bovina, filé mignon grelhado',
    categoria: Categorias.carnes,
    proteinaPor100g: 32.8,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'carne-bovina-lagarto',
    nome: 'Carne bovina, lagarto',
    categoria: Categorias.carnes,
    proteinaPor100g: 32.9,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'carne-porco-lombo-assado',
    nome: 'Carne de porco, lombo assado',
    categoria: Categorias.carnes,
    proteinaPor100g: 35.7,
    porcao: Porcao('1 fatia', 100),
  ),
  Alimento(
    id: 'carne-porco-pernil-assado',
    nome: 'Carne de porco, pernil assado',
    categoria: Categorias.carnes,
    proteinaPor100g: 32.1,
    porcao: Porcao('1 fatia', 100),
  ),
  Alimento(
    id: 'file-porco-magro',
    nome: 'Filé de porco magro',
    categoria: Categorias.carnes,
    proteinaPor100g: 21.4,
  ),
  Alimento(
    id: 'frango-coxa-sem-pele-cozida',
    nome: 'Frango, coxa sem pele cozida',
    categoria: Categorias.carnes,
    proteinaPor100g: 26.9,
    porcao: Porcao('1 coxa grande', 100),
  ),
  Alimento(
    id: 'frango-peito-grelhado',
    nome: 'Frango, peito grelhado',
    categoria: Categorias.carnes,
    proteinaPor100g: 32,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'frango-sobrecoxa-sem-pele-cozida',
    nome: 'Frango, sobrecoxa sem pele cozida',
    categoria: Categorias.carnes,
    proteinaPor100g: 29.2,
    porcao: Porcao('1 sobrecoxa grande', 100),
  ),
  Alimento(
    id: 'peito-peru-sem-pele',
    nome: 'Peito de peru sem pele',
    categoria: Categorias.carnes,
    proteinaPor100g: 29.9,
  ),
  Alimento(
    id: 'peru-blanquet',
    nome: 'Peru, blanquet',
    categoria: Categorias.carnes,
    proteinaPor100g: 16,
    porcao: Porcao('6 fatias', 60),
  ),
  Alimento(
    id: 'peru-peito-defumado',
    nome: 'Peru, peito defumado',
    categoria: Categorias.carnes,
    proteinaPor100g: 21.7,
    porcao: Porcao('4 fatias', 60),
  ),

  // ----- Peixes e frutos do mar -----
  Alimento(
    id: 'peixe-abadejo-cozido',
    nome: 'Peixe, abadejo cozido',
    categoria: Categorias.peixes,
    proteinaPor100g: 19.3,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'peixe-atum-em-agua',
    nome: 'Peixe, atum em água',
    categoria: Categorias.peixes,
    proteinaPor100g: 25,
    porcao: Porcao('½ lata', 85),
  ),
  Alimento(
    id: 'peixe-bacalhau-cozido',
    nome: 'Peixe, bacalhau cozido',
    categoria: Categorias.peixes,
    proteinaPor100g: 24,
    porcao: Porcao('1 pedaço médio', 135),
  ),
  Alimento(
    id: 'peixe-cacao-cozido',
    nome: 'Peixe, cação cozido',
    categoria: Categorias.peixes,
    proteinaPor100g: 25.6,
    porcao: Porcao('1 posta', 100),
  ),
  Alimento(
    id: 'peixe-merluza-assada',
    nome: 'Peixe, merluza assada',
    categoria: Categorias.peixes,
    proteinaPor100g: 26.6,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'peixe-salmao-sem-pele-grelhado',
    nome: 'Peixe, salmão sem pele grelhado',
    categoria: Categorias.peixes,
    proteinaPor100g: 26.1,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'peixe-sardinha-em-oleo',
    nome: 'Peixe, sardinha em óleo',
    categoria: Categorias.peixes,
    proteinaPor100g: 15.9,
    porcao: Porcao('1 filé', 100),
  ),
  Alimento(
    id: 'camarao',
    nome: 'Camarão',
    categoria: Categorias.peixes,
    proteinaPor100g: 24.5,
    porcao: Porcao('1 porção', 80),
  ),

  // ----- Ovos e laticínios -----
  Alimento(
    id: 'ovo-inteiro-cozido',
    nome: 'Ovo inteiro cozido',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 13.3,
    porcao: Porcao('1 unidade', 45),
  ),
  Alimento(
    id: 'ovo-clara-cozida',
    nome: 'Ovo, clara cozida',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 13.9,
    porcao: Porcao('1 clara', 25),
  ),
  Alimento(
    id: 'iogurte-desnatado',
    nome: 'Iogurte desnatado',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 3.8,
    unidade: Unidade.ml,
    porcao: Porcao('1 pote', 180),
  ),
  Alimento(
    id: 'leite-vaca-desnatado',
    nome: 'Leite de vaca desnatado',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 3.26,
    unidade: Unidade.ml,
    porcao: Porcao('1 copo', 240),
  ),
  Alimento(
    id: 'leite-semidesnatado',
    nome: 'Leite semidesnatado',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 3.4,
    unidade: Unidade.ml,
    porcao: Porcao('1 copo', 240),
  ),
  Alimento(
    id: 'leite-fermentado',
    nome: 'Leite fermentado',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 1.9,
    unidade: Unidade.ml,
    porcao: Porcao('1 unidade', 100),
  ),
  Alimento(
    id: 'queijo-minas-frescal',
    nome: 'Queijo minas frescal',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 17.4,
    porcao: Porcao('1 fatia grande', 40),
  ),
  Alimento(
    id: 'queijo-cottage',
    nome: 'Queijo cottage',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 15.6,
    porcao: Porcao('2 colheres de sopa', 50),
  ),
  Alimento(
    id: 'queijo-mucarela-bufala',
    nome: 'Queijo muçarela de búfala',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 22,
    porcao: Porcao('2 fatias', 30),
  ),
  Alimento(
    id: 'queijo-ricota',
    nome: 'Queijo ricota',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 12.6,
    porcao: Porcao('1 fatia grande', 40),
  ),
  Alimento(
    id: 'requeijao-light',
    nome: 'Requeijão light',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 5.66,
    porcao: Porcao('2 colheres de sopa', 30),
  ),
  Alimento(
    id: 'requeijao-sem-gordura',
    nome: 'Requeijão sem gordura',
    categoria: Categorias.ovosLaticinios,
    proteinaPor100g: 13.3,
  ),

  // ----- Leguminosas e soja -----
  Alimento(
    id: 'ervilha-enlatada',
    nome: 'Ervilha enlatada',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 4.6,
    porcao: Porcao('2 colheres de sopa', 60),
  ),
  Alimento(
    id: 'ervilha-fresca',
    nome: 'Ervilha fresca',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 7.5,
  ),
  Alimento(
    id: 'feijao-carioca-cozido',
    nome: 'Feijão carioca cozido',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 4.8,
    porcao: Porcao('2 colheres de sopa', 50),
  ),
  Alimento(
    id: 'lentilha-cozida',
    nome: 'Lentilha cozida',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 6.3,
    porcao: Porcao('2 colheres de sopa', 50),
  ),
  Alimento(
    id: 'soja-bebida',
    nome: 'Soja, bebida',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 2.6,
    unidade: Unidade.ml,
    porcao: Porcao('1 copo', 200),
  ),
  Alimento(
    id: 'soja-tofu',
    nome: 'Soja, tofu',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 6.6,
    porcao: Porcao('2 fatias grossas', 50),
  ),
  Alimento(
    id: 'pasta-soja',
    nome: 'Pasta de soja',
    categoria: Categorias.leguminosas,
    proteinaPor100g: 1,
    porcao: Porcao('1 colher de sopa', 10),
  ),

  // ----- Oleaginosas -----
  Alimento(
    id: 'amendoa',
    nome: 'Amêndoa',
    categoria: Categorias.oleaginosas,
    proteinaPor100g: 18.6,
    porcao: Porcao('5 unidades', 12),
  ),
  Alimento(
    id: 'amendoim',
    nome: 'Amendoim',
    categoria: Categorias.oleaginosas,
    proteinaPor100g: 22.5,
    porcao: Porcao('1 colher de sobremesa', 12),
  ),
  Alimento(
    id: 'castanha-caju',
    nome: 'Castanha de caju',
    categoria: Categorias.oleaginosas,
    proteinaPor100g: 18.5,
    porcao: Porcao('5 unidades', 12),
  ),
  Alimento(
    id: 'castanha-do-para',
    nome: 'Castanha-do-pará',
    categoria: Categorias.oleaginosas,
    proteinaPor100g: 14.5,
    porcao: Porcao('2 unidades', 12),
  ),
  Alimento(
    id: 'nozes',
    nome: 'Nozes',
    categoria: Categorias.oleaginosas,
    proteinaPor100g: 14,
    porcao: Porcao('1 noz inteira', 12),
  ),

  // ----- Verduras e legumes -----
  Alimento(
    id: 'abobora',
    nome: 'Abóbora',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.7,
  ),
  Alimento(
    id: 'abobrinha',
    nome: 'Abobrinha',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.1,
  ),
  Alimento(
    id: 'acelga',
    nome: 'Acelga',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.4,
  ),
  Alimento(
    id: 'agriao-cru',
    nome: 'Agrião cru',
    categoria: Categorias.verduras,
    proteinaPor100g: 3.0,
  ),
  Alimento(
    id: 'aipo',
    nome: 'Aipo',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.8,
  ),
  Alimento(
    id: 'alcachofra',
    nome: 'Alcachofra',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.6,
  ),
  Alimento(
    id: 'alface-crespa',
    nome: 'Alface crespa',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.3,
  ),
  Alimento(
    id: 'alfafa',
    nome: 'Alfafa',
    categoria: Categorias.verduras,
    proteinaPor100g: 6.6,
  ),
  Alimento(
    id: 'alho',
    nome: 'Alho',
    categoria: Categorias.verduras,
    proteinaPor100g: 7.0,
  ),
  Alimento(
    id: 'alho-poro',
    nome: 'Alho-poró',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.4,
  ),
  Alimento(
    id: 'almeirao',
    nome: 'Almeirão',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.8,
  ),
  Alimento(
    id: 'araruta',
    nome: 'Araruta',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.0,
  ),
  Alimento(
    id: 'batata-doce',
    nome: 'Batata-doce',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.3,
  ),
  Alimento(
    id: 'batata-inglesa',
    nome: 'Batata inglesa',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.0,
  ),
  Alimento(
    id: 'berinjela',
    nome: 'Berinjela',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.2,
  ),
  Alimento(
    id: 'beterraba',
    nome: 'Beterraba',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.9,
  ),
  Alimento(
    id: 'brocolis',
    nome: 'Brócolis',
    categoria: Categorias.verduras,
    proteinaPor100g: 3.6,
  ),
  Alimento(
    id: 'cara',
    nome: 'Cará',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.3,
  ),
  Alimento(
    id: 'cebola',
    nome: 'Cebola',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.7,
  ),
  Alimento(
    id: 'cenoura',
    nome: 'Cenoura',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.3,
  ),
  Alimento(
    id: 'chuchu',
    nome: 'Chuchu',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.7,
  ),
  Alimento(
    id: 'couve-manteiga',
    nome: 'Couve-manteiga',
    categoria: Categorias.verduras,
    proteinaPor100g: 3.0,
  ),
  Alimento(
    id: 'couve-flor',
    nome: 'Couve-flor',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.9,
  ),
  Alimento(
    id: 'escarola',
    nome: 'Escarola',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.3,
  ),
  Alimento(
    id: 'espinafre',
    nome: 'Espinafre',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.0,
  ),
  Alimento(
    id: 'gengibre',
    nome: 'Gengibre',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.8,
  ),
  Alimento(
    id: 'inhame',
    nome: 'Inhame',
    categoria: Categorias.verduras,
    proteinaPor100g: 2.1,
  ),
  Alimento(
    id: 'maca-peruana',
    nome: 'Maca peruana',
    categoria: Categorias.verduras,
    proteinaPor100g: 10.0,
  ),
  Alimento(
    id: 'mandioca',
    nome: 'Mandioca',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.1,
  ),
  Alimento(
    id: 'mandioca-cozida',
    nome: 'Mandioca cozida',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.6,
  ),
  Alimento(
    id: 'mandioca-frita',
    nome: 'Mandioca frita',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.2,
  ),
  Alimento(
    id: 'mandioquinha',
    nome: 'Mandioquinha',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.0,
  ),
  Alimento(
    id: 'nabo',
    nome: 'Nabo',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.2,
  ),
  Alimento(
    id: 'pepino',
    nome: 'Pepino',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.9,
  ),
  Alimento(
    id: 'pimentao',
    nome: 'Pimentão',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.0,
  ),
  Alimento(
    id: 'quiabo',
    nome: 'Quiabo',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.9,
  ),
  Alimento(
    id: 'rabanete',
    nome: 'Rabanete',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.4,
  ),
  Alimento(
    id: 'repolho-branco',
    nome: 'Repolho branco',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.9,
  ),
  Alimento(
    id: 'rucula',
    nome: 'Rúcula',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.8,
  ),
  Alimento(
    id: 'tomate',
    nome: 'Tomate',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.1,
  ),
  Alimento(
    id: 'vagem',
    nome: 'Vagem',
    categoria: Categorias.verduras,
    proteinaPor100g: 1.8,
  ),
  Alimento(
    id: 'yacon',
    nome: 'Yacon',
    categoria: Categorias.verduras,
    proteinaPor100g: 0.8,
  ),

  // ----- Frutas -----
  Alimento(
    id: 'abacate',
    nome: 'Abacate',
    categoria: Categorias.frutas,
    proteinaPor100g: 1.8,
  ),
  Alimento(
    id: 'abacaxi',
    nome: 'Abacaxi',
    categoria: Categorias.frutas,
    proteinaPor100g: 0.4,
  ),
  Alimento(
    id: 'acai',
    nome: 'Açaí',
    categoria: Categorias.frutas,
    proteinaPor100g: 3.8,
  ),
  Alimento(
    id: 'ameixa-seca',
    nome: 'Ameixa seca',
    categoria: Categorias.frutas,
    proteinaPor100g: 2.37,
  ),
  Alimento(
    id: 'ameixa-passa',
    nome: 'Ameixa-passa',
    categoria: Categorias.frutas,
    proteinaPor100g: 2.3,
  ),
  Alimento(
    id: 'amora',
    nome: 'Amora',
    categoria: Categorias.frutas,
    proteinaPor100g: 1.2,
  ),

  // ----- Cereais e outros -----
  Alimento(
    id: 'arroz-branco-cru',
    nome: 'Arroz branco cru',
    categoria: Categorias.cereais,
    proteinaPor100g: 7.2,
  ),
  Alimento(
    id: 'arroz-branco-cozido',
    nome: 'Arroz branco cozido',
    categoria: Categorias.cereais,
    proteinaPor100g: 2.3,
  ),
  Alimento(
    id: 'arroz-integral-cru',
    nome: 'Arroz integral cru',
    categoria: Categorias.cereais,
    proteinaPor100g: 8.06,
  ),
  Alimento(
    id: 'achocolatado-em-po',
    nome: 'Achocolatado em pó',
    categoria: Categorias.cereais,
    proteinaPor100g: 3.0,
  ),
  Alimento(
    id: 'acucar-mascavo',
    nome: 'Açúcar mascavo',
    categoria: Categorias.cereais,
    proteinaPor100g: 0.4,
  ),
  Alimento(
    id: 'amido-de-milho',
    nome: 'Amido de milho',
    categoria: Categorias.cereais,
    proteinaPor100g: 0.6,
  ),

  // ----- Suplementos -----
  Alimento(
    id: 'barra-proteina',
    nome: 'Barra de proteína',
    categoria: Categorias.suplementos,
    proteinaPor100g: 33.3,
    porcao: Porcao('1 unidade', 30),
  ),
  Alimento(
    id: 'whey-protein',
    nome: 'Whey protein',
    categoria: Categorias.suplementos,
    proteinaPor100g: 83.33,
    porcao: Porcao('1 a 2 medidas', 30),
  ),
];
