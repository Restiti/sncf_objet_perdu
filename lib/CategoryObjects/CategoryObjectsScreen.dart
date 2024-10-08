import 'package:flutter/material.dart';

import '../FoundObject/FoundObject.dart';
import '../FoundObject/FoundObjectItem.dart';


class CategoryObjectsScreen extends StatelessWidget {
  final String category;
  final List<FoundObject> objects;

  const CategoryObjectsScreen({
    Key? key,
    required this.category,
    required this.objects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objets trouvés - $category'),
      ),
      body: ListView.builder(
        itemCount: objects.length,
        itemBuilder: (context, index) {
          final foundObject = objects[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FoundObjectItem(object: foundObject),  // Réutilisation du composant pour afficher les objets
          );
        },
      ),
    );
  }
}
