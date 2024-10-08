import 'package:flutter/material.dart';
import '../Details/DetailsScreen.dart';
import 'FoundObject.dart';

// Fonction pour formater la date et l'heure correctement
String formatDateTime(String? dateTimeStr) {
  if (dateTimeStr == null) return 'Non précisé';

  try {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  } catch (e) {
    return 'Non précisé'; // Si quelque chose ne va pas avec le parsing
  }
}

class FoundObjectItem extends StatelessWidget {
  final FoundObject object;

  const FoundObjectItem({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatage de la date et l'heure de restitution é
    String formattedDate = formatDateTime(object.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(foundObject: object),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://via.placeholder.com/220', // Remplacer par l'URL réelle si disponible
              height: 120,
              width: 220,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                object.gcOboNatureC,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(object.gcOboGareOrigineRName),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text('Reçu le: $formattedDate'), // Afficher la date de restitution formatée
            ),
          ],
        ),
      ),
    );
  }
}
