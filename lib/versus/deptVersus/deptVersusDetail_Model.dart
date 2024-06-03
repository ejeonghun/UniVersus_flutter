import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'deptVersusDetail_Widget.dart' show deptVersusDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VersusDetailModel extends FlutterFlowModel<deptVersusDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  late String status;

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
                  response['data']['guestDeptName'] != null
              ? response['data']['guestDeptName']
              : '모집 중..',
          guestTeamUnivLogo: response['data']['deptBattle']['guestUnivLogo'] ??=
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
          winUnivName: response['data']['winUnivName'] ??= "null");
      // debugPrint(res.getHostTeamMembers.toString());
      status = res.status!;
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
  * @return bool : 성공 or 실패 -> 스낵바 표시 -> 새로고침
  * @throws Exception: 대항전 참가 실패 시 스낵바를 띄움.
  * 생성자 : 이정훈
  *  */
  Future<bool> repAttend(int battleId) async {
    // 대항전 대표 참가
    DioApiCall api = DioApiCall();
    final response = await api.post('/deptBattle/repAttend', {
      'deptBattleId': battleId,
      'guestLeader': await UserData.getMemberIdx(),
    });
    return response['success']; // true or false
  }

  /**
  * @param battleId: 대항전 id
  * @return bool : 성공 or 실패 -> 스낵바 표시 -> 새로고침
  * @throws Exception: 대항전 시작 실패 시 스낵바를 띄움.
  * 생성자 : 이정훈
  *
  * 대항전을 만든 hostLeader만이 경기를 시작할 수 있음.
  * */
  Future<bool> matchStart(int battleId) async {
    // 경기시작 API
    DioApiCall api = DioApiCall();
    final response = await api
        .get('/deptBattle/matchStart?deptBattleId=${battleId.toString()}');
    return response['success'];
  }

  /**
  * Enum -> String
  * 대항전 상태의 Enum 값을 String으로 변환함
   */
  String getText() {
    switch (status) {
      case 'IN_PROGRESS':
        return '진행중';
      case 'RECRUIT':
        return '모집중';
      case 'WAITING':
        return '대기중';
      case 'COMPLETED':
        return '종료';
      case "PREPARED":
        return '준비완료';
      default:
        return '';
    }
  }

  /**
  * Enum -> String
  * 대항전 상태의 Enum 값을 상황에 맞는 Color으로 변환함
   */
  Color getColor() {
    switch (status) {
      case 'IN_PROGRESS':
        return Colors.yellow;
      case 'RECRUIT':
        return Colors.green;
      case 'WAITING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.red;
      case "PREPARED":
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  /*
  * 대항전 일반 참가 코드입력 팝업창
  * @param deptBattleId: 대항전 id, context: BuildContext
  * 생성자 : 이정훈
  * */
  Future<void> showInputDialog(BuildContext context, int deptBattleId) async {
    String userInput = '';
    return showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('대항전 참가'),
          content: CupertinoTextField(
            onChanged: (value) {
              userInput = value;
            },
            placeholder: '초대 코드 입력',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                // 사용자 입력을 처리하는 로직을 추가할 수 있습니다.
                print('사용자 입력: $userInput');
                if (await versusAttend(deptBattleId, userInput) == true) {
                  CustomSnackbar.success(context, "성공", "참가가 되었습니다.", 2);
                } else {
                  CustomSnackbar.error(context, "실패", "참가에 실패했습니다.", 2);
                }
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  /*
  * 대항전 일반 참가 API
  * @param deptBattleId: 대항전 id, invitationCode: 초대 코드
  * @return bool : 성공 or 실패
  * 생성자 : 이정훈
  * */
  Future<bool> versusAttend(int deptBattleId, String invitationCode) async {
    DioApiCall api = DioApiCall();
    final response = await api.post('/deptBattle/attend', {
      'deptBattleId': deptBattleId,
      'guestLeader': await UserData.getMemberIdx(),
      'invitationCode': invitationCode,
    });
    if (response['success']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
