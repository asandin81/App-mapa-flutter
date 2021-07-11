import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/material.dart' show Offset;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa/helpers/helpers.dart';
import 'package:mapa/themes/uber_map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  // Controlador del mapa
  GoogleMapController? _mapController;

  //Polylines
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);

  //Polylines
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('mi_ruta_destino'),
      width: 4,
      color: Colors.black87);
  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;

      // Cambiar estilo mapa
      this._mapController!.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaListo());
    }
  }

  void moverCamar(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      if (state.seguirUbicacion) {
        moverCamar(event.ubicacion);
      }
      yield* _onNuevaUbicacion(
          event); // Yield* porque el metodo devuelve un yield - hay que ponerlo para que funcione.
    } else if (event is OnMarcarRecorrido) {
      yield* _onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* _onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearRutaDestino) {
      yield* _onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    final List<LatLng> points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, // El opuesto de true o false
        polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamar(this._miRuta.points[this._miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(OnCrearRutaDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    // Icono inicio
    // final iconInicio = await getAssetImageMarker();

    double km = event.distancia / 1000;
    km = (km * 100).floor().toDouble();
    km = km / 100;

    final iconInicio = await getMarkerInicioIcon(event.duracion.toInt());
    final iconoDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distancia);

    // Marcadores
    final markerInicio = new Marker(
      anchor: Offset(0.1, 0.9),
      markerId: MarkerId('inicio'),
      position: event.rutaCoordenadas[0],
      icon: iconInicio,
      // infoWindow: InfoWindow(
      //     title: event.nombreDestino,
      //     snippet:
      //         'Duracion recorrido: ${(event.duracion / 60).floor()} minutos')
    ); // floor para redondear los segundos

    final markerDestino = new Marker(
      anchor: Offset(0.1, 0.9),
      markerId: MarkerId('destino'),
      position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1],
      icon: iconoDestino,
      // infoWindow: InfoWindow(
      //     title: event.nombreDestino, snippet: 'Distancia: $km Km')
    );
    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerDestino;

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      // _mapController!.showMarkerInfoWindow(MarkerId('inicio'));
      //_mapController!.showMarkerInfoWindow(MarkerId('destino'));
    });
    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}
