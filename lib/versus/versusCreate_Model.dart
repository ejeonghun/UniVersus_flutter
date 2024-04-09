import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'versusCreate_Widget.dart' show versusCreateWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class versusCreateModel extends FlutterFlowModel<versusCreateWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;
  // State field(s) for VersusPrice widget.
  FocusNode? versusPriceFocusNode;
  TextEditingController? versusPriceController;
  String? Function(BuildContext, String?)? versusPriceControllerValidator;
  // State field(s) for VersusIntro widget.
  FocusNode? versusIntroFocusNode;
  TextEditingController? versusIntroController;
  String? Function(BuildContext, String?)? versusIntroControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;

  int? eventId; // 카테고리 id

  double? lat; // 위도
  double? lng; // 경도
  String? placeName; // 장소명
  DateTime? datePicked; // 날짜

  Future<bool> inputCheck(BuildContext context) async {
    if (radioButtonValueController == null ||
        versusPriceController.text == null ||
        versusIntroController.text == null ||
        countControllerValue == null ||
        eventId == null ||
        datePicked == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("누락된 정보가 있습니다"),
            content: Text("모든 필드를 채워주세요."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<bool> createBattle() async {
    ApiCall api = ApiCall();
    Map<String, dynamic> data = {
      "hostLeader": await UserData.getMemberIdx(),
      "eventId": eventId,
      "lat": lat,
      "lng": lng,
      "place": placeName,
      "battleDate": DateFormat('yyyyMMdd').format(datePicked!),
      "content": versusIntroController.text,
      "cost": versusPriceController.text,
      "teamPtcLimit": countControllerValue
    };
    debugPrint(data.toString());
    if (radioButtonValue == '대학 vs 대학') {
      debugPrint("대학");
      final response = await api.post("/univBattle/create", data);
      if (response['success'] == true) {
        return true; // 성공
      }
      return false; // 실패
    } else if (radioButtonValue == '학과 vs 학과') {
      debugPrint("학과");
      data["univId"] = await UserData.getUnivId(); // form 데이터에 univId 추가
      data.remove("totalParticipants");
      final response = await api.post("/deptBattle/create", data);
      if (response['success']) {
        return true; // 성공
      }
      return false; // 실패
    }
    debugPrint("학과");
    return false;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    versusPriceFocusNode?.dispose();
    versusPriceController?.dispose();

    versusIntroFocusNode?.dispose();
    versusIntroController?.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
