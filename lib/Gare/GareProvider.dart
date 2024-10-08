import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GareProvider with ChangeNotifier {
  List<String> _gares = [];
  List<String> _selectedGares = [];  // Liste des gares sélectionnées
  bool _isLoading = false;           // Indicateur de chargement
  bool _hasError = false;            // Indicateur d'erreur

  List<String> get gares => _gares;
  List<String> get selectedGares => _selectedGares;  // Accéder aux gares sélectionnées
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
      // Appel API pour récupérer les gares
      final response = await http.get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?select=gc_obo_gare_origine_r_name&limit=100&offset=0&groupby=gc_obo_gare_origine_r_name'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> gares = (data['results'] as List).map((item) => item['gc_obo_gare_origine_r_name'].toString()).toList();

        _gares = gares; // Stocker les gares récupérées
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();  // Notifier l'interface utilisateur
  }
}
