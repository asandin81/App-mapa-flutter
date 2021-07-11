part of 'custom_markers.dart';

class MarkerDestinoPainter extends CustomPainter {
  final String destino;
  final double metros;

  MarkerDestinoPainter(this.destino, this.metros);
  @override
  void paint(Canvas canvas, Size size) {
    final double cirulaoNegroR = 20;
    final double cirulaoBlancoR = 7;
    Paint paint = new Paint()..color = Colors.black;

    // Dibunar circulo
    canvas.drawCircle(Offset(cirulaoNegroR, size.height - cirulaoNegroR),
        cirulaoNegroR, paint);
    paint.color = Colors.white;

    canvas.drawCircle(Offset(cirulaoNegroR, size.height - cirulaoNegroR),
        cirulaoBlancoR, paint);

    // Sombras
    final Path path = new Path();
    path.moveTo(0, 20);

    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);
    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar Textos
    double kilometros = this.metros / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100; // Asi se recuperan 2 decimales.
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
        text: '$kilometros');
    final textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(2, 35));

    TextSpan textSpanMin = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Km');
    final textPainterMin = new TextPainter(
        text: textSpanMin,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);
    textPainterMin.paint(canvas, Offset(20, 67));

    // Mi Ubicacion
    TextSpan textSpanUb = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        text: this.destino);
    final textPainterUb = new TextPainter(
        text: textSpanUb,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 100);
    textPainterUb.paint(canvas, Offset(90, 35));
  }

  @override
  bool shouldRepaint(MarkerDestinoPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerDestinoPainter oldDelegate) => false;
}
