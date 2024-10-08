import 'package:flutter/foundation.dart';
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  // Trier par défaut par date décroissante
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

  // Récupérer les objets avec tri et filtres
  Future<void> refreshFoundObjects() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      _foundObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        orderBy: _orderBy == 'date_desc' ? '-date' : 'date',
        totalRecords: 100, // Récupérer 1000 enregistrements
      );
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Regrouper les objets par type (gcOboTypeC)
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
