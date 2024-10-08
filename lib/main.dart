import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FoundObject/FoundObjectsProvider.dart';
import 'FoundObject/FoundObjectsScreen.dart';
import 'Gare/GareProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoundObjectsProvider()),  // Provider pour les objets trouvés
        ChangeNotifierProvider(create: (_) => GareProvider()),  // Provider pour les gares
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Found Objects App',
      home: FoundObjectsScreen(),  // Votre écran principal
    );
  }
}
