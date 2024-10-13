import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoundObject.dart';

class ApiService {
  final String baseUrl = "https://data.sncf.com/api/explore/v2.1/catalog/datasets/";

  Future<List<FoundObject>> fetchFoundObjects({
    String? city,  // Filtre sur la ville
    String? type,  // Filtre sur le type d'objet
    DateTime? startDate, // Nouveau paramètre pour filtrer par date de début
    String? orderBy,  // Tri par date (asc/desc)
    int totalRecords = 1000,  // Par défaut, récupérer 1000 enregistrements
  }) async {
    List<FoundObject> allObjects = [];
    int limit = 100;  // Limite à 100 pour l'API
    int offset = 0;

    // Si `startDate` est fourni, ajuster au format de la date
    String? formattedDate;
    if (startDate != null) {
      formattedDate = DateTime(startDate.year, startDate.month, startDate.day).toIso8601String();
    }

    while (allObjects.length < totalRecords) {
      final queryParams = <String, String>{};

      // Construction de la clause "where"
      String whereClause = '';
      if (city != null) whereClause += "gc_obo_gare_origine_r_name = '$city'";
      if (type != null) {
        if (whereClause.isNotEmpty) whereClause += " and ";
        whereClause += "gc_obo_type_c = '$type'";
      }
      if (formattedDate != null) {
        if (whereClause.isNotEmpty) whereClause += " and ";
        whereClause += "date >= '$formattedDate'";
      }

      if (whereClause.isNotEmpty) {
        queryParams['where'] = whereClause;
      }

      // Ajouter le paramètre de tri si fourni
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

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<FoundObject> fetchedObjects = jsonResponse.map((data) => FoundObject.fromJson(data)).toList();

        allObjects.addAll(fetchedObjects);

        // Si moins de 100 résultats sont retournés, cela signifie que nous avons atteint la fin
        if (fetchedObjects.length < limit) {
          break;
        }

        offset += limit; // Incrémente l'offset pour la prochaine requête

        // Arrêter lorsque le nombre total d'enregistrements est atteint
        if (allObjects.length >= totalRecords) {
          break;
        }
      } else {
        throw Exception('Failed to load found objects');
      }
    }

    return allObjects;
  }
}
