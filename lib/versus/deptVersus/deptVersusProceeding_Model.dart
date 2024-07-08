import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'deptVersusProceeding_Widget.dart' show deptVersusProceedingWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// 학과 대항전 진행중 페이지 모델 클래스
/// 생성자 : 이정훈
class deptProceedingModel extends FlutterFlowModel<deptVersusProceedingWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Timer widget.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  Icon getIcon(int eventId) {
    switch (eventId) {
      case 1:
        return Icon(
          Icons.sports_tennis_sharp,
          size: 48.0,
        ); // 배드민턴
      case 2:
        return Icon(Icons.sports, size: 48.0); // 볼링
      case 3:
        return Icon(Icons.sports_soccer, size: 48.0); // 축구
      case 4:
        return Icon(Icons.sports_soccer, size: 48.0); // 풋살
      case 5:
        return Icon(Icons.sports_baseball, size: 48.0); // 야구
      case 6:
        return Icon(Icons.sports_basketball, size: 48.0); // 농구
      case 7:
        return Icon(Icons.sports_golf, size: 48.0); // 당구/포켓볼
      case 8:
        return Icon(Icons.sports_tennis, size: 48.0); // 탁구
      case 9:
        return Icon(Icons.sports_esports, size: 48.0); // E-Sport
      default:
        return Icon(Icons.help_outline, size: 48.0); // 알 수 없는 eventId
    }
  }

  String getEventText(int eventId) {
    switch (eventId) {
      case 1:
        return '배드민턴';
      case 2:
        return '볼링';
      case 3:
        return '축구';
      case 4:
        return '풋살';
      case 5:
        return '야구';
      case 6:
        return '농구';
      case 7:
        return '당구/포켓볼';
      case 8:
        return '탁구';
      case 9:
        return 'E-Sport';
      default:
        return '알 수 없음';
    }
  }

  /*
  * @param battleId: 대결 아이디
  * @return versusDetail: 대결 상세 정보 클래스
  * @throws Exception: 대결 상세 정보 조회 실패 시 예외 발생
  * 생성자 : 이정훈
  * */
  Future<versusDetail> getDeptVersusDetail(int battleId) async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response =
        await api.get('/deptBattle/info?deptBattleId=${battleId.toString()}');
    print("진행중 ... 불러움");
    print(response.toString());
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
          battleDate: response['data']['deptBattle']['battleDate'],
          lat: response['data']['deptBattle']['lat'],
          lng: response['data']['deptBattle']['lng'],
          hostTeamName: response['data']['deptBattle']['hostDeptName'],
          hostTeamUnivLogo: response['data']['deptBattle']['univLogo'],
          guestTeamName: response['data']['deptBattle']['guestDeptName'],
          guestTeamUnivLogo: response['data']['deptBattle']['univLogo'] ??
              'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
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
          matchStartDt:
              DateTime.parse(response['data']['deptBattle']["matchStartDt"]));
      debugPrint(res.toString());
      return res;
    } else {
      // 조회 실패
      print(response);
      return versusDetail();
    }
  }
}
