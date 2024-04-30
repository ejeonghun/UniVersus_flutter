import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'main_Widget.dart' show MainWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainModel extends FlutterFlowModel<MainWidget> {
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
        profileImage: response['profileImage'] != null &&
                response['profileImage'].isNotEmpty
            ? response['profileImage'][0]['imageUrl']
            : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-15.png',
      );
    } else {
      // 조회 실패
      print(response);
      return userProfile.nullPut();
    }
  }

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
