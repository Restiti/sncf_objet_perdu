import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../FoundObject/FoundObjectItem.dart';

class CategoryObjectsScreen extends StatefulWidget {
  final String category;

  const CategoryObjectsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _CategoryObjectsScreenState createState() => _CategoryObjectsScreenState();
}

class _CategoryObjectsScreenState extends State<CategoryObjectsScreen> {

  @override
  void initState() {
    super.initState();
    // Utiliser WidgetsBinding pour différer l'exécution après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Charger les objets correspondant à la catégorie via le provider
    await Provider.of<FoundObjectsProvider>(context, listen: false).fetchFoundObjectsByCategory(type: widget.category);
  }

  Future<void> _loadDataBack() async {
    // Charger les objets correspondant à la catégorie via le provider
    await Provider.of<FoundObjectsProvider>(context, listen: false).refreshFoundObjects();
  }

  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    // Cette méthode est appelée lorsque l'utilisateur essaie de quitter cette page
    print("User is navigating back with result: $result");
    if (didPop) {
      print("Pop action confirmed");
      _loadDataBack();
    } else {
      print("Pop action was canceled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _onPopInvokedWithResult,  // Détecte l'événement pop avec le résultat
      child: Scaffold(
        appBar: AppBar(
          title: Text('Objets trouvés - ${widget.category}'),
        ),
        body: Consumer<FoundObjectsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(),  // Affichage du loader pendant le chargement
              );
            } else if (provider.hasError) {
              return Center(
                child: Text('Erreur: ${provider.errorMessage}'),  // Affichage du message d'erreur
              );
            } else if (provider.foundObjects.isEmpty) {
              return Center(
                child: Text('Aucun objet trouvé.'),
              );
            }

            return ListView.builder(
              itemCount: provider.foundObjects.length,
              itemBuilder: (context, index) {
                final foundObject = provider.foundObjects[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FoundObjectItem(object: foundObject),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
