import 'package:flutter/foundation.dart';

import 'GareService.dart';

class GareProvider with ChangeNotifier {
  List<String> _gares = [];
  List<String> _selectedGares = [];
  bool _isLoading = false;
  bool _hasError = false;
  final GareService _gareService = GareService();  // Utiliser le service

  List<String> get gares => _gares;
  List<String> get selectedGares => _selectedGares;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // Ajouter ou retirer une gare de la sélection
  void toggleGareSelection(String gare) {
    if (_selectedGares.contains(gare)) {
      _selectedGares.remove(gare);
    } else {
      _selectedGares.add(gare);
    }
    notifyListeners();
  }

  // Méthode pour charger les gares
  Future<void> fetchGares() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Appel au service pour récupérer les gares
      _gares = await _gareService.fetchGares();
    } catch (e) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}
