import 'dart:developer';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'CreateAccount_Widget.dart' show CreateAccountWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountModel extends FlutterFlowModel<CreateAccountWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // 백엔드의 대학교 리스트를 가진 리스트

  String? selectedUniv;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '이메일을 입력해주세요.';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return '올바른 이메일을 입력해주세요.';
    }
    return null;
  }

  // State field(s) for verify widget.
  FocusNode? verifyFocusNode;
  TextEditingController? verifyController;
  String? Function(BuildContext, String?)? verifyControllerValidator;

  String? emailSaved; // 이메일 저장용 임시 string
  bool isEmailValid = false; // 이메일 인증 여부 -> 이메일 인증 성공시 true
  String? univId; // 대학교 Id값

  Future<bool> sendUnivCert() async {
    ApiCall api = ApiCall();
    final response = await api.post('/univAuth/certify',
        {'email': emailAddressController?.text, 'univName': selectedUniv});
    if (response['success'] == true) {
      debugPrint("univCert 이메일 전송");
      emailSaved = emailAddressController?.text; // 인증 이메일 저장
      return true;
    }
    return false;
  }

  Future<bool> certifyUnivCert() async {
    ApiCall api = ApiCall();
    final response = await api.post('/univAuth/certifyCode',
        {'email': emailSaved, 'code': verifyController?.text});
    if (response['success'] == true) {
      debugPrint("univCert 이메일 인증 성공");
      debugPrint(response.toString());
      isEmailValid = true; // 이메일 인증 여부 변경
      univId = response['univId'].toString();
      return true;
    }
    return false;
  }

  @override
  void initState(BuildContext context) {
    emailAddressControllerValidator = _emailAddressControllerValidator;
    // fetchUniversityList();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    verifyFocusNode?.dispose();
    verifyController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
