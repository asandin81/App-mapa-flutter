import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa/bloc/mapa/mapa_bloc.dart';

import 'package:mapa/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa/widgets/widgets.dart';

class MapaPAge extends StatefulWidget {
  @override
  _MapaPAgeState createState() => _MapaPAgeState();
}

class _MapaPAgeState extends State<MapaPAge> {
  @override
  void initState() {
    // Ahora se utiliza read y no bloc
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: (context, state) => crearMapa(state),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion(),
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if ((!state.existeUbicacion)) return Center(child: Text('Ubicando....'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final cameraPosition =
        new CameraPosition(target: state.ubicacion!, zoom: 15);
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) =>
          mapaBloc.initMapa(controller),
    );
  }
}
