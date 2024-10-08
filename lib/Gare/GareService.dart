import 'dart:convert';
import 'package:http/http.dart' as http;

class GareService {
  // Méthode pour récupérer la liste des gares avec l'URL spécifique
  Future<List<String>> fetchGares({int limit = 100, int offset = 0}) async {
    final String url = 'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?select=gc_obo_gare_origine_r_name&limit=$limit&offset=$offset&groupby=gc_obo_gare_origine_r_name';

    print("Requête envoyée à l'URL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['results'];

      // Extraire les noms des gares (gc_obo_gare_origine_r_name) de la réponse
      return results.map((item) => item['gc_obo_gare_origine_r_name'] as String).toList();
    } else {
      throw Exception('Erreur lors de la récupération des gares. Statut: ${response.statusCode}');
    }
  }
}
