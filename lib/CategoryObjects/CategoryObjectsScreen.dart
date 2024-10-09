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
    await Provider.of<FoundObjectsProvider>(context, listen: false)
        .fetchFoundObjectsByCategory(type: widget.category, totalRecords: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
