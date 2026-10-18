import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Área clicável que informa ao [builder] se está em hover ou com foco do
/// teclado, para as micro-interações (seta que avança, sublinhado que cresce).
class Interativo extends StatefulWidget {
  const Interativo({
    super.key,
    required this.aoTocar,
    required this.builder,
    this.link = true,
    this.rotuloSemantico,
    this.raio = 6,
  });

  final VoidCallback aoTocar;
  final Widget Function(BuildContext context, bool ativo) builder;
  final bool link;
  final String? rotuloSemantico;
  final double raio;

  @override
  State<Interativo> createState() => _InterativoState();
}

class _InterativoState extends State<Interativo> {
  bool _hover = false;
  bool _foco = false;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    return Semantics(
      link: widget.link,
      button: !widget.link,
      label: widget.rotuloSemantico,
      child: InkWell(
        onTap: widget.aoTocar,
        onHover: (v) => setState(() => _hover = v),
        onFocusChange: (v) => setState(() => _foco = v),
        borderRadius: BorderRadius.circular(widget.raio),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: m.destaque.withValues(alpha: 0.18),
        splashColor: m.destaque.withValues(alpha: 0.18),
        child: widget.builder(context, _hover || _foco),
      ),
    );
  }
}

Duration duracaoMicro(BuildContext context, [int ms = 220]) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : Duration(milliseconds: ms);

/// Link de texto com seta: no hover a seta avança e o sublinhado ocre cresce.
class LinkSeta extends StatelessWidget {
  const LinkSeta({
    super.key,
    required this.rotulo,
    required this.aoTocar,
    this.icone = Icons.arrow_forward,
    this.estilo,
  });

  final String rotulo;
  final VoidCallback aoTocar;
  final IconData icone;
  final TextStyle? estilo;

  @override
  Widget build(BuildContext context) {
    final m = context.marca;
    final estiloTexto =
        estilo ??
        Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 15);
    return Interativo(
      aoTocar: aoTocar,
      raio: 2,
      builder: (context, ativo) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flexible: em espaço apertado o texto quebra em vez de estourar.
            Flexible(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: ativo ? 1 : 0.3),
                duration: duracaoMicro(context, 280),
                curve: Curves.easeOutCubic,
                builder: (context, fracao, child) => CustomPaint(
                  foregroundPainter: _Sublinhado(fracao, m.destaque),
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(rotulo, style: estiloTexto),
                ),
              ),
            ),
            // A seta avança no hover; o espaço fica reservado (largura fixa),
            // então o movimento nunca muda o tamanho da linha.
            SizedBox(
              width: 32,
              child: AnimatedPadding(
                duration: duracaoMicro(context),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(left: ativo ? 12 : 6, top: 1),
                child: Icon(icone, size: 18, color: m.texto),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fio ocre sob o texto, com largura proporcional a [fracao].
class _Sublinhado extends CustomPainter {
  const _Sublinhado(this.fracao, this.cor);

  final double fracao;
  final Color cor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 2, size.width * fracao, 2),
      Paint()..color = cor,
    );
  }

  @override
  bool shouldRepaint(_Sublinhado antigo) =>
      antigo.fracao != fracao || antigo.cor != cor;
}

/// Botão principal (tinta) cuja seta avança no hover.
class BotaoSeta extends StatefulWidget {
  const BotaoSeta({
    super.key,
    required this.rotulo,
    required this.aoTocar,
    this.icone = Icons.arrow_forward,
  });

  final String rotulo;
  final VoidCallback? aoTocar;
  final IconData icone;

  @override
  State<BotaoSeta> createState() => _BotaoSetaState();
}

class _BotaoSetaState extends State<BotaoSeta> {
  bool _ativo = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.aoTocar,
      onHover: (v) => setState(() => _ativo = v),
      onFocusChange: (v) => setState(() => _ativo = v),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(widget.rotulo)),
          AnimatedPadding(
            duration: duracaoMicro(context),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(left: _ativo ? 16 : 10),
            child: Icon(widget.icone, size: 18),
          ),
        ],
      ),
    );
  }
}
