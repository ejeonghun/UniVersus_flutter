import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'package:universus/club/Components/recommendclub_Model.dart';
import 'package:universus/main/Components/clubElement_Model.dart';
import 'package:universus/main/Components/recruit_Model.dart';
import 'package:universus/main/Components/recruitmentElement.dart';
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
      // 끝에 2자리에 "학교" 라는 단어가 있으면 제거하고 formatSchool 에 저장
      String formatSchool = '';

      if (response['schoolName'] != null &&
          response['schoolName'].endsWith('학교')) {
        formatSchool = response['schoolName']
            .substring(0, response['schoolName'].length - 2);
      } else {
        formatSchool = response['schoolName'];
      }

      return userProfile(
        userName: response['userName'],
        nickname: response['nickname'],
        memberIdx: response['memberIdx'].toString(),
        univName: formatSchool,
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
    String? token;
    if (kIsWeb) {
      // 웹은 권한 요청을 실행하지 않음
    } else {
      // 알림 권한 요청
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        token = await FirebaseMessaging.instance.getToken();
        print("내 디바이스 토큰: $token"); // FCM 토큰
      } else {
        print("알림 권한이 거부되었습니다.");
      }
    }

    try {
      DioApiCall api = DioApiCall();
      String? apiUrl;
      if (token == null) {
        apiUrl = '/club/suggest?memberIdx=${await UserData.getMemberIdx()}';
      } else {
        apiUrl =
            '/club/suggest?memberIdx=${await UserData.getMemberIdx()}&fcmToken=${token}';
      }
      final response = await api.get(apiUrl);

      // 가져온 데이터가 null이거나 List가 아닌 경우 처리
      if (!response.isNotEmpty) {
        print('Failed to fetch club list');
        return [];
      }

      // 클럽 목록 생성
      List<ClubElement> clubList = [];
      for (var clubData in response['data']) {
        clubList.add(ClubElement(
          clubId: clubData['clubId'],
          eventName: clubData['eventName'],
          clubName: clubData['clubName'],
          currentMembers: clubData['currentMembers'],
          imageUrl: clubData['imageUrl'] == ""
              ? 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png'
              : clubData['imageUrl'],
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

  Future<List<RecruitmentElement>> getrecuitmentElement() async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api
        .get('/club/mercenary?memberIdx=${await UserData.getMemberIdx()}');
    if (response.isNotEmpty) {
      // response가 null이 아니면
      // 조회 성공
      print(response);
      List<RecruitmentElement> recruitmentlist = [];
      if (response['data'] == null || response['data'].length == 0) {
        recruitmentlist.add(RecruitmentElement(
            univBoardId: 1000000000,
            title: "모집글을 생성해보세요!",
            eventName: "축구",
            latitude: "",
            longitude: "",
            place: "",
            imageUrl:
                "https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png"));
      } else {
        for (var item in response['data']) {
          recruitmentlist.add(RecruitmentElement(
            univBoardId: item['univBoardId'],
            title: item['title'].toString(),
            eventName: item['eventName'] ?? '',
            latitude: item['lat'] ?? '',
            longitude: item['lng'] ?? '',
            place: item['place'] ?? '',
            imageUrl: item['imageUrl'] ??
                'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          ));
        }
      }
      return recruitmentlist;
    } else {
      // 조회 실패
      print(response);
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
