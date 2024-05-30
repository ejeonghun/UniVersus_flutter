import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Search/SearchCategory_Model.dart';
import 'Search_Widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  /// State fields for stateful widgets in this page.
  final SearchCategoryModel _searchCategoryModel = SearchCategoryModel();

  SearchCategoryModel get searchCategoryModel => _searchCategoryModel;

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
