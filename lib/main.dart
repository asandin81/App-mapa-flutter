import 'package:flutter/material.dart';
import 'package:mapa/pages/loading_page.dart';
import 'package:mapa/pages/mapa_page.dart';

import 'pages/acceso_gps_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoadingPage(),
      routes: {
        'mapa': (_) => MapaPAge(),
        'loading': (_) => LoadingPage(),
        'acceso_gps': (_) => AccesoGpsPage(),
      },
    );
  }
}
