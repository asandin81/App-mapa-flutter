import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as _geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  StreamSubscription<_geolocator.Position>? _positionSubscription;

  void iniciarSeguimiento() async {
    /// Las opciones ahora estan dentreo del Stream
    // final geoLocationOptions = _geolocator.LocationOptions(
    //     accuracy: _geolocator.LocationAccuracy.high, distanceFilter: 10);
    _positionSubscription = await _geolocator.Geolocator.getPositionStream(
            desiredAccuracy: _geolocator.LocationAccuracy.high,
            distanceFilter: 10)
        .listen((_geolocator.Position position) {
      final nuevaUbicacion = new LatLng(position.latitude, position.longitude);
      print(position);
      add(OnUbicacionCambio(nuevaUbicacion));
    });

    //
  }

  void cancelarSeguimiento() {
    this._positionSubscription!.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(
    MiUbicacionEvent event,
  ) async* {
    if (event is OnUbicacionCambio) {
      print(event);
      yield state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion);
    }
  }
}
