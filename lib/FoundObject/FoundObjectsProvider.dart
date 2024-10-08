import 'package:flutter/foundation.dart';
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;
  int offset = 0;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  final ApiService _apiService = ApiService();

  Future<void> fetchFoundObjects({
    String? gareOrigine,  // Peut-être une chaîne de gares séparées par des virgules
    String? category,
    String? nature,
    String? orderBy,
  }) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Appel à l'API avec pagination et filtres
      _foundObjects = await _apiService.fetchFoundObjects(
        city: gareOrigine,
        category: category,
        nature: nature,
        orderBy: orderBy,
        offset: offset,
      );
      offset += 50;  // Pagination
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshFoundObjects({
    String? gareOrigine,
    String? category,
    String? nature,
    String? orderBy,
  }) async {
    _foundObjects.clear();
    offset = 0;
    await fetchFoundObjects(
      gareOrigine: gareOrigine,
      category: category,
      nature: nature,
      orderBy: orderBy,
    );
  }
}
