import 'package:flutter/material.dart';
import 'package:universus/Search/SearchCategory_Model.dart';

class SearchModel extends ChangeNotifier {
  /// State fields for stateful widgets in this page.
  final SearchCategoryModel _searchCategoryModel = SearchCategoryModel();

  SearchCategoryModel get searchCategoryModel => _searchCategoryModel;

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  List<String> recentSearches = [];

  void addRecentSearch(String searchQuery) {
    if (!recentSearches.contains(searchQuery)) {
      recentSearches.add(searchQuery);
      notifyListeners();
    }
  }

  void removeRecentSearch(String searchQuery) {
    recentSearches.remove(searchQuery);
    notifyListeners();
  }

  void clearRecentSearches() {
    recentSearches.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    super.dispose();
  }
}
