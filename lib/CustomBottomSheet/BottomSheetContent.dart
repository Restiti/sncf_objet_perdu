import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/MySearchBar.dart';
import '../utils/SearchProvider.dart';

class BottomSheetContent extends StatefulWidget {
  final String type;
  final List<String> gareSuggestions;

  const BottomSheetContent({
    Key? key,
    required this.type,
    required this.gareSuggestions,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String? _selectedSortOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Container(height: 50,),
        // Sorting Options
        if (widget.type == 'tri') ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,  // Full width of the screen
              child: DropdownButton<String>(
                isExpanded: true,  // Ensure Dropdown takes full width
                value: _selectedSortOption,
                hint: const Text('Trier par'),
                items: [
                  DropdownMenuItem(
                    value: 'date_asc',
                    child: Text('Date croissante'),
                  ),
                  DropdownMenuItem(
                    value: 'date_desc',
                    child: Text('Date décroissante'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSortOption = value;
                  });
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply sorting in the provider
              if (_selectedSortOption != null) {
                Provider.of<FoundObjectsProvider>(context, listen: false)
                    .setOrderBy(_selectedSortOption == 'date_asc' ? 'date' : '-date');
                Provider.of<FoundObjectsProvider>(context, listen: false)
                    .refreshFoundObjects();
              }
              Navigator.pop(context); // Close the bottom sheet
            },
            child: const Text('Appliquer le tri'),
          ),
        ],

        // Filtering Options
        if (widget.type == 'filtre')
          Expanded(
            child: Consumer<GareProvider>(
              builder: (context, gareProvider, child) {
                return Column(
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => SearchProvider()..setSuggestions(widget.gareSuggestions),
                      child: MySearchBar(suggestions: widget.gareSuggestions),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .setGareOrigine(
                          gareProvider.selectedGares.isNotEmpty
                              ? gareProvider.selectedGares.join(',')
                              : null,
                        );
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .refreshFoundObjects();
                        Navigator.pop(context); // Close the bottom sheet
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
