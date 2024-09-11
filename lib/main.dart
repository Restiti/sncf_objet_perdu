import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FoundObject/FoundObjectsProvider.dart';
import 'FoundObject/FoundObjectsScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FoundObjectsProvider(),
      child: MaterialApp(
        title: 'Found Objects App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FoundObjectsScreen(),
      ),
    );
  }
}
