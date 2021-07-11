// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa/bloc/mapa/mapa_bloc.dart';
import 'package:mapa/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa/pages/loading_page.dart';
import 'package:mapa/pages/mapa_page.dart';
import 'package:mapa/pages/test_marker_page.dart';

import 'pages/acceso_gps_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
        BlocProvider(create: (_) => BusquedaBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingPage(),
        // home: TestMarkerPage(),
        routes: {
          'mapa': (_) => MapaPAge(),
          'loading': (_) => LoadingPage(),
          'acceso_gps': (_) => AccesoGpsPage(),
        },
      ),
    );
  }
}
