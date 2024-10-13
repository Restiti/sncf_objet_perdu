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
    // Exécute après le premier build pour charger les données
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Charger les objets en fonction de la catégorie sélectionnée
    await Provider.of<FoundObjectsProvider>(context, listen: false)
        .fetchFoundObjectsByCategory(type: widget.category);
  }

  Future<void> _loadDataBack() async {
    // Rafraîchir les objets lors du retour
    await Provider.of<FoundObjectsProvider>(context, listen: false)
        .refreshFoundObjects();
  }

  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    // Action lors de la navigation retour avec résultat
    if (didPop) {
      _loadDataBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _onPopInvokedWithResult, // Gestion retour avec résultat
      child: Scaffold(
        appBar: AppBar(
          title: Text('Objets trouvés - ${widget.category}'),
        ),
        body: Consumer<FoundObjectsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(), // Loader pendant le chargement
              );
            } else if (provider.hasError) {
              return Center(
                child: Text('Erreur: ${provider.errorMessage}'), // Message d'erreur
              );
            } else if (provider.foundObjects.isEmpty) {
              return const Center(
                child: Text('Aucun objet trouvé.'),
              );
            }

            // Liste des objets trouvés
            return ListView.builder(
              itemCount: provider.foundObjects.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FoundObjectItem(object: provider.foundObjects[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
