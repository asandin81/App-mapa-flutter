import 'package:flutter/material.dart';
import 'package:mapa/custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          // color: Colors.red,
          child: CustomPaint(
            painter: MarkerDestinoPainter(
                'Carrer Orense 33, Sant Cugat del Valles, Barcelona, 08195, España',
                100000),
          ),
        ),
      ),
    );
  }
}
