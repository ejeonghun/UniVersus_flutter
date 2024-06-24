import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'versusResult_Widget.dart' show VersusResultWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/* 
* 대결 결과 입력 페이지 모델 클래스
* 생성자 : 이정훈
*/
class VersusResultModel extends FlutterFlowModel<VersusResultWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // 탭 바(승리팀) 선택 시 API로 전송할 값 임시 저장
  late int winUnivId;
  late bool isWinGuestUniv;

  // Host 학교 입력칸
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Guest 학교 입력칸
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  /** 대결 결과에서 대학교 정보를 불러오기 위한 API 통신 메소드
  * @param battleId : 대결 ID
  * @return : 대결 상세 정보
  * 생성자 : 이정훈
  */
  Future<versusDetail> getVersusDetail(int battleId) async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response =
        await api.get('/univBattle/info?univBattleId=${battleId.toString()}');
    if (response.isNotEmpty) {
      // response가 null이 아니면 조회 성공
      List<dynamic> hostParticipantListData =
          response['data']['HostTeam']['hostPtcList'];
      List<dynamic> guestTeamMembersData =
          response['data']['GuestTeam']['guestPtcList'];

      List<Map<String, dynamic>> hostTeamMembers =
          List<Map<String, dynamic>>.from(hostParticipantListData);
      List<Map<String, dynamic>> guestTeamMembers =
          List<Map<String, dynamic>>.from(guestTeamMembersData);

      versusDetail res = versusDetail(
        battleDate: response['data']['univBattle']['battleDate'],
        lat: response['data']['univBattle']['lat'],
        lng: response['data']['univBattle']['lng'],
        hostTeamName: response['data']['HostTeam']['hostUvName'],
        hostTeamUnivLogo: response['data']['univBattle']['hostUnivLogo'],
        guestTeamName: response['data']['GuestTeam'] != null
            ? response['data']['GuestTeam']['guestUvName']
            : '참가 학교 없음',
        guestTeamUnivLogo: response['data']['univBattle']['guestUnivLogo'],
        BattleId: response['data']['univBattle']['univBattleId'],
        status: response['data']['univBattle']['matchStatus'],
        hostLeaderId: response['data']['univBattle']['hostLeader'],
        place: response['data']['univBattle']['place'] ?? '없음',
        regDate: response['data']['univBattle']['regDt'],
        invitationCode: response['data']['univBattle']['invitationCode'],
        hostTeamMembers: hostTeamMembers,
        guestTeamMembers: guestTeamMembers,
        content: response['data']['univBattle']['content'],
        cost: response['data']['univBattle']['cost'],
        eventId: response['data']['univBattle']['eventId'],
        guestLeaderId: response['data']['univBattle']['guestLeader'],
        matchStartDt:
            DateTime.parse(response['data']['univBattle']["matchStartDt"]),
        hostUnivId: response['data']['univBattle']['hostUniv'],
        guestUnivId: response['data']['univBattle']['guestUniv'],
      );
      // debugPrint(res.getHostTeamMembers.toString());
      debugPrint(res.toString());
      return res;
    } else {
      // 조회 실패
      print(response);
      return versusDetail();
    }
  }

  /** 대결 결과 입력 API 통신 메소드
  * @param battleId : 대결 ID
  * @return : API 결과
  * 생성자 : 이정훈
  */
  Future<bool> sendVersusRes(int battleId) async {
    // 대결 결과를 전송하는 메소드
    DioApiCall api = DioApiCall();
    late int hostScore;
    late int guestScore;
    if (isWinGuestUniv) {
      // 게스트 팀이 이겼을 경우 스코어를 반대로 전송
      hostScore = int.parse(textController2.text);
      guestScore = int.parse(textController1.text);
    } else {
      hostScore = int.parse(textController1.text);
      guestScore = int.parse(textController2.text);
    }
    final response = await api.post('/univBattle/resultReq', {
      "univBattleId": battleId,
      "hostLeader": await UserData.getMemberIdx(),
      "winUniv": winUnivId,
      "hostScore": hostScore,
      "guestScore": guestScore,
    });
    debugPrint(response.toString());
    bool res = response['success'];
    return res;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
