import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'AdditionalInfo_Widget.dart' show AdditionalInfoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionalInfoModel extends FlutterFlowModel<AdditionalInfoWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for fullName widget.

  FocusNode? emailFocusNode;
  TextEditingController? emailController;

  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(BuildContext, String?)? fullNameControllerValidator;
  // State field(s) for age widget.
  FocusNode? nickNameFocusNode;
  TextEditingController? nickNameController;
  String? Function(BuildContext, String?)? nickNameControllerValidator;
  // State field(s) for phoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;
  String? Function(BuildContext, String?)? phoneNumberControllerValidator;
  DateTime? datePicked;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionController;
  String? Function(BuildContext, String?)? descriptionControllerValidator;

  FormFieldController<String>? radioButtonValueController;

  String? email;
  String? password;
  String? gender;

  void inputTest() {
    debugPrint(email);
    debugPrint(password);
    debugPrint(fullNameController?.text);
    debugPrint(nickNameController?.text);
    debugPrint(radioButtonValue.toString());
    debugPrint(DateFormat('yyyyMMdd').format(datePicked!));
  }

  Future<bool> RegisterUser() async {
    ApiCall api = ApiCall();

    // Backend 정보 가공
    if (radioButtonValue.toString() == '남자') {
      gender = 'M';
    } else {
      gender = 'F';
    }

    var response = await api.post('/auth/join', {
      'email': email,
      'password': password,
      'userName': fullNameController?.text,
      'birth': DateFormat('yyyyMMdd').format(datePicked!),
      'phone': phoneNumberController?.text,
      'nickname': nickNameController?.text,
      'gender': gender,
      'address': '주소',
      'areaIntrs': '관심분야',
    });
    if (response['success'] == true) {
      debugPrint("회원가입 성공");
      return true;
    } else {
      debugPrint(response.toString());
      debugPrint("회원가입 실패");
      return false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    nickNameFocusNode?.dispose();
    nickNameController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionController?.dispose();
  }

  /// Action blocks are added here.

  String? get radioButtonValue => radioButtonValueController?.value;
}
