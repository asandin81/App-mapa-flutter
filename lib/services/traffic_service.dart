import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa/helpers/debouncer.dart';
import 'package:mapa/models/search_response.dart';
import 'package:mapa/models/traffic_response.dart';

class TrafficService {
  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final StreamController<SearchResponse> _sugerenciasStreamController =
      new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciasStream =>
      this._sugerenciasStreamController.stream;

  final baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final apiKey =
      'pk.eyJ1IjoiYXNhbmRpbiIsImEiOiJja3F3YnY0cmMwN252MnZwbGY4Z3c3dmRzIn0.HTl2md_8EeJ_iDwZYSYQ2A';

  Future getCoordsInicioYFin(LatLng inicio, LatLng destino) async {
    print(inicio);
    print(destino);

    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';

    final url = '${this.baseUrlDir}/mapbox/driving/$coordString';

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

  Future<SearchResponse> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    final url = '${this.baseUrlGeo}/mapbox.places/$busqueda.json';

    try {
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this.apiKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });

      final data = searchResponseFromJson(resp.data);
      return data;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

// funcion Debaucer para no hacer muchas peticiones a autocompletar direccion.
  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultadosPorQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }
}
