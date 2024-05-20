import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'Write_Widget.dart' show WriteWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WriteModel extends FlutterFlowModel<WriteWidget> {
  final unfocusNode = FocusNode();
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool? checkboxValue;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? sportDropdownValue;
  DateTime? _datePicked;
  double? lat; // 위도
  double? lng; // 경도
  String? placeName; // 장소명
  DateTime? get datePicked => _datePicked;

  set datePicked(DateTime? value) {
    _datePicked = value;
    // Custom listener mechanism
    notifyDatePickedListeners();
  }

  // List of listeners for datePicked changes
  final List<VoidCallback> _datePickedListeners = [];

  // Method to add a listener for datePicked changes
  void addDatePickedListener(VoidCallback listener) {
    _datePickedListeners.add(listener);
  }

  // Method to remove a listener for datePicked changes
  void removeDatePickedListener(VoidCallback listener) {
    _datePickedListeners.remove(listener);
  }

  // Method to notify all listeners when datePicked changes
  void notifyDatePickedListeners() {
    for (final listener in _datePickedListeners) {
      listener();
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }

}
