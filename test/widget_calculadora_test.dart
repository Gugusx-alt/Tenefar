import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenebrio_app/app/router.dart';
import 'package:tenebrio_app/main.dart';

void main() {
  testWidgets(
    'buscar "frango", escolher o peito grelhado e digitar 100 → 64,0 g',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const TenebrioApp(
          rotaInicial: Rotas.calculadora,
          usarGoogleFonts: false,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('campo-busca-alimento')),
        'frango',
      );
      await tester.pumpAndSettle();

      final opcao = find.text('Frango, peito grelhado');
      expect(opcao, findsOneWidget);
      await tester.tap(opcao);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('campo-quantidade')), '100');
      await tester.pumpAndSettle();

      expect(find.text('64,0 g'), findsWidgets);
      expect(find.text('32,0 g'), findsWidgets); // proteína contida

      // Adicionar à refeição soma os totais.
      await tester.tap(find.text('Adicionar à refeição'));
      await tester.pumpAndSettle();
      expect(find.text('Total de proteína'), findsOneWidget);
    },
  );

  testWidgets('quantidade negativa mostra mensagem de erro', (tester) async {
    tester.view.physicalSize = const Size(1280, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const TenebrioApp(rotaInicial: Rotas.calculadora, usarGoogleFonts: false),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('campo-busca-alimento')),
      'feijao',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feijão carioca cozido'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('campo-quantidade')), '-5');
    await tester.pumpAndSettle();
    expect(find.text('A quantidade não pode ser negativa.'), findsOneWidget);
  });

  testWidgets('em 360 px: resultado, porções, refeição e menu sem overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const TenebrioApp(rotaInicial: Rotas.calculadora, usarGoogleFonts: false),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('campo-busca-alimento')),
      'ovo inteiro',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ovo inteiro cozido'));
    await tester.pumpAndSettle();

    // 1 porção (1 unidade = 45 g) → 12,0 g de farinha
    await tester.tap(find.text('porções'));
    await tester.pumpAndSettle();
    // Os 100 g pré-preenchidos são convertidos em porções (100 / 45).
    expect(find.text('2,22'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('campo-quantidade')), '1');
    await tester.pumpAndSettle();
    expect(find.text('12,0 g'), findsWidgets);

    await tester.tap(find.text('Adicionar à refeição'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 × 1 unidade'), findsOneWidget);

    await tester.tap(find.byTooltip('Abrir menu de navegação'));
    await tester.pumpAndSettle();
    expect(find.text('Referências'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
