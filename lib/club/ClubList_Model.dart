import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/club/Components/clublist_ex_Model.dart';
import 'ClubList_Widget.dart' show ClubListWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubListModel extends FlutterFlowModel<ClubListWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for clublist_ex component.
  late ClublistExModel clublistExModel;

  @override
  void initState(BuildContext context) {
    clublistExModel = createModel(context, () => ClublistExModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    clublistExModel.dispose();
  }
}
