import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'PasswordChange_Widget.dart' show PasswordChangeWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// 비밀번호 변경 페이지 모델 클래스
/// 생성자 : 이정훈
class PasswordChangeModel extends FlutterFlowModel<PasswordChangeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode1;
  TextEditingController? emailAddressController1;
  String? Function(BuildContext, String?)? emailAddressController1Validator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode2;
  TextEditingController? emailAddressController2;
  late bool emailAddressVisibility;
  String? Function(BuildContext, String?)? emailAddressController2Validator;

  late String memberIdx;

  /// 비밀번호 변경 요청
  /// 생성자 : 이정훈
  Future<bool> changePassword() async {
    // 비밀번호 변경 API
    DioApiCall api = DioApiCall();
    final response = await api.post('/member/updatePw', {
      'memberIdx': memberIdx,
      'email': emailAddressController1?.text,
      'password': emailAddressController2?.text
    });
    if (response['success'] == true) {
      debugPrint("비밀번호 변경 성공");
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState(BuildContext context) {
    emailAddressVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode1?.dispose();
    emailAddressController1?.dispose();

    emailAddressFocusNode2?.dispose();
    emailAddressController2?.dispose();
  }
}
