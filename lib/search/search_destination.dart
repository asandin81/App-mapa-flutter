import 'package:flutter/material.dart';
import 'package:mapa/models/search_result.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;

  SearchDestination() : this.searchFieldLabel = 'Buscar';
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
    return Text('Build Result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Muestra las sugerencias
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
      ],
    );
  }
}
