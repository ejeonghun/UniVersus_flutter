import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:moyo/class/api/ApiCall.dart';
import 'package:moyo/class/user/user.dart';
import 'CreateAccount_Widget.dart' show CreateAccountWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:moyo/shared/CustomSnackbar.dart';

class CreateAccountModel extends FlutterFlowModel<CreateAccountWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
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
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  String? _passwordControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    return null;
  }


  Future<bool> test() async {
    debugPrint(emailAddressController?.text);
    return true;
  }

  bool isEmailValid = false; // 이메일 인증 여부 -> 이메일 인증 성공시 true 
  String? emailSaved = '';

  // // Backend Req 처리 - 인증 이메일 발송
  Future<bool> sendEmailRequest() async {
    var apiCall = ApiCall();
    emailSaved = emailAddressController?.text; // 이메일 변수에 저장
    var responseBody = await apiCall.post('/emailSend', {
      'email': emailAddressController?.text,
    });

    if (responseBody['success'] == true) {
      // 이메일 전송 성공
      print('이메일 전송 성공');
      return true;
    } else if(responseBody['errorResponse']['status'] == 'DUPLICATED_MEMBER') {
      // 중복된 이메일
      print('중복된 이메일');
      return false;
    } 
    else {
      // 예외 처리 필요
      debugPrint("이메일 전송 실패");
      return false;
    } 
  }

  // Backend Req 처리 - 인증 이메일 확인
  Future<bool> verifyRequest() async {
    var apiCall = ApiCall();
    var responseBody = await apiCall.post('/email/auth', {
      'email': emailSaved,
      'verifcode' : verifyController?.text,
    });

    if (responseBody['success'] == true) {
      // 이메일 전송 성공
      print('이메일 인증 성공');
      isEmailValid = true;
      return true;
    } else if(responseBody['errorResponse']['status'] == 'DUPLICATED_MEMBER') {
      // ?? 
      return false;
    } else {
      // 예외 처리 필요
      debugPrint("이메일 인증 실패");
      return false;
    } 
  }

  
Future<Map<String, dynamic>> returnData() async {
  final password = passwordController?.text;
  if (password == null) {
    return Future.error('Password controller is null');
    // 예외 처리 필요
  }
  return {'email': emailSaved, 'password': password};
}



  @override
  void initState(BuildContext context) {
    emailAddressControllerValidator = _emailAddressControllerValidator;
    passwordVisibility = false;
    passwordControllerValidator = _passwordControllerValidator;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    verifyFocusNode?.dispose();
    verifyController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
