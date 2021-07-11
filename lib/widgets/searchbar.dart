part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(child: (buildSearchbar(context)));
        }
      },
    );
  }

  Widget buildSearchbar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        //width: double.infinity, // Ocupa todo el ancho
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width,

        child: GestureDetector(
          onTap: () async {
            print('Buscando....');
            final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
            final historial = context.read<BusquedaBloc>().state.historial;
            print('historial: $historial');
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad!, historial));
            this.retornoBusqueda(context, resultado!);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text(
              'Donde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    print('cancelo: ${result.cancelo}');
    print('manual: ${result.manual}');
    if (result.cancelo) return;
    if (result.manual == true) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }
    // Calcular la ruta segun la direccion que ha pulsado.
    final trafficService = new TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;

    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio!, destino!);
    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();
    mapaBloc.add(OnCrearRutaDestino(
        rutaCoordenadas, distancia, duracion, nombreDestino!));
    //Navigator.of(context).pop();

    // Agregamos el historial de busquedas.
    context.read<BusquedaBloc>().add(OnAgregarHistorial(result));
  }
}
