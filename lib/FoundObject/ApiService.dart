import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoundObject.dart';

class ApiService {
  final String baseUrl = "https://data.sncf.com/api/explore/v2.1/catalog/datasets/";

  Future<List<FoundObject>> fetchFoundObjects({
    String? city,
    String? category,
    String? nature,
    String? nomRecordtypeSc,
    String? orderBy,  // Sorting by date (asc/desc)
    int totalRecords = 100, // Nombre total d'enregistrements à récupérer
  }) async {
    List<FoundObject> allObjects = [];
    int limit = 100;
    int offset = 0;

    // Boucle pour paginer jusqu'à atteindre le nombre total d'enregistrements désirés
    while (allObjects.length < totalRecords) {
      final queryParams = <String, String>{};

      if (city != null) {
        _addToWhereClause(queryParams, 'gc_obo_gare_origine_r_name = "${Uri.encodeComponent(city)}"');
      }

      if (category != null) {
        _addToWhereClause(queryParams, 'gc_obo_nature_c = "${Uri.encodeComponent(category)}"');
      }

      if (orderBy != null) {
        queryParams["order_by"] = orderBy;
      }

      // Ajouter la limite et l'offset pour la pagination
      queryParams['limit'] = '$limit';
      queryParams['offset'] = '$offset';

      final uri = Uri.https(
        'data.sncf.com',
        '/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
        queryParams,
      );
      print(uri);
      final response = await http.get(uri);
      print(response.body);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<FoundObject> fetchedObjects = jsonResponse.map((data) => FoundObject.fromJson(data)).toList();

        allObjects.addAll(fetchedObjects); // Ajoute les objets récupérés à la liste totale

        // Si moins de 100 résultats sont retournés, cela signifie que nous avons atteint la fin
        if (fetchedObjects.length < limit) {
          break; // Sortir de la boucle si moins de 100 résultats
        }

        offset += limit; // Incrémente l'offset de 100 pour la prochaine requête
      } else {
        throw Exception('Failed to load found objects');
      }
    }

    return allObjects; // Retourner la liste complète des objets
  }


  void _addToWhereClause(Map<String, String> queryParams, String newCondition) {
    final whereClause = queryParams['where'] ?? '';
    queryParams['where'] = whereClause.isNotEmpty ? '$whereClause or $newCondition' : newCondition;
  }
}
