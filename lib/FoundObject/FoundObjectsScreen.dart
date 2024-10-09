import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CategoryObjects/CategoryObjectsScreen.dart';
import 'FoundObject.dart';
import 'FoundObjectItem.dart';
import 'FoundObjectsProvider.dart';

class FoundObjectsScreen extends StatefulWidget {
  @override
  _FoundObjectsScreenState createState() => _FoundObjectsScreenState();
}

class _FoundObjectsScreenState extends State<FoundObjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoundObjectsProvider>(context, listen: false).refreshFoundObjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objets trouvés'),
      ),
      body: Column(
        children: [
          // Section des filtres et tris
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour afficher le tri
                    },
                    child: const Text('Tri'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour afficher les filtres
                    },
                    child: const Text('Filtre'),
                  ),
                ),
              ],
            ),
          ),

          // Section des objets par catégorie avec défilement horizontal
          Expanded(
            child: Consumer<FoundObjectsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.hasError) {
                  return Center(child: Text('Erreur: ${provider.errorMessage}'));
                } else {
                  final objectsByType = provider.objectsByType;

                  return ListView.builder(
                    itemCount: objectsByType.keys.length,
                    itemBuilder: (context, index) {
                      String objectType = objectsByType.keys.elementAt(index);
                      List<FoundObject> objects = objectsByType[objectType]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    objectType,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Naviguer vers la page de tous les objets de la catégorie
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryObjectsScreen(
                                          category: objectType,
                                          objects: objects,  // Passer les objets de la catégorie
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Voir tous'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: objects.length + 1,  // +1 pour ajouter la card "Voir tous"
                              itemBuilder: (context, index) {
                                if (index == objects.length) {
                                  // Card "Voir tous" dans la liste
                                  return GestureDetector(
                                    onTap: () {
                                      // Naviguer vers la page de tous les objets de cette catégorie
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryObjectsScreen(
                                            category: objectType,
                                            objects: objects,  // Passer les objets de la catégorie
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 220,
                                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Voir tous',
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  final foundObject = objects[index];
                                  return FoundObjectItem(object: foundObject);  // Affichage des objets
                                }
                              },
                            ),
                          ),
                        ],
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
