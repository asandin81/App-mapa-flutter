part of 'custom_markers.dart';

class MarkerInicioPainter extends CustomPainter {
  final int minutos;

  MarkerInicioPainter(this.minutos);
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
    path.moveTo(40, 20);

    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(cajaBlanca, paint);
    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar Textos
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: '$minutos');
    final textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(40, 35));

    TextSpan textSpanMin = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Min');
    final textPainterMin = new TextPainter(
        text: textSpanMin,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainterMin.paint(canvas, Offset(40, 67));

    // Mi Ubicacion
    TextSpan textSpanUb = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        text: 'Mi Ubicacion');
    final textPainterUb = new TextPainter(
        text: textSpanUb,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);
    textPainterUb.paint(canvas, Offset(150, 50));
  }

  @override
  bool shouldRepaint(MarkerInicioPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerInicioPainter oldDelegate) => false;
}
