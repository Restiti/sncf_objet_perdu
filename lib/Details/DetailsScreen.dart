import 'package:flutter/material.dart';
import '../FoundObject/FoundObject.dart';

class DetailsScreen extends StatelessWidget {
  final FoundObject foundObject;

  const DetailsScreen({Key? key, required this.foundObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle boldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const TextStyle normalStyle = TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'objet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nature: ${foundObject.gcOboNatureC}',
              style: boldStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${foundObject.gcOboTypeC}',
              style: normalStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Gare d\'origine: ${foundObject.gcOboGareOrigineRName}',
              style: normalStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${foundObject.date}',
              style: normalStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Nom record: ${foundObject.gcOboNomRecordtypeScC}',
              style: normalStyle,
            ),
          ],
        ),
      ),
    );
  }
}
