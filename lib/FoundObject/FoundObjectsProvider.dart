import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ApiService.dart';
import 'FoundObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  Map<String, List<FoundObject>> _objectsByType = {};

  List<FoundObject> get foundObjects => _foundObjects;
  Map<String, List<FoundObject>> get objectsByType => _objectsByType;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  int _limit = 100;
  String _orderBy = 'date_desc';
  String? _gareOrigine;
  String? _type;

  List<String> _types = [];
  List<String> get types => _types;

  final ApiService _apiService = ApiService();

  String get orderBy => _orderBy;
  String? get gareOrigine => _gareOrigine;

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
  }

  // Fonction pour définir le type de filtre
  void setType(String? type) {
    _type = type;
    notifyListeners();
  }

  Future<void> refreshFoundObjects() async {
    isLoading = true;
    hasError = false;
    _foundObjects = [];
    _objectsByType = {};  // Réinitialiser objectsByType avant le rafraîchissement
    notifyListeners();
    print("Je rafraîchis les objets trouvés");

    try {
      // Récupérer la date de la dernière actualisation depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final lastRefreshDateString = prefs.getString('lastRefreshDate');
      DateTime lastRefreshDate;

      // Si aucune date n'a été trouvée, définir une date par défaut (hier)
      if (lastRefreshDateString == null) {
        lastRefreshDate = DateTime.now().subtract(Duration(days: 1));
      } else {
        lastRefreshDate = DateTime.parse(lastRefreshDateString);
      }

      print("Dernière date d'actualisation: $lastRefreshDate");

      // Récupérer les objets trouvés depuis la dernière actualisation
      List<FoundObject> objectsSinceLastRefresh = await fetchFoundObjectsSinceDate(lastRefreshDate);

      // Charger les objets filtrés à partir du 1er janvier de l'année en cours
      DateTime startDate = DateTime(DateTime.now().year, 1, 1);
      List<FoundObject> allObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        type: _type,
        startDate: startDate,
        orderBy: _orderBy == 'date_desc' ? '-date' : 'date',
        totalRecords: 100,
      );

      // Regrouper les objets par type
      _objectsByType = _groupObjectsByType(allObjects);

      // Ajouter la catégorie "Depuis la dernière fois" avec les objets trouvés récemment
      if (objectsSinceLastRefresh.isNotEmpty) {
        // On s'assure que "Depuis la dernière fois" est ajouté en premier
        _objectsByType = {
          'Depuis la dernière fois': objectsSinceLastRefresh,
          ..._objectsByType,  // Ajout des autres catégories
        };
      }

      // Mettre à jour la date de dernière actualisation dans SharedPreferences
      await prefs.setString('lastRefreshDate', DateTime.now().toIso8601String());

      // Stocker tous les objets trouvés dans _foundObjects
      _foundObjects = _objectsByType.values.expand((x) => x).toList();

      print("Objets trouvés après rafraîchissement: $_foundObjects");
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
      print("Erreur lors du rafraîchissement des objets trouvés: $error");
    }

    isLoading = false;
    notifyListeners();
  }


  // Méthode pour regrouper les objets par type
  Map<String, List<FoundObject>> _groupObjectsByType(List<FoundObject> objects) {
    Map<String, List<FoundObject>> groupedObjects = {};
    for (var object in objects) {
      if (!groupedObjects.containsKey(object.gcOboTypeC)) {
        groupedObjects[object.gcOboTypeC] = [];
      }
      groupedObjects[object.gcOboTypeC]!.add(object);
    }
    return groupedObjects;
  }

  Future<List<FoundObject>> fetchFoundObjectsSinceDate(DateTime startDate) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Charger les objets à partir de la date spécifiée
      List<FoundObject> allObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        type: _type,
        startDate: startDate,
        orderBy: _orderBy == 'date_desc' ? '-date' : 'date',
        totalRecords: 100,
      );
      return allObjects;
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Récupérer les objets en fonction de la catégorie
  Future<void> fetchFoundObjectsByCategory({
    required String type,  // Filtre sur le type d'objet (gc_obo_type_c)
    String? city,  // Filtre sur la ville
    String? orderBy,  // Tri par date
    int totalRecords = 100,  // Nombre total d'enregistrements à récupérer
  }) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      DateTime startDate = DateTime(DateTime.now().year, 1, 1); // 1er janvier de l'année en cours
      // Charger les objets avec le filtre sur la catégorie
      List<FoundObject> allObjects = await _apiService.fetchFoundObjects(
        city: city,
        type: type,  // Application du filtre sur la catégorie ici
        startDate: startDate,
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
}


