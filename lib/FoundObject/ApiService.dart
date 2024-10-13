import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoundObject.dart';

class ApiService {
  final String baseUrl = "https://data.sncf.com/api/explore/v2.1/catalog/datasets/";


  Future<List<FoundObject>> fetchFoundObjects({
    String? city,  // Filtre sur la ville (gc_obo_gare_origine_r_name)
    String? type,  // Filtre sur le type d'objet (gc_obo_type_c)
    DateTime? startDate, // Nouveau paramètre pour filtrer par date de début
    String? orderBy,  // Tri par date (asc/desc)
    int totalRecords = 1000,  // Par défaut, récupérer 1000 enregistrements
  }) async {
    List<FoundObject> allObjects = [];
    int limit = 100;  // Limite toujours à 100 pour l'API
    int offset = 0;

    startDate = DateTime(startDate!.year, startDate.month, startDate.day);

    while (allObjects.length < totalRecords) {
      final queryParams = <String, String>{};

      if (city != null && type != null && startDate != null) {
        queryParams['where'] = "gc_obo_gare_origine_r_name = '$city' and gc_obo_type_c = '$type' and date >= '${startDate.toIso8601String()}'";
      } else if (city != null && startDate != null) {
        queryParams['where'] = "gc_obo_gare_origine_r_name = '$city' and date >= '${startDate.toIso8601String()}'";
      } else if (type != null && startDate != null) {
        queryParams['where'] = "gc_obo_type_c = '$type' and date >= '${startDate.toIso8601String()}'";
      } else if (startDate != null) {
        queryParams['where'] = "date >= '${startDate.toIso8601String()}'";
      } else if (city != null && type != null) {
        queryParams['where'] = "gc_obo_gare_origine_r_name = '$city' and gc_obo_type_c = '$type'";
      } else if (city != null) {
        queryParams['where'] = "gc_obo_gare_origine_r_name = '$city'";
      } else if (type != null) {
        queryParams['where'] = "gc_obo_type_c = '$type'";
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

      print(uri);  // Pour vérifier l'URL générée

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<FoundObject> fetchedObjects = jsonResponse.map((data) => FoundObject.fromJson(data)).toList();

        allObjects.addAll(fetchedObjects);

        // Si moins de 100 résultats sont retournés, cela signifie que nous avons atteint la fin
        if (fetchedObjects.length < limit) {
          break; // Sortir de la boucle si moins de 100 résultats
        }

        offset += limit; // Incrémente l'offset de 100 pour la prochaine requête

        // Arrêter lorsque 1000 enregistrements ont été récupérés
        if (offset >= totalRecords) {
          break;
        }
      } else {
        throw Exception('Failed to load found objects');
      }
    }

    return allObjects;
  }

}
