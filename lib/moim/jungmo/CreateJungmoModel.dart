import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:io';
import 'CreateJungmoWidget.dart' show CreatejungmoWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreatejungmoModel extends FlutterFlowModel<CreatejungmoWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for jungmoName widget.
  FocusNode? jungmoNameFocusNode;
  TextEditingController? jungmoNameController;
  String? Function(BuildContext, String?)? jungmoNameControllerValidator;
  // State field(s) for jungmoPrice widget.
  FocusNode? jungmoPriceFocusNode;
  TextEditingController? jungmoPriceController;
  String? Function(BuildContext, String?)? jungmoPriceControllerValidator;
  // State field(s) for jungmoPerson widget.
  FocusNode? jungmoPersonFocusNode;
  TextEditingController? jungmoPersonController;
  String? Function(BuildContext, String?)? jungmoPersonControllerValidator;
  // State field(s) for jungmoIntro widget.
  FocusNode? jungmoIntroFocusNode;
  TextEditingController? jungmoIntroController;
  String? Function(BuildContext, String?)? jungmoIntroControllerValidator;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // State field(s) for PlacePicker widget.
  String? checkDate;

  double? lat; // 위도
  double? lng; // 경도
  String? placeName; // 장소명 or 주소

  FocusNode? jungmoHashTagFocusNode;
  TextEditingController? jungmoHashTagController =
      TextEditingController(text: '#');
  String? Function(BuildContext, String?)? jungmoHashTagControllerValidator;
  List<String> hashtags = []; // 해시태그를 저장할 리스트

  /// Initialization and disposal methods.

  void jungmoSave() {
    print('jungmoName: ${jungmoNameController?.text}');
    print('jungmoPrice: ${jungmoPriceController?.text}');
    print('jungmoPerson: ${jungmoPersonController?.text}');
    print('jungmoIntro: ${jungmoIntroController?.text}');
    print('calendarSelectedDay: $calendarSelectedDay');
    print('checkDate: $checkDate');
    print('lat: $lat');
    print('lng: $lng');
    print('placeName: $placeName');
    print('hashtags: $hashtags');
  }

  void updateHashtags(String text) {
    hashtags =
        text.split(' ').where((word) => word.startsWith('#')).take(5).toList();
    print('Hashtags: $hashtags');
  }

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  void dispose() {
    jungmoNameFocusNode?.dispose();
    jungmoNameController?.dispose();

    jungmoPriceFocusNode?.dispose();
    jungmoPriceController?.dispose();

    jungmoPersonFocusNode?.dispose();
    jungmoPersonController?.dispose();

    jungmoIntroFocusNode?.dispose();
    jungmoIntroController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
