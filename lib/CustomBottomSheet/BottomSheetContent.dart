import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/MySearchBar.dart';
import '../utils/SearchProvider.dart';

class BottomSheetContent extends StatefulWidget {
  final String type;
  final List<String> gareSuggestions;
  final List<String> typeSuggestions;

  const BottomSheetContent({
    Key? key,
    required this.type,
    required this.gareSuggestions,
    required this.typeSuggestions,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String? _selectedSortOption;
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 50),

        // Options de tri
        if (widget.type == 'tri') ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedSortOption,
              hint: const Text('Trier par'),
              items: const [
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
          ElevatedButton(
            onPressed: () {
              if (_selectedSortOption != null) {
                // Appliquer le tri dans le provider
                Provider.of<FoundObjectsProvider>(context, listen: false)
                    .setOrderBy(_selectedSortOption == 'date_asc' ? 'date' : '-date');
                Provider.of<FoundObjectsProvider>(context, listen: false)
                    .refreshFoundObjects();
              }
              Navigator.pop(context); // Fermer la bottom sheet
            },
            child: const Text('Appliquer le tri'),
          ),
        ],

        // Options de filtrage
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
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      hint: const Text('Type'),
                      items: widget.typeSuggestions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Appliquer les filtres dans le provider
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .setGareOrigine(
                          gareProvider.selectedGares.isNotEmpty
                              ? gareProvider.selectedGares.join(',')
                              : null,
                        );
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .setType(_selectedType);
                        Provider.of<FoundObjectsProvider>(context, listen: false)
                            .refreshFoundObjects();
                        Navigator.pop(context); // Fermer la bottom sheet
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
