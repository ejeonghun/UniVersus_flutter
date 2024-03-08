import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'PasswordForget_Widget.dart' show PasswordForgetWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordForgetModel extends FlutterFlowModel<PasswordForgetWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '이메일을 입력하세요';
    }

    if (val.length < 6) {
      return '올바른 이메일을 입력하세요';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (ClickLike)] action in Button-Login widget.
  // ApiCallResponse? apiResult2od;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    emailAddressControllerValidator = _emailAddressControllerValidator;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
