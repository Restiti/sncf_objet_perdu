
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

  List<String> getUniqueGcOboGareOrigineRNames() {
    return _foundObjects.map((foundObject) => foundObject.gcOboGareOrigineRName).toSet().toList();
  }

  List<String> getUniquegcOboNatureC() {
    return _foundObjects.map((foundObject) => foundObject.gcOboNatureC).toSet().toList();
  }

  List<String> getUniquegcOboNomRecordtypeScC() {
    return _foundObjects.map((foundObject) => foundObject.gcOboNomRecordtypeScC).toSet().toList();
  }
  List<String> getUniquegcOboTypeC() {
    return _foundObjects.map((foundObject) => foundObject.gcOboTypeC).toSet().toList();
  }



}
