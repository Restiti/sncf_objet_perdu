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
      title: 'SNCF Themed App',
      theme: ThemeData(
        // Define SNCF color scheme using `colorScheme`
        colorScheme: ColorScheme(
          primary: Color(0xFF003366), // Dark blue for primary color (AppBar, main elements)
          secondary: Color(0xFF0090FF), // Light blue for active buttons, selected tabs
          background: Color(0xFFF1F1F1), // Light gray background for scaffold
          surface: Color(0xFFEFEFEF), // Lighter gray for cards/containers
          onPrimary: Colors.white, // White text on primary color (like AppBar)
          onSecondary: Colors.white, // White text on secondary color (buttons, active elements)
          onBackground: Colors.black87, // Dark text on background
          onSurface: Colors.black, // Dark text on surfaces
          error: Colors.red, // Default error color
          onError: Colors.white, // White text on error background
          brightness: Brightness.light, // The overall theme brightness
        ),

        // AppBar styling
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF003366),  // Dark blue for AppBar
          titleTextStyle: TextStyle(
            color: Colors.white,  // White text
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,  // White icons
          ),
        ),

        // Elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0090FF),  // Light blue for buttons
            foregroundColor: Colors.white,  // White text
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),

        // Text theme with updated styles
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF003366),  // Dark blue for headlines
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyLarge: TextStyle(
            color: Colors.black87,  // Default black for body text
            fontSize: 16,
          ),
          labelLarge: TextStyle(  // Used for buttons
            color: Colors.white,  // White text on buttons
            fontSize: 16,
          ),
        ),

        // Input decoration styling (for text fields)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF0090FF)),  // Light blue focus color
          ),
        ),

        // General background color for the entire app
        scaffoldBackgroundColor: Color(0xFFF1F1F1),  // Light gray background
      ),
      home: FoundObjectsScreen(),
    );
  }
}
