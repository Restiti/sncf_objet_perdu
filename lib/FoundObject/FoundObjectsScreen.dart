import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomBottomSheet/CustomBottomSheet.dart';
import '../Details/DetailsScreen.dart';
import '../Gare/GareProvider.dart';
import 'FoundObjectsProvider.dart';

class FoundObjectsScreen extends StatefulWidget {
  @override
  _FoundObjectsScreenState createState() => _FoundObjectsScreenState();
}

class _FoundObjectsScreenState extends State<FoundObjectsScreen> {
  final ScrollController _scrollController = ScrollController();
  late CustomBottomSheet _customBottomSheet;

  @override
  void initState() {
    super.initState();

    _customBottomSheet = CustomBottomSheet(gareSuggestions: []);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoundObjectsProvider>(context, listen: false).refreshFoundObjects();
      Provider.of<GareProvider>(context, listen: false).fetchGares().then((_) {
        setState(() {
          _customBottomSheet = CustomBottomSheet(gareSuggestions: Provider.of<GareProvider>(context, listen: false).gares);
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Afficher le filtre avec les gares
  void _showFilter() {
    final gareProvider = Provider.of<GareProvider>(context, listen: false);
    if (gareProvider.gares.isNotEmpty) {
      _customBottomSheet = CustomBottomSheet(gareSuggestions: gareProvider.gares);
      _customBottomSheet.show(context, 'filtre');
    } else {
      print('No gares available to display in the filter');
      // Vous pouvez aussi afficher un message ou gérer cette situation ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found Objects'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _customBottomSheet.show(context, 'tri'),
                  child: const Text('Tri'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showFilter,
                  child: const Text('Filtre'),
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer<FoundObjectsProvider>(
              builder: (context, provider, child) {
                if (provider.foundObjects.isEmpty && provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.hasError) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                } else {
                  return ListView.builder(
                    itemCount: provider.foundObjects.length,
                    itemBuilder: (context, index) {
                      final foundObject = provider.foundObjects[index];
                      return ListTile(
                        title: Text(foundObject.gcOboNatureC),
                        subtitle: Text('${foundObject.gcOboTypeC} - ${foundObject.gcOboGareOrigineRName}'),
                        trailing: Text(foundObject.date),
                        onTap: () {
                          // Navigate to the DetailsScreen when an item is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(foundObject: foundObject),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
