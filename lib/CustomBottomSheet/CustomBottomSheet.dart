import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/SearchProvider.dart';
import '../utils/MySearchBar.dart';

class CustomBottomSheet {
  final List<String> gareSuggestions;

  CustomBottomSheet({required this.gareSuggestions});

  void show(BuildContext context, String type) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            color: Colors.amber,
            child: Column(
              children: <Widget>[
                Text(type == 'tri' ? 'Options de tri' : 'Options de filtre'),
                ElevatedButton(
                  child: const Text('Fermer'),
                  onPressed: () => Navigator.pop(context),
                ),
                if (type == 'filtre')
                  Expanded(
                    child: Consumer<GareProvider>(
                      builder: (context, gareProvider, child) {
                        return Column(
                          children: [
                            // Barre de recherche avec cases à cocher dans la liste déroulante
                            ChangeNotifierProvider(
                              create: (_) => SearchProvider()..setSuggestions(gareSuggestions),
                              child: MySearchBar(
                                suggestions: gareSuggestions,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Appliquer les filtres en appelant l'API avec les gares sélectionnées
                                Provider.of<FoundObjectsProvider>(context, listen: false).refreshFoundObjects(
                                  gareOrigine: gareProvider.selectedGares.isNotEmpty
                                      ? gareProvider.selectedGares.join(',')
                                      : null,
                                );
                                Navigator.pop(context);  // Fermer le bottom sheet
                              },
                              child: const Text('Appliquer les filtres'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
