import 'package:flutter/foundation.dart';
import 'ApiService.dart';
import 'FoundObject.dart';

class FoundObjectsProvider with ChangeNotifier {
  List<FoundObject> _foundObjects = [];
  List<FoundObject> get foundObjects => _foundObjects;

  final ApiService _apiService = ApiService();

  Future<void> fetchFoundObjects() async {
    _foundObjects = await _apiService.fetchFoundObjects();
    notifyListeners();
  }
}
