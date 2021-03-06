import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa/models/search_response.dart';
import 'package:mapa/models/search_result.dart';
import 'package:mapa/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;
  final List<SearchResult>? historial;

  SearchDestination(this.proximidad, this.historial)
      : this.searchFieldLabel = 'Buscar',
        this._trafficService = new TrafficService();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            this.query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final searchResult = SearchResult(cancelo: true);
    return IconButton(
        onPressed: () {
          this.close(context, searchResult);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Resultado

    this._trafficService.getResultadosPorQuery(this.query.trim(), proximidad);
    return this._construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Muestra las sugerencias
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manualmente'),
            onTap: () {
              print('Manualmente');
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          ),
          ...this
              .historial!
              .map((result) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(result.nombreDestino!),
                    subtitle: Text(result.descripcion!),
                    onTap: () {
                      this.close(context, result);
                    },
                  ))
              .toList()
        ],
      );
    } else {
      return this._construirResultadosSugerencias();
    }
  }

  Widget _construirResultadosSugerencias() {
    if (this.query == 0) {
      return Container();
    }
    this
        ._trafficService
        .getSugerenciasPorQuery(this.query.trim(), this.proximidad);
    return StreamBuilder(
      stream: this._trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final lugares = snapshot.data!.features;
        if (lugares!.length == 0) {
          return ListTile(
            title: Text('No hay resultados.'),
          );
        }

        return ListView.separated(
            itemBuilder: (_, i) {
              final lugar = lugares[i];
              return ListTile(
                leading: Icon(Icons.place),
                title: Text(lugar.textEs!),
                subtitle: Text(lugar.placeNameEs!),
                onTap: () {
                  this.close(
                      context,
                      SearchResult(
                          cancelo: false,
                          manual: false,
                          position: LatLng(lugar.center![1], lugar.center![0]),
                          nombreDestino: lugar.textEs,
                          descripcion: lugar.placeNameEs));
                },
              );
            },
            separatorBuilder: (_, i) => Divider(),
            itemCount: lugares.length);
      },
    );
  }
}
