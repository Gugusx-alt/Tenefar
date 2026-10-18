import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'data/conteudo_projeto.dart';
import 'state/calculadora_controller.dart';

void main() {
  // URLs limpas na web (/calculadora em vez de /#/calculadora).
  // No Android não tem efeito.
  usePathUrlStrategy();
  runApp(const TenebrioApp());
}

class TenebrioApp extends StatefulWidget {
  const TenebrioApp({
    super.key,
    this.rotaInicial = Rotas.inicio,
    this.usarGoogleFonts = true,
  });

  final String rotaInicial;

  /// Nos testes as fontes do Google ficam desligadas (não há rede).
  final bool usarGoogleFonts;

  @override
  State<TenebrioApp> createState() => _TenebrioAppState();
}

class _TenebrioAppState extends State<TenebrioApp> {
  late final GoRouter _router = criarRouter(rotaInicial: widget.rotaInicial);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculadoraController(),
      child: MaterialApp.router(
        title: InfoProjeto.nomeCurto,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.claro(usarGoogleFonts: widget.usarGoogleFonts),
        darkTheme: AppTheme.escuro(usarGoogleFonts: widget.usarGoogleFonts),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: _router,
      ),
    );
  }
}
