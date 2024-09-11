import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SearchProvider.dart';

class MySearchBar extends StatelessWidget {
  final List<String> suggestions;

  MySearchBar({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

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
                  hintText: 'Search...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                searchProvider.toggleSuggestions();
              },
            ),
          ],
        ),
        if (searchProvider.showSuggestions)
          SizedBox(
            height: 200, // adjust this value as needed
            child: ListView.builder(
              itemCount: searchProvider.filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchProvider.filteredSuggestions[index]),
                  onTap: () {
                    searchProvider.selectSuggestion(
                        searchProvider.filteredSuggestions[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
