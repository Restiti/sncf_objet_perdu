import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoundObject.dart';

class ApiService {
  final String baseUrl = "https://data.sncf.com/api/explore/v2.1/catalog/datasets/";

  Future<List<FoundObject>> fetchFoundObjects({String? city, String? category, String? nature, String? nomRecordtypeSc, String? orderBy, int? limit}) async {
    final queryParams = <String, String>{};

    if (city != null) {
      final encodedCity = Uri.encodeComponent(city);
      final whereClause = queryParams['where'] ?? '';
      queryParams['where'] = '$whereClause${whereClause.isEmpty ? '' : ' and '}gc_obo_gare_origine_r_name = "$encodedCity"';
    }

    if (category != null) {
      final encodedCategory = Uri.encodeComponent(category);
      final whereClause = queryParams['where'] ?? '';
      queryParams['where'] = '$whereClause${whereClause.isEmpty ? '' : ' and '}gc_obo_nature_c = "$encodedCategory"';
    }

    if (nature != null) {
      final encodedNature = Uri.encodeComponent(nature);
      final whereClause = queryParams['where'] ?? '';
      queryParams['where'] = '$whereClause${whereClause.isEmpty ? '' : ' and '}gc_obo_nature_c = "$encodedNature"';
    }

    if (nomRecordtypeSc != null) {
      final encodedNomRecordtypeSc = Uri.encodeComponent(nomRecordtypeSc);
      final whereClause = queryParams['where'] ?? '';
      queryParams['where'] = '$whereClause${whereClause.isEmpty ? '' : ' and '}gc_obo_nom_recordtype_sc_c = "$encodedNomRecordtypeSc"';
    }
    print("Parametre de la requete ${queryParams}");
    final uri = Uri.https(
      'data.sncf.com',
      '/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
      queryParams,
    );
    print("Requete ${uri}");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      print(jsonResponse);
      return jsonResponse.map((data) => FoundObject.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load found objects');
    }
  }
}
