import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'package:universus/club/Components/recommendclub_Model.dart';
import 'package:universus/main/Components/clubElement_Model.dart';
import 'package:universus/main/Components/recruit_Model.dart';
import 'main_Widget.dart' show MainWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:universus/class/club/clubElement.dart';

class MainModel extends FlutterFlowModel<MainWidget> {
  late ClubElementModel clubElementModel;
  late RecruitModel recruitModel;
  Dio _dio = Dio();

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

  Future<List<ClubElement>> getClubList() async {
    try {
      // API 호출을 위한 URL 설정
      String url =
          'https://moyoapi.lunaweb.dev/api/v1/club/suggest?memberIdx=${await UserData.getMemberIdx()}';

      // Dio를 사용하여 데이터 가져오기
      Response response = await _dio.get(url);

      // 가져온 데이터가 null이거나 List가 아닌 경우 처리
      if (response.data == null || !(response.data is List)) {
        print('Failed to fetch club list');
        return [];
      }

      // 클럽 목록 생성
      List<ClubElement> clubList = [];
      for (var clubData in response.data) {
        clubList.add(ClubElement(
          clubId: clubData['clubId'],
          eventName: clubData['eventName'],
          clubName: clubData['clubName'],
          currentMembers: clubData['currentMembers'],
          imageUrl: clubData['imageUrl'],
        ));
      }

      // 클럽 목록 반환
      debugPrint(clubList.toString());
      return clubList;
    } catch (e) {
      // 오류 처리
      print('Error fetching club list: $e');
      return [];
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
  void initState(BuildContext context) {
    clubElementModel = createModel(context, () => ClubElementModel());
    recruitModel = createModel(context, () => RecruitModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    clubElementModel.dispose();
    recruitModel.dispose();
  }
}
