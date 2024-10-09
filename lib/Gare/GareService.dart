import 'dart:convert';
import 'package:http/http.dart' as http;

class GareService {
  // Limite d'éléments par requête (fixée à 100 dans votre API)
  final int _limit = 100;

  // Méthode pour récupérer toutes les gares avec pagination
  Future<List<String>> fetchAllGares() async {
    List<String> allGares = [];
    int offset = 0;  // Point de départ pour la pagination
    bool moreData = true;  // Indicateur pour savoir s'il reste des données à récupérer

    while (moreData) {
      final List<String> gares = await fetchGares(limit: _limit, offset: offset);
      print("Je fetch");
      if (gares.isNotEmpty) {
        allGares.addAll(gares);
        print("Offset '${offset}'");
        offset += _limit;  // Incrémenter l'offset pour récupérer les éléments suivants
      } else {
        moreData = false;  // S'il n'y a plus de données, on arrête la boucle
      }
    }

    return allGares;  // Retourner la liste complète des gares
  }

  // Méthode pour récupérer un seul lot de gares avec limit et offset
  Future<List<String>> fetchGares({int limit = 100, int offset = 0}) async {
    final String url =
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?select=gc_obo_gare_origine_r_name&group_by=gc_obo_gare_origine_r_name&order_by=gc_obo_gare_origine_r_name&limit=100&offset=${offset}';

    print("Requête envoyée à l'URL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['results'];

      // Extraire les noms des gares (gc_obo_gare_origine_r_name) de la réponse
      return results
          .map((item) =>
      item['gc_obo_gare_origine_r_name'] != null
          ? item['gc_obo_gare_origine_r_name'] as String
          : 'Nom de gare inconnu')
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des gares. Statut: ${response.statusCode}');
    }
  }
}
