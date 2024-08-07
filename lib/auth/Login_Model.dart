import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'Login_Widget.dart' show LoginWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/user/user.dart';

/// 로그인 페이지 모델 클래스
/// 생성자 : 이정훈
class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  String? _passwordControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  /// 로그인 요청
  /// 생성자 : 이정훈
  Future<bool> sendLoginRequest() async {
    var apiCall = ApiCall();
    var responseBody = await apiCall.post('/auth/login', {
      'email': emailAddressController?.text,
      'password': passwordController?.text,
    });

    if (responseBody['success'] == true) {
      // 로그인 성공
      print('Login successful');
      var userdata = UserData(
        id: emailAddressController.text,
        token: responseBody['data']['tokenDto']['accessToken'].toString(),
        platform: 'email',
        memberIdx: responseBody['data']['memberIdx'].toString(),
        univId: responseBody['data']['univId'],
      );
      if (await userdata.saveUser()) {
        // 유저 정보 디바이스 저장
        debugPrint(
            "memberIdx ${responseBody['data']['memberIdx'].toString()} 저장완료");
        print(responseBody['data']['tokenDto']['accessToken']
            .toString()); // 백엔드 token 반환
        return true;
      } else {
        // 예외 처리 필요
        debugPrint("Login Failed");
        return false;
      }
    } else {
      // 예외 처리 필요
      debugPrint("Login Failed");
      return false;
    }
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

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
