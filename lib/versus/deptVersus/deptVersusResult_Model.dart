import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'deptversusResult_Widget.dart' show deptVersusResultWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class deptVersusResultModel extends FlutterFlowModel<deptVersusResultWidget> {
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

  Future<versusDetail> getVersusDetail(int battleId) async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response =
        await api.get('/deptBattle/info?deptBattleId=${battleId.toString()}');
    if (response.isNotEmpty) {
      // response가 null이 아니면 조회 성공
      List<dynamic> hostParticipantListData =
          response['data']['HostTeam']['hostPtcList'];
      List<dynamic> guestTeamMembersData =
          response['data']['GuestTeam']['guestPtcList'];

      // hostTeam 멤버 리스트를 가져온다.
      List<Map<String, dynamic>> hostTeamMembers =
          List<Map<String, dynamic>>.from(hostParticipantListData);

      // guestTeam 멤버 리스트를 가져온다.
      List<Map<String, dynamic>> guestTeamMembers =
          List<Map<String, dynamic>>.from(guestTeamMembersData);

      versusDetail res = versusDetail(
          hostTeamName: response['data']['HostTeam']['hostDeptName'],
          hostTeamUnivLogo: response['data']['deptBattle']['univLogo'],
          guestTeamName: response['data']['deptBattle']['guestDeptName'],
          guestTeamUnivLogo: response['data']['deptBattle']['guestUnivLogo'] ??= 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          BattleId: response['data']['deptBattle']['deptBattleId'],
          status: response['data']['deptBattle']['matchStatus'],
          hostLeaderId: response['data']['deptBattle']['hostLeader'],
          place: response['data']['deptBattle']['place'] ?? '없음',
          regDate: response['data']['deptBattle']['regDt'],
          invitationCode: response['data']['deptBattle']['invitationCode'],
          hostTeamMembers: hostTeamMembers,
          guestTeamMembers: guestTeamMembers,
          content: response['data']['deptBattle']['content'],
          cost: response['data']['deptBattle']['cost'],
          eventId: response['data']['deptBattle']['eventId'],
          guestLeaderId: response['data']['deptBattle']['guestLeader'],
          winUnivName: response['data']['winUnivName'] ??= "null",
          hostUnivId: response['data']['deptBattle']['hostDept'], // 호스트팀 deptId
          guestUnivId: response['data']['deptBattle']['guestDept'] // 게스트팀 deptId
          );
      debugPrint(res.toString());
      return res;
    } else {
      // 조회 실패
      print(response);
      return versusDetail();
    }
  }

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
    final response = await api.post('/deptBattle/resultReq', {
      "deptBattleId": battleId,
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
