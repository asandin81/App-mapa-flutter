import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa/bloc/mapa/mapa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa/helpers/helpers.dart';
import 'package:mapa/models/search_result.dart';
import 'package:mapa/search/search_destination.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mapa/services/traffic_service.dart';
import 'package:polyline/polyline.dart' as Poly;

part 'btn_ubicacion.dart';
part 'btn_mi_ruta.dart';
part 'btn_seguir_ubicacion.dart';
part 'searchbar.dart';
part 'marcador_manual.dart';
