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
    String? orderBy,  // Ajout du paramètre orderBy pour le tri
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{};

    // Vérifier et initialiser la clause 'where'
    if (city != null) {
      _addToWhereClause(queryParams, 'gc_obo_gare_origine_r_name = "${Uri.encodeComponent(city)}"');
    }

    if (category != null) {
      _addToWhereClause(queryParams, 'gc_obo_nature_c = "${Uri.encodeComponent(category)}"');
    }

    if (nature != null) {
      _addToWhereClause(queryParams, 'gc_obo_nature_c = "${Uri.encodeComponent(nature)}"');
    }

    if (nomRecordtypeSc != null) {
      _addToWhereClause(queryParams, 'gc_obo_nom_recordtype_sc_c = "${Uri.encodeComponent(nomRecordtypeSc)}"');
    }

    if (offset != null) {
      queryParams["offset"] = offset.toString();
    }

    if (orderBy != null) {
      queryParams["order_by"] = orderBy;  // Ajouter le tri si spécifié
    }

    print("Parametre de la requete: $queryParams");

    final uri = Uri.https(
      'data.sncf.com',
      '/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
      queryParams,
    );

    print("Requete: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      print(jsonResponse);
      return jsonResponse.map((data) => FoundObject.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load found objects');
    }
  }

  // Méthode pour ajouter une clause au paramètre 'where'
  void _addToWhereClause(Map<String, String> queryParams, String newCondition) {
    final whereClause = queryParams['where'] ?? '';
    if (whereClause.isNotEmpty) {
      queryParams['where'] = '$whereClause or $newCondition';
    } else {
      queryParams['where'] = newCondition;
    }
  }
}
