import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  int _limit =100;
  String _orderBy = 'date_desc';
  String? _gareOrigine;

  String get orderBy => _orderBy;
  String? get gareOrigine => _gareOrigine;

  List<String> _types = [];
  List<String> get types => _types;

  String? _type;

  final ApiService _apiService = ApiService();

  void setType(String? type) {
    _type = type;
    notifyListeners();
  }

  Future<List<String>> fetchTypes({int limit = 100, int offset = 0}) async {
    final String url =
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?select=gc_obo_type_c&group_by=gc_obo_type_c&order_by=gc_obo_type_c&limit=100&offset=${offset}';

    print("Requête envoyée à l'URL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['results'];

      // Extraire les types (gc_obo_type_c) de la réponse
      _types = results
          .map((item) =>
      item['gc_obo_type_c'] != null
          ? item['gc_obo_type_c'] as String
          : 'Type inconnu')
          .toList();

      notifyListeners(); // Informer les widgets écoutant cette classe de la mise à jour

      return _types;
    } else {
      throw Exception('Erreur lors de la récupération des types. Statut: ${response.statusCode}');
    }
  }




  // Fonction pour changer l'ordre de tri
  void setOrderBy(String orderBy) {
    _orderBy = orderBy;
    notifyListeners();
    refreshFoundObjects();  // Recharger les objets avec le nouveau tri
  }

  // Fonction pour définir la gare d'origine à filtrer
  void setGareOrigine(String? gare) {
    _gareOrigine = gare;
    notifyListeners();
    refreshFoundObjects();  // Recharger les objets avec le filtre de gare
  }

  // Récupérer les objets avec tri et filtres sans le filtre sur la catégorie
  Future<void> refreshFoundObjects() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Charger les objets sans le filtre sur la catégorie
      _foundObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        type: _type,
        orderBy: _orderBy == 'date_desc' ? '-date' : 'date',
        totalRecords: 100,
      );
      print("Refrsh _foundObjects${foundObjects}");
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Récupérer les objets en fonction de la catégorie
  Future<void> fetchFoundObjectsByCategory({
    required String type,  // Filtre sur le type d'objet (gc_obo_type_c)
    String? city,  // Filtre sur la ville
    String? orderBy,  // Tri par date
    int totalRecords = 100,  // Nombre total d'enregistrements à récupérer
  }) async {
    print("Je fetch par catégorie");
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Charger les objets avec le filtre sur la catégorie
      List<FoundObject> allObjects = await _apiService.fetchFoundObjects(
        city: city,
        type: type,  // Application du filtre sur la catégorie ici
        orderBy: orderBy,
        totalRecords: totalRecords,
      );

      // Mise à jour de la variable foundObjects après récupération
      _foundObjects = allObjects;
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Regrouper les objets par type
  Map<String, List<FoundObject>> get objectsByType {
    Map<String, List<FoundObject>> groupedObjects = {};
    for (var object in _foundObjects) {
      if (!groupedObjects.containsKey(object.gcOboTypeC)) {
        groupedObjects[object.gcOboTypeC] = [];
      }
      groupedObjects[object.gcOboTypeC]!.add(object);
    }
    return groupedObjects;
  }

}
