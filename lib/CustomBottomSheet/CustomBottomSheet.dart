import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';  // S'assurer que cet import est nécessaire
import '../Gare/GareProvider.dart';  // S'assurer que cet import est nécessaire
import 'BottomSheetContent.dart';  // Nécessaire pour afficher le contenu du bottom sheet

class CustomBottomSheet {
  final List<String> gareSuggestions;
  final List<String> typeSuggestions;

  CustomBottomSheet({
    required this.gareSuggestions,
    required this.typeSuggestions,
  });

  void show(BuildContext context, String type) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,  // La bottom sheet occupe 70% de l'écran
          child: BottomSheetContent(
            type: type,
            gareSuggestions: gareSuggestions,
            typeSuggestions: typeSuggestions,
          ),
        );
      },
    );
  }
}
