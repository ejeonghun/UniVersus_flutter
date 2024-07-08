import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'PasswordForget_Widget.dart' show PasswordForgetWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// 비밀번호 찾기 페이지 모델 클래스
/// 생성자 : 이정훈
class PasswordForgetModel extends FlutterFlowModel<PasswordForgetWidget> {
  final formKey = GlobalKey<FormState>();
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  FocusNode? userNameFocusNode;
  TextEditingController? userNameController;
  String? Function(BuildContext, String?)? userNameControllerValidator;
  FocusNode? verifyFocusNode;
  TextEditingController? verifyController;
  String? Function(BuildContext, String?)? verifyControllerValidator;

  late int memberIdx; // 인증 성공 시 MemberIdx를 반환하는데 Pwchange Api에서 사용해야함

  void inputTest() {
    debugPrint(emailAddressController?.text);
    debugPrint(userNameController?.text);
    debugPrint(verifyController?.text);
  }

  /// 이메일 인증 요청
  /// 생성자 : 이정훈
  Future<bool> sendEmailRequest() async {
    ApiCall api = ApiCall();
    final response = await api.post('/pwFind/emailSend', {
      'email': emailAddressController?.text,
      'userName': userNameController?.text
    });
    if (response['success'] == true) {
      debugPrint("이메일 전송");
      return true;
    }
    debugPrint(response.toString());
    debugPrint("이메일 전송 실패");
    return false;
  }

  /// 이메일 인증 확인
  /// 생성자 : 이정훈
  Future<bool> verifyEmail() async {
    ApiCall api = ApiCall();
    final response = await api.post('/pwFind/email/auth', {
      'email': emailAddressController?.text,
      'verifcode': verifyController?.text
    });
    if (response['success'] == true) {
      debugPrint(response.toString());
      debugPrint("인증 성공");
      memberIdx = response['data'];
      return true;
    }
    debugPrint(response.toString());
    debugPrint("인증 실패");
    return false;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    userNameFocusNode?.dispose();
    userNameController?.dispose();

    verifyFocusNode?.dispose();
    verifyController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
