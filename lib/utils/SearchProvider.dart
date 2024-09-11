import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _showSuggestions = false;
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _filteredSuggestions = [];
  List<String> _suggestions = [];

  bool get showSuggestions => _showSuggestions;
  TextEditingController get textEditingController => _textEditingController;
  List<String> get filteredSuggestions => _filteredSuggestions;

  void setSuggestions(List<String> suggestions) {
    _suggestions = suggestions;
    _filteredSuggestions = suggestions;
    notifyListeners();
  }

  void toggleSuggestions() {
    _showSuggestions = !_showSuggestions;
    notifyListeners();
  }

  void filterSuggestions(String text) {
    _filteredSuggestions = _suggestions
        .where((suggestion) => suggestion.contains(text))
        .toList();
    notifyListeners();
  }

  void selectSuggestion(String suggestion) {
    _textEditingController.text = suggestion;
    filterSuggestions(suggestion);
    toggleSuggestions();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
