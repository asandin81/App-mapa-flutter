part of 'helpers.dart';

Future<BitmapDescriptor> getMarkerInicioIcon(int segundos) async {
  final recorder = new ui.PictureRecorder();
  final canvas = new ui.Canvas(recorder);

  final size = new ui.Size(350, 150);

  final minutos = (segundos / 60).floor();

  final markerInicio = new MarkerInicioPainter(minutos);
  markerInicio.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteDate = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteDate!.buffer.asUint8List());
}

Future<BitmapDescriptor> getMarkerDestinoIcon(
    String destino, double kilometros) async {
  final recorder = new ui.PictureRecorder();
  final canvas = new ui.Canvas(recorder);

  final size = new ui.Size(350, 150);

  final markerDestino = new MarkerDestinoPainter(destino, kilometros);
  markerDestino.paint(canvas, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteDate = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteDate!.buffer.asUint8List());
}
