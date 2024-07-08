import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'deptVersusCheck_Widget.dart' show deptVersusCheckWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///  대결 확인 페이지 모델 클래스
///  사용자 : 게스트팀 리더
///  화면진입 트리거 : 호스트 팀 리더가 경기 종료(경기 결과 입력)을 하면 FCM으로 게스트 팀 리더에게 univBattleId를 전송하고 게스트 팀 리더가 해당 알림을 클릭하면 해당 페이지로 이동함
///  생성자 : 이정훈
class VersusCheckModel extends FlutterFlowModel<deptVersusCheckWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  /**
 * eventId를 넣으면 Icon을 반환함
 * */
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

  /**
  * eventId를 넣으면 텍스트를 반환함
   */
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

  /**
 * 대항전 조회
 * @param battleId: 대항전 id
 * @return versusDetail : 대항전 정보 클래스
 * 생성자 : 이정훈
 * */
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
          battleDate: response['data']['deptBattle']['battleDate'],
          lat: response['data']['deptBattle']['lat'],
          lng: response['data']['deptBattle']['lng'],
          hostTeamName: response['data']['HostTeam']['hostDeptName'],
          hostTeamUnivLogo: response['data']['deptBattle']['univLogo'],
          guestTeamName: response['data']['GuestTeam'] != null &&
                  response['data']['GuestTeam']['guestDeptName'] != null
              ? response['data']['deptBattle']['guestDeptName']
              : '모집 중..',
          guestTeamUnivLogo: response['data']['deptBattle']['guestUnivLogo'] ??=
              'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          BattleId: response['data']['deptBattle']['deptBattleId'],
          status: response['data']['deptBattle']['matchStatus'],
          hostLeaderId: response['data']['deptBattle']['hostLeader'],
          place: response['data']['deptBattle']['place'] ?? '없음',
          regDate: response['data']['deptBattle']['regDt'],
          endDate: response['data']['deptBattle']['endDt'] ?? '',
          invitationCode: response['data']['deptBattle']['invitationCode'],
          hostTeamMembers: hostTeamMembers,
          guestTeamMembers: guestTeamMembers,
          content: response['data']['deptBattle']['content'],
          cost: response['data']['deptBattle']['cost'],
          eventId: response['data']['deptBattle']['eventId'],
          guestLeaderId: response['data']['deptBattle']['guestLeader'],
          winUnivName: response['data']['winDeptName'] ??= "null",
          hostScore: response['data']['deptBattle']['hostScore'] ?? 0,
          guestScore: response['data']['deptBattle']['guestScore'] ?? 0,
          winUniv: response['data']['deptBattle']['winUniv'] ?? 0,
          hostUnivId: response['data']['deptBattle']['hostUniv'] ?? 0,
          matchStartDt: response['data']['deptBattle']['matchStartDt'] != null
              ? DateTime.parse(response['data']['deptBattle']['matchStartDt'])
              : null);
      debugPrint(res.toString());
      return res;
    } else {
      // 조회 실패
      print(response);
      return versusDetail();
    }
  }

  /**
   * @param battleId: 대항전 id
   * @param resultYN : 해당 경기 결과가 맞는지 틀린지
   * @return bool : 성공 여부
   * 생성자 : 이정훈
   */
  Future<bool?> resultRes(int battleId, bool resultYN) async {
    String? memberIdx = await UserData.getMemberIdx();
    DioApiCall api = DioApiCall();
    final response = await api.post('/deptBattle/resultRes', {
      'deptBattleId': battleId,
      'memberIdx': memberIdx,
      'resultYN': resultYN,
    });

    if (response['result'] == 'success') {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
