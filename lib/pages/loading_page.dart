import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapa/helpers/helpers.dart';
import 'package:mapa/pages/acceso_gps_page.dart';
import 'package:mapa/pages/mapa_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, MapaPAge()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: this.checkGpsYLocation(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Future checkGpsYLocation(BuildContext context) async {
    //TODO: PremisoGPS
    final permsisoGPS = await Permission.location.isGranted;
    //TODO: GPS Activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (permsisoGPS && gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, MapaPAge()));
      return '';
    } else if (!permsisoGPS) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGpsPage()));
      return 'Es necesario el permiso del GPS.';
    } else if (!gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGpsPage()));
      return 'Es necesario que active el gps';
    }
  }
}
