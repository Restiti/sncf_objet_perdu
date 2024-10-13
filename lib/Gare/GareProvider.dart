import 'package:flutter/foundation.dart';
import 'GareService.dart';

class GareProvider with ChangeNotifier {
  List<String> _gares = [];
  Set<String> _selectedGares = {};  // Utilisation d'un Set pour éviter les doublons
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  final GareService _gareService = GareService();

  List<String> get gares => _gares;
  Set<String> get selectedGares => _selectedGares;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  // Ajouter ou supprimer une gare de la liste sélectionnée
  void toggleGareSelection(String gare) {
    if (_selectedGares.contains(gare)) {
      _selectedGares.remove(gare);
    } else {
      _selectedGares.add(gare);
    }
    notifyListeners();
  }

  // Récupérer toutes les gares disponibles et s'assurer de leur unicité
  Future<void> fetchGares() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();  // Notifier au début du chargement

    try {
      List<String> allGares = await _gareService.fetchAllGares();
      // Utilisation d'un Set pour supprimer les doublons
      _gares = allGares.toSet().toList();  // Convertir en List pour l'utilisation dans l'UI
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();  // Stocker un message d'erreur
    } finally {
      _isLoading = false;
      notifyListeners();  // Notifier à la fin du processus
    }
  }
}
