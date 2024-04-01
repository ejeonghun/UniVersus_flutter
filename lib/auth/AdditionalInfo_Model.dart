import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'AdditionalInfo_Widget.dart' show AdditionalInfoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionalInfoModel extends FlutterFlowModel<AdditionalInfoWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for fullName widget.

  String? univId; // 대학 Id값

  FocusNode? universityFocusNode;
  TextEditingController? universityController;
  String? Function(BuildContext, String?)? universityControllerValidator;
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  // State field(s) for fullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(BuildContext, String?)? fullNameControllerValidator;
  // State field(s) for nickname widget.
  FocusNode? nicknameFocusNode;
  TextEditingController? nicknameController;
  String? Function(BuildContext, String?)? nicknameControllerValidator;
  // State field(s) for phoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;
  String? Function(BuildContext, String?)? phoneNumberControllerValidator;
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;

  DateTime? datePicked;

  int? selectedDeptId;

  void inputTest() {
    debugPrint(univId.toString());
    debugPrint(universityController?.text);
    debugPrint(emailController?.text);
    debugPrint(passwordController?.text);
    debugPrint(fullNameController?.text);
    debugPrint(nicknameController?.text);
    debugPrint(radioButtonValue.toString());
    debugPrint(DateFormat('yyyyMMdd').format(datePicked!));
  }

  String? gender;

  Future<bool> RegisterUser(BuildContext context) async {
    ApiCall api = ApiCall();

    // Backend 정보 가공
    if (radioButtonValue.toString() == '남성') {
      gender = 'M';
    } else {
      gender = 'F';
    }

    // 변수들이 null인지 체크
    if (univId == null ||
        emailController?.text == null ||
        passwordController?.text == null ||
        fullNameController?.text == null ||
        nicknameController?.text == null ||
        datePicked == null ||
        selectedDeptId == null) {
      // 스낵바 띄우기
      CustomSnackbar.error(context, "회원가입 실패", "모든 필수 정보를 입력해주세요.", 3);
      return false;
    }
    inputTest();
    var response = await api.post('/auth/join', {
      'univId': univId,
      'email': emailController?.text,
      'password': passwordController?.text,
      'userName': fullNameController?.text,
      'birth': DateFormat('yyyyMMdd').format(datePicked!),
      'phone': phoneNumberController?.text,
      'nickname': nicknameController?.text,
      'gender': gender,
      'address': '주소',
      'deptId': selectedDeptId,
    });
    if (response['success'] == true) {
      debugPrint("회원가입 성공");
      debugPrint(response.toString());
      return true;
    } else {
      debugPrint(response.toString());
      debugPrint("회원가입 실패");

      return false;
    }
  }

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    universityFocusNode?.dispose();
    universityController?.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    nicknameFocusNode?.dispose();
    nicknameController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberController?.dispose();
  }

  /// Action blocks are added here.

  String? get radioButtonValue => radioButtonValueController?.value;
}
