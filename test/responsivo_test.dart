import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenebrio_app/app/router.dart';
import 'package:tenebrio_app/main.dart';

/// Monta todas as páginas em 360, 768 e 1280 px de largura. Qualquer overflow
/// (faixa amarela e preta) faz o teste falhar.
void main() {
  const larguras = [360.0, 768.0, 1280.0];
  const rotas = [
    Rotas.inicio,
    Rotas.projeto,
    Rotas.metodologia,
    Rotas.calculadora,
    Rotas.equipe,
    Rotas.referencias,
    '/pagina-que-nao-existe',
  ];

  for (final largura in larguras) {
    for (final rota in rotas) {
      testWidgets('$rota em ${largura.toInt()} px sem overflow', (
        tester,
      ) async {
        tester.view.physicalSize = Size(largura, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          TenebrioApp(rotaInicial: rota, usarGoogleFonts: false),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(Scaffold), findsOneWidget);
      });
    }
  }

  testWidgets(
    'aba "Necessidade diária": 70 kg → 56,0 g de proteína e 112,0 g de farinha',
    (tester) async {
      tester.view.physicalSize = const Size(360, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const TenebrioApp(
          rotaInicial: Rotas.calculadora,
          usarGoogleFonts: false,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Necessidade diária'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('campo-peso')), '70');
      await tester.pumpAndSettle();
      expect(find.text('56,0 g'), findsOneWidget);
      expect(find.text('112,0 g'), findsOneWidget);
    },
  );
}
