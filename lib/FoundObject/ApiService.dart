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
    int? limit,
    int? offset,
  }) async {
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

    final uri = Uri.https(
      'data.sncf.com',
      '/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
      queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((data) => FoundObject.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load found objects');
    }
  }

  void _addToWhereClause(Map<String, String> queryParams, String newCondition) {
    final whereClause = queryParams['where'] ?? '';
    queryParams['where'] = whereClause.isNotEmpty ? '$whereClause or $newCondition' : newCondition;
  }
}
