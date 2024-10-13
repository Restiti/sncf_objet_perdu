import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/SearchProvider.dart';
import '../utils/MySearchBar.dart';
import 'BottomSheetContent.dart';

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
          heightFactor: 0.7,
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

