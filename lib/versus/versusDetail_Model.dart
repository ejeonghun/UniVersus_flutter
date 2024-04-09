import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'versusDetail_Widget.dart' show VersusDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VersusDetailModel extends FlutterFlowModel<VersusDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  late String status;

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

Future<versusDetail> getVersusDetail(int battleId) async {
  // 대결 리스트를 불러오는 메소드
  DioApiCall api = DioApiCall();
  final response = await api.get('/univBattle/info?univBattleId=${battleId.toString()}');
  if (response.isNotEmpty) {
    // response가 null이 아니면 조회 성공
    List<dynamic> hostParticipantListData = response['data']['HostparticipantList'];
    List<dynamic> guestTeamMembersData = response['data']['GuestparticipantList'];

    List<Map<String, dynamic>> hostTeamMembers = List<Map<String, dynamic>>.from(hostParticipantListData);
    List<Map<String, dynamic>> guestTeamMembers = List<Map<String, dynamic>>.from(guestTeamMembersData);

    versusDetail res = versusDetail(
      battleDate: response['data']['univBattle']['battleDate'],
      lat: response['data']['univBattle']['lat'],
      lng: response['data']['univBattle']['lng'],
      hostTeamName: response['data']['univBattle']['hostUniv'].toString(),
      hostTeamUnivLogo: response['data']['univBattle']['hostUnivLogo'],
      guestTeamName: response['data']['univBattle']['guestUniv'].toString(),
      guestTeamUnivLogo: response['data']['univBattle']['guestUnivLogo'],
      univBattleId: response['data']['univBattle']['univBattleId'],
      status: response['data']['univBattle']['status'],
      hostLeaderId: response['data']['univBattle']['hostLeaderId'],
      place: response['data']['univBattle']['place'],
      regDate: response['data']['univBattle']['regDt'],
      invitationCode: response['data']['univBattle']['invitationCode'],
      hostTeamMembers: hostTeamMembers,
      guestTeamMembers: guestTeamMembers,
      content: response['data']['univBattle']['content'],
      cost: response['data']['univBattle']['cost'],
      eventId: response['data']['univBattle']['eventId'],
    );
    debugPrint(res.getHostTeamMembers.toString());
    status = res.status!;
    return res;
  } else {
    // 조회 실패
    print(response);
    return versusDetail();
  }
}


  Future<String> repAttend(int battleId) async {
    // 대항전 대표 참가
    DioApiCall api = DioApiCall();
    final response = await api.post('/univBattle/repAttend', {
      'univBattleId': battleId,
      'guestLeader': UserData.getMemberIdx(),
    });
    if (response['success'] == true) {
      return response['message'];
    } else {
      return response['message'];
    }
  }

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
      default:
        return '';
    }
  }

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
      default:
        return Colors.white;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
