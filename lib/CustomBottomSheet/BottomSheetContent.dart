import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/MySearchBar.dart';
import '../utils/SearchProvider.dart';

class BottomSheetContent extends StatelessWidget {
  final String type;
  final List<String> gareSuggestions;

  const BottomSheetContent({
    Key? key,
    required this.type,
    required this.gareSuggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    ChangeNotifierProvider(
                      create: (_) => SearchProvider()..setSuggestions(gareSuggestions),
                      child: MySearchBar(suggestions: gareSuggestions),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .refreshFoundObjects(
                          gareOrigine: gareProvider.selectedGares.isNotEmpty
                              ? gareProvider.selectedGares.join(',')
                              : null,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Appliquer les filtres'),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
