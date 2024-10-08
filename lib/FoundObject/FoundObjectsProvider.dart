import 'package:flutter/foundation.dart';
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  // Storing the current sort order and filters
  String _orderBy = 'date';  // Default to ascending
  String? _gareOrigine;  // Filter by station

  String get orderBy => _orderBy;
  String? get gareOrigine => _gareOrigine;

  final ApiService _apiService = ApiService();

  // Function to set sorting order and notify listeners
  void setOrderBy(String orderBy) {
    _orderBy = orderBy;
    notifyListeners();
  }

  // Function to set station filter and notify listeners
  void setGareOrigine(String? gare) {
    _gareOrigine = gare;
    notifyListeners();
  }

  Future<void> refreshFoundObjects() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      _foundObjects = await _apiService.fetchFoundObjects(
        city: _gareOrigine,
        orderBy: _orderBy,
      );
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
