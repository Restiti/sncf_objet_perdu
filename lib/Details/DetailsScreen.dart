import 'package:flutter/material.dart';
import '../FoundObject/FoundObject.dart';

class DetailsScreen extends StatelessWidget {
  final FoundObject foundObject;

  const DetailsScreen({Key? key, required this.foundObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'objet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nature: ${foundObject.gcOboNatureC}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${foundObject.gcOboTypeC}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Gare d\'origine: ${foundObject.gcOboGareOrigineRName}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${foundObject.date}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Nom record: ${foundObject.gcOboNomRecordtypeScC}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
