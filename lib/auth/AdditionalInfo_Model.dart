import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:moyo/class/api/ApiCall.dart';
import 'AdditionalInfo_Widget.dart' show AdditionalInfoWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionalInfoModel extends FlutterFlowModel<AdditionalInfoWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for fullName widget.
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

  String? email;
  String? password;

  void inputTest() {
    debugPrint(email);
    debugPrint(password);
    debugPrint(fullNameController?.text);
    debugPrint(nickNameController?.text);
    debugPrint(DateFormat('yyyyMMdd').format(datePicked!));
  }
  
  Future<bool> RegisterUser() async {
    ApiCall api = ApiCall();
    var response = await api.post('/auth/join', {
      'email': email,
      'password': password,
      'name': fullNameController?.text,
      'birth': '',
      'phone': phoneNumberController?.text,
      'nickname' : nickNameController?.text,
      'gender': dropDownValue,
  });
    debugPrint(fullNameController?.text);
    return true;
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

/// Additional helper methods are added here.
}
