import 'package:flutter_test/flutter_test.dart';
import 'package:tenebrio_app/app/config.dart';
import 'package:tenebrio_app/data/alimentos.dart';
import 'package:tenebrio_app/logic/calculadora.dart';
import 'package:tenebrio_app/logic/formatacao.dart';
import 'package:tenebrio_app/models/alimento.dart';

void main() {
  Alimento porId(String id) => alimentos.firstWhere((a) => a.id == id);

  group('proteinaDoAlimento e farinhaNecessaria', () {
    test(
      '100 g de peito de frango grelhado → 32 g de proteína → 64 g de farinha',
      () {
        final frango = porId('frango-peito-grelhado');
        expect(frango.proteinaPor100g, 32);
        final proteina = proteinaDoAlimento(100, frango.proteinaPor100g);
        expect(proteina, closeTo(32, 1e-9));
        expect(farinhaNecessaria(proteina), closeTo(64, 1e-9));
      },
    );

    test('1 ovo inteiro (45 g × 13,3%) → ≈ 5,99 g de proteína → ≈ 12,0 g de farinha', () {
      final ovo = porId('ovo-inteiro-cozido');
      final proteina = proteinaDoAlimento(
        ovo.porcao!.gramas,
        ovo.proteinaPor100g,
      );
      expect(proteina, closeTo(5.985, 1e-9));
      final farinha = farinhaNecessaria(proteina);
      expect(farinha, closeTo(11.97, 1e-9));
      expect(formatarNumero(farinha), '12,0');
    });

    test('quantidade 0 → 0 g', () {
      expect(proteinaDoAlimento(0, 32), 0);
      expect(farinhaNecessaria(proteinaDoAlimento(0, 32)), 0);
    });

    test('usa o teor da farinha definido em Config por padrão', () {
      expect(
        farinhaNecessaria(Config.proteinaFarinhaPor100g),
        closeTo(100, 1e-9),
      );
      expect(farinhaNecessaria(10, teorFarinhaPor100g: 20), closeTo(50, 1e-9));
    });
  });

  test('70 kg × 0,8 = 56 g de proteína/dia → 112 g de farinha', () {
    final proteina = proteinaDiaria(70);
    expect(proteina, closeTo(56, 1e-9));
    expect(farinhaNecessaria(proteina), closeTo(112, 1e-9));
  });

  group('normalizar e busca', () {
    test("normalizar('Feijão') == normalizar('feijao')", () {
      expect(normalizar('Feijão'), normalizar('feijao'));
      expect(normalizar('  AÇAÍ '), 'acai');
    });

    test('"feijao" encontra "Feijão carioca cozido"', () {
      final r = filtrarAlimentos(alimentos, 'feijao');
      expect(r.map((a) => a.nome), contains('Feijão carioca cozido'));
    });

    test('filtro de categoria restringe o resultado', () {
      final r = filtrarAlimentos(
        alimentos,
        '',
        categorias: {Categorias.suplementos},
      );
      expect(
        r.map((a) => a.id),
        unorderedEquals(['barra-proteina', 'whey-protein']),
      );
    });
  });

  group('base de alimentos', () {
    test('nenhum alimento tem proteína negativa', () {
      for (final a in alimentos) {
        expect(a.proteinaPor100g, greaterThanOrEqualTo(0), reason: a.nome);
      }
    });

    test('todos os ids são únicos', () {
      final ids = alimentos.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('todas as categorias usadas existem nos filtros', () {
      for (final a in alimentos) {
        expect(Categorias.todas, contains(a.categoria), reason: a.nome);
      }
    });
  });

  group('validação e leitura de números', () {
    test('aceita vírgula ou ponto', () {
      expect(lerNumero('1,5'), 1.5);
      expect(lerNumero('1.5'), 1.5);
      expect(lerNumero('1,2,3'), isNull);
    });

    test('vazio, negativo e acima do máximo geram erro; zero é aceito', () {
      expect(validarQuantidade('').erro, isNotNull);
      expect(validarQuantidade('-3').erro, isNotNull);
      expect(validarQuantidade('abc').erro, isNotNull);
      expect(validarQuantidade('5001').erro, isNotNull);
      expect(validarQuantidade('5000').valor, 5000);
      expect(validarQuantidade('0').valor, 0);
      // 60 porções de 100 g = 6000 g > máximo
      expect(validarQuantidade('60', gramasPorUnidade: 100).erro, isNotNull);
    });

    test('peso precisa ser maior que zero', () {
      expect(validarPeso('0').erro, isNotNull);
      expect(validarPeso('70').valor, 70);
    });

    test('formatação brasileira com 1 casa', () {
      expect(formatarNumero(1234.56), '1.234,6');
      expect(formatarGramas(64), '64,0 g');
      expect(formatarParaCampo(1500), '1500');
    });
  });
}
