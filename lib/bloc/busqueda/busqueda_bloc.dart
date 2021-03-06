// @dart=2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapa/models/search_result.dart';
import 'package:meta/meta.dart';

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState());

  @override
  Stream<BusquedaState> mapEventToState(
    BusquedaEvent event,
  ) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: true);
      print('Estoy aqui');
      print(state.seleccionManual);
    } else if (event is OnDesactivarMarcadorManual) {
      yield state.copyWith(seleccionManual: false);
      print(state.seleccionManual);
    } else if (event is OnAgregarHistorial) {
      final existe = state.historial
          .where(
              (element) => element.nombreDestino == event.result.nombreDestino)
          .length;
      if (existe == 0) {
        print('historial: $existe');
        final newHistorial = [...state.historial, event.result];
        yield state.copyWith(historial: newHistorial);
      }
    }
  }
}
