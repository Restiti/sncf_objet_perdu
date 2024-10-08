import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FoundObject/FoundObjectsProvider.dart';
import '../Gare/GareProvider.dart';
import '../utils/SearchProvider.dart';
import '../utils/MySearchBar.dart';
import 'BottomSheetContent.dart';

class CustomBottomSheet {
  final List<String> gareSuggestions;

  CustomBottomSheet({required this.gareSuggestions});

  void show(BuildContext context, String type) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: BottomSheetContent(
            type: type,
            gareSuggestions: gareSuggestions,
          ),
        );
      },
    );
  }
}

