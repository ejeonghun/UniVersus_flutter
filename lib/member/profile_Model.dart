import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'profile_Widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  Future<userProfile> getProfile() async {
    String? memberIdx = await UserData.getMemberIdx();
    // 사용자 정보를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api.get('/member/profile?memberIdx=${memberIdx}');
    if (response['memberIdx'].toString() == memberIdx) {
      // 조회 성공
      print(response);
      return userProfile(
          userName: response['userName'],
          nickname: response['nickname'],
          univName: response['univId'].toString(),
          deptName: response['deptId'].toString(),
          profileImage: response['profileImage'] != null &&
                  response['profileImage'].isNotEmpty
              ? response['profileImage']
              : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-15.png');
    } else {
      // 조회 실패
      print(response);
      return userProfile.nullPut();
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
