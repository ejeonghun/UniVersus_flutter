import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'profile_Widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// 사용자 프로필 페이지 모델 클래스
/// 생성자 : 이정훈
class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  /// 사용자 프로필 정보를 불러오는 메소드
  /// @param memberIdx
  /// @return userProfile
  /// 생성자 : 이정훈
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
      return userProfile.nullPut();
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
