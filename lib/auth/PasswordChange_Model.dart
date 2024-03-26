import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'PasswordChange_Widget.dart' show PasswordChangeWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordChangeModel extends FlutterFlowModel<PasswordChangeWidget> {
  ///  State fields for stateful widgets in this page.

  late final String email;

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode1;
  TextEditingController? emailAddressController1;
  String? Function(BuildContext, String?)? emailAddressController1Validator;
  // State field(s) for emailAddress widget.
  FocusNode? passwordFocusNode2;
  TextEditingController? passwordController2;
  String? Function(BuildContext, String?)? passwordController2Validator;

  late int memberIdx;

  Future<bool> changePassword() async {
    // 비밀번호 변경 요청
    ApiCall api = ApiCall();
    final response = await api.post('/pwChange', {
      'email': emailAddressController1?.text,
      'password': passwordController2?.text,
      'memberIdx': memberIdx
    });
    if (response['success'] == true) {
      return true;
    }
    return false;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode1?.dispose();
    emailAddressController1?.dispose();

    passwordFocusNode2?.dispose();
    passwordController2?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
