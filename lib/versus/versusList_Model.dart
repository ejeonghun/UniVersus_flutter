import 'package:universus/versus/component/versusElement_Widget.dart';
import 'package:universus/versus/component/versusSearch_Widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'versusList_Widget.dart' show VersusListWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class VersusListModel extends FlutterFlowModel<VersusListWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for versusSearch component.
  late VersusSearchModel versusSearchModel;
  // Model for versusElement component.
  late VersusElementModel versusElementModel1;
  // Model for versusElement component.
  late VersusElementModel versusElementModel2;

  @override
  void initState(BuildContext context) {
    versusSearchModel = createModel(context, () => VersusSearchModel());
    versusElementModel1 = createModel(context, () => VersusElementModel());
    versusElementModel2 = createModel(context, () => VersusElementModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    versusSearchModel.dispose();
    versusElementModel1.dispose();
    versusElementModel2.dispose();
  }
}
