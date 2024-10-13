import 'dart:convert';
import 'package:http/http.dart' as http;

class GareService {
  // Limite d'éléments par requête (fixée à 100 dans l'API)
  final int _limit = 100;
  static const String _baseUrl = 'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  static const String _gareField = 'gc_obo_gare_origine_r_name';

  // Méthode pour récupérer toutes les gares avec pagination
  Future<List<String>> fetchAllGares() async {
    List<String> allGares = [];
    int offset = 0; // Point de départ pour la pagination
    bool moreData = true; // Indicateur pour savoir s'il reste des données à récupérer

    while (moreData) {
      try {
        final List<String> gares = await fetchGares(limit: _limit, offset: offset);
        if (gares.isNotEmpty) {
          allGares.addAll(gares);
          offset += _limit; // Incrémenter l'offset pour récupérer les éléments suivants
        } else {
          moreData = false; // Si pas de données, on arrête la boucle
        }
      } catch (e) {
        print('Erreur lors de la récupération des gares : $e');
        moreData = false; // Arrêter la boucle si une erreur survient
      }
    }

    return allGares;
  }

  // Méthode pour récupérer un seul lot de gares avec limit et offset
  Future<List<String>> fetchGares({int limit = 100, int offset = 0}) async {
    final Uri uri = Uri.parse('$_baseUrl?select=$_gareField&group_by=$_gareField&order_by=$_gareField&limit=$limit&offset=$offset');

    print("Requête envoyée à l'URL: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['results'];

      // Extraire les noms des gares
      return results
          .where((item) => item[_gareField] != null)
          .map<String>((item) => item[_gareField] as String)
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des gares. Statut: ${response.statusCode}');
    }
  }
}
