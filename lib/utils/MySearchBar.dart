import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Gare/GareProvider.dart';
import 'SearchProvider.dart';

class MySearchBar extends StatelessWidget {
  final List<String> suggestions;

  MySearchBar({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final gareProvider = Provider.of<GareProvider>(context, listen: false);  // Accéder au GareProvider

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: searchProvider.textEditingController,
                onTap: () {
                  searchProvider.toggleSuggestions();
                },
                onChanged: searchProvider.filterSuggestions,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                if (searchProvider.showSuggestions) {
                  searchProvider.toggleSuggestions();
                }
              },
            ),
          ],
        ),
        if (searchProvider.showSuggestions)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: searchProvider.filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = searchProvider.filteredSuggestions[index];
                final isSelected = gareProvider.selectedGares.contains(suggestion);

                return CheckboxListTile(
                  title: Text(suggestion),
                  value: isSelected,
                  onChanged: (bool? value) {
                    gareProvider.toggleGareSelection(suggestion);  // Ajouter ou retirer une gare
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
