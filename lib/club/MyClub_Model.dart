import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'MyClub_Widget.dart' show MyClubWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyClubModel extends FlutterFlowModel<MyClubWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
