import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'versusCreate_Widget.dart' show versusCreateWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///대항전 생성 페이지 모델 클래스
///생성자 : 이정훈
class versusCreateModel extends FlutterFlowModel<versusCreateWidget> {
  final formKey = GlobalKey<FormState>();
  FormFieldController<String>? radioButtonValueController;
  FocusNode? versusPriceFocusNode;
  TextEditingController? versusPriceController;
  String? Function(BuildContext, String?)? versusPriceControllerValidator;
  FocusNode? versusIntroFocusNode;
  TextEditingController? versusIntroController;
  String? Function(BuildContext, String?)? versusIntroControllerValidator;
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

  /**
 * 대항전 생성
 * @return bool: 성공 or 실패
 * @throws Exception: 대항전 생성 실패 시 스낵바를 띄움.
 * 생성자 : 이정훈
 * */
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
