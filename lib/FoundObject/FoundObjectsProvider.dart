import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;  // Ajout de l'import pour http
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  String _orderBy = 'date_desc';
  String? _gareOrigine;

  String get orderBy => _orderBy;
  String? get gareOrigine => _gareOrigine;

  final ApiService _apiService = ApiService();

  // Fonction pour changer l'ordre de tri
  void setOrderBy(String orderBy) {
    _orderBy = orderBy;
    notifyListeners();
    refreshFoundObjects();
  }

  // Fonction pour définir la gare d'origine à filtrer
  void setGareOrigine(String? gare) {
    _gareOrigine = gare;
    notifyListeners();
    refreshFoundObjects();
  }

  // Récupérer les objets avec tri et filtres
  Future<void> refreshFoundObjects() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      _foundObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        orderBy: _orderBy == 'date_desc' ? '-date' : 'date',
        totalRecords: 100,
      );
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
  Future<List<FoundObject>> fetchFoundObjects({
    String? city,  // Filtre sur la ville (gc_obo_gare_origine_r_name)
    String? type,  // Filtre sur le type d'objet (gc_obo_type_c)
    String? orderBy,  // Tri par date (asc/desc)
    int totalRecords = 1000,  // Par défaut, récupérer 1000 enregistrements
  }) async {
    List<FoundObject> allObjects = [];
    int limit = 100;  // Limite toujours à 100 pour l'API
    int offset = 0;

    while (allObjects.length < totalRecords) {
      final queryParams = <String, String>{};

      // Ajout du filtre sur la ville et le type d'objet dans la clause where
      if (city != null && type != null) {
        // Utilisation des guillemets simples pour la clause where
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



  // Ajouter la méthode _addToWhereClause ici
  void _addToWhereClause(Map<String, String> queryParams, String newCondition) {
    final whereClause = queryParams['where'] ?? '';
    queryParams['where'] = whereClause.isNotEmpty ? '$whereClause or $newCondition' : newCondition;
  }
}
