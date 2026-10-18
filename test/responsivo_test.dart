import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenebrio_app/app/router.dart';
import 'package:tenebrio_app/main.dart';
import 'package:tenebrio_app/widgets/interacao.dart';

/// Monta todas as páginas em 360, 768 e 1280 px de largura. Qualquer overflow
/// (faixa amarela e preta) faz o teste falhar.
void main() {
  const larguras = [360.0, 768.0, 1280.0];
  const rotas = [
    Rotas.inicio,
    Rotas.projeto,
    Rotas.metodologia,
    Rotas.calculadora,
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

  // Hover nos links com seta (micro-interação) em larguras "apertadas" de
  // desktop: a seta que avança não pode estourar a linha.
  for (final largura in [900.0, 1000.0, 1100.0, 1440.0]) {
    testWidgets('hover nos links em ${largura.toInt()} px sem overflow', (
      tester,
    ) async {
      tester.view.physicalSize = Size(largura, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const TenebrioApp(rotaInicial: Rotas.inicio, usarGoogleFonts: false),
      );
      await tester.pumpAndSettle();

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      for (final link in find.byType(LinkSeta).evaluate().toList()) {
        await mouse.moveTo(tester.getCenter(find.byWidget(link.widget)));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }
}
