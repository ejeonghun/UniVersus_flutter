import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubInfo.dart';
import 'package:universus/class/user/userProfile.dart';
import 'ClubMain_Widget.dart' show ClubMainWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubMainModel extends FlutterFlowModel<ClubMainWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  Future<clubInfo> getClubInfo(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/club/info?clubId=${clubId}');
    if (response['success'] == true) {
      await getLeaderInfo(response['data']['memberIdx']);
      return clubInfo(
        clubId: response['data']['clubId'],
        clubName: response['data']['clubName'],
        clubIntro: response['data']['introduction'],
        price: response['data']['price'],
        clubLeader: response['data']['memberIdx'],
        imageUrl: response['data']['clubImage'][0]['imageUrl'],
        eventId: response['data']['eventId'],
        regDate: response['data']['regDt'],
        currentMembers: response['data']['currentMembers'],
        maximumMembers: response['data']['maximumMembers'],
      );
    } else {
      return clubInfo.nullPut();
    }
  }

  Future<void> getLeaderInfo(int memberIdx) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/member/profile?memberIdx=${memberIdx}');
    if (response['success'] == true) {
      // 조회 성공
      print(response);
      LeaderInfo = userProfile(
          userName: response['userName'],
          nickname: response['nickname'],
          memberIdx: response['memberIdx'].toString(),
          univName: response['schoolName'].toString(),
          deptName: response['deptName'].toString(),
          univLogoImage: response['logoImg'] != null &&
                  response['logoImg'].isNotEmpty
              ? response['logoImg']
              : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-15.png',
          profileImage: response['imageUrl']);
    } else {
      // 조회 실패
      print(response);
      return null;
    }
  }

  userProfile LeaderInfo = userProfile(
    userName: '',
    nickname: '',
    memberIdx: '',
    univName: '',
    deptName: '',
    univLogoImage: '',
    profileImage: '',
  );

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
