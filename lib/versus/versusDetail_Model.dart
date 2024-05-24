import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'versusDetail_Widget.dart' show VersusDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VersusDetailModel extends FlutterFlowModel<VersusDetailWidget> {
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
        await api.get('/univBattle/info?univBattleId=${battleId.toString()}');
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
          battleDate: response['data']['univBattle']['battleDate'],
          lat: response['data']['univBattle']['lat'],
          lng: response['data']['univBattle']['lng'],
          hostTeamName: response['data']['HostTeam']['hostUvName'],
          hostTeamUnivLogo: response['data']['univBattle']['hostUnivLogo'],
          guestTeamName: response['data']['GuestTeam'] != null
              ? response['data']['GuestTeam']['guestUvName']
              : '참가 학교 없음',
          guestTeamUnivLogo: response['data']['univBattle']['guestUnivLogo'],
          univBattleId: response['data']['univBattle']['univBattleId'],
          status: response['data']['univBattle']['matchStatus'],
          hostLeaderId: response['data']['univBattle']['hostLeader'],
          place: response['data']['univBattle']['place'] ?? '없음',
          regDate: response['data']['univBattle']['regDt'],
          endDate: response['data']['univBattle']['endDt'] ?? '',
          invitationCode: response['data']['univBattle']['invitationCode'],
          hostTeamMembers: hostTeamMembers,
          guestTeamMembers: guestTeamMembers,
          content: response['data']['univBattle']['content'],
          cost: response['data']['univBattle']['cost'],
          eventId: response['data']['univBattle']['eventId'],
          guestLeaderId: response['data']['univBattle']['guestLeader'],
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
    final response = await api.post('/univBattle/repAttend', {
      'univBattleId': battleId,
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
        .get('/univBattle/matchStart?univBattleId=${battleId.toString()}');
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
  * @param univBattleId: 대항전 id, context: BuildContext
  * 생성자 : 이정훈
  * */
  Future<void> showInputDialog(BuildContext context, int univBattleId) async {
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
                Map<String, dynamic> result =
                    await versusAttend(univBattleId, userInput);
                if (result['success'] == true) {
                  CustomSnackbar.success(context, "성공", "참가가 되었습니다.", 2);
                } else {
                  CustomSnackbar.error(
                      context, "실패", "${result['message']}", 2);
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
  * @param univBattleId: 대항전 id, invitationCode: 초대 코드
  * @return bool : 성공 or 실패
  * 생성자 : 이정훈
  * */
  Future<Map<String, dynamic>> versusAttend(
      int univBattleId, String invitationCode) async {
    DioApiCall api = DioApiCall();
    final response = await api.post('/univBattle/attend', {
      'univBattleId': univBattleId,
      'memberIdx': await UserData.getMemberIdx(),
      'invitationCode': invitationCode,
    });
    print(response);
    if (response['success']) {
      return response;
    } else {
      return response;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
