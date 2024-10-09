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

  String _orderBy = 'date_desc';
  String? _gareOrigine;

  String get orderBy => _orderBy;
  String? get gareOrigine => _gareOrigine;

  final ApiService _apiService = ApiService();

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

  // Récupérer les objets en fonction de la catégorie
  Future<void> fetchFoundObjectsByCategory({
    required String type,  // Filtre sur le type d'objet (gc_obo_type_c)
    String? city,  // Filtre sur la ville
    String? orderBy,  // Tri par date
    int totalRecords = 1000,  // Nombre total d'enregistrements à récupérer
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
