import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoundObject.dart';

class ApiService {
  final String baseUrl = "https://data.sncf.com/api/explore/v2.1/catalog/datasets/";

  Future<List<FoundObject>> fetchFoundObjects() async {
    final response = await http.get(Uri.parse('${baseUrl}objets-trouves-restitution/records?limit=100' ));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((data) => FoundObject.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load found objects');
    }
  }
}
