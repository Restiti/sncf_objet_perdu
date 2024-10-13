import 'package:flutter/foundation.dart';
import 'GareService.dart';

class GareProvider with ChangeNotifier {
  List<String> _gares = [];
  List<String> _selectedGares = [];
  bool _isLoading = false;
  bool _hasError = false;
  final GareService _gareService = GareService();

  List<String> get gares => _gares;
  List<String> get selectedGares => _selectedGares;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // Add or remove a station from the selected list
  void toggleGareSelection(String gare) {
    if (_selectedGares.contains(gare)) {
      _selectedGares.remove(gare);
    } else {
      _selectedGares.add(gare);
    }
    notifyListeners();
  }

  // Fetch all available stations and ensure uniqueness
  Future<void> fetchGares() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      List<String> allGares = await _gareService.fetchAllGares();
      print("In fetchGares: ${allGares}");
      // Utilisation d'un Set pour supprimer les doublons
      Set<String> uniqueGares = allGares.toSet();
      _gares = uniqueGares.toList();  // Convertir en List pour l'utilisation dans l'UI
      print("After In fetchGares: ${allGares}");

    } catch (e) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}
