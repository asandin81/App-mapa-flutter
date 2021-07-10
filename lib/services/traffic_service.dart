import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa/models/traffic_response.dart';

class TrafficService {
  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final baseUrl = 'https://api.mapbox.com/directions/v5';
  final apiKey =
      'pk.eyJ1IjoiYXNhbmRpbiIsImEiOiJja3F3YnY0cmMwN252MnZwbGY4Z3c3dmRzIn0.HTl2md_8EeJ_iDwZYSYQ2A';

  Future getCoordsInicioYFin(LatLng inicio, LatLng destino) async {
    print(inicio);
    print(destino);

    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';

    final url = '${this.baseUrl}/mapbox/driving/$coordString';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this.apiKey,
      'language': 'es',
    });

    final data = DrivingRespones.fromJson(resp.data);

    return data;
  }
}
