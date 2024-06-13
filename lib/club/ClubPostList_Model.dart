import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'ClubPostList_Widget.dart' show ClubPostListWidget;
import 'package:flutter/material.dart';

class CommunityModel extends FlutterFlowModel<ClubPostListWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  String? memberIdx;
  Future<void> getMemberIdx() async {
    memberIdx = await UserData.getMemberIdx();
  }

  Future<List<PostElement>> getPostList(int clubId) async {
    String? _memberIdx = await UserData.getMemberIdx();
    DioApiCall api = DioApiCall();
    final response = await api.get(
        '/univBoard/list?memberIdx=${_memberIdx}&clubId=${clubId}&categoryId=1');
    List<PostElement> list = [];
    debugPrint(memberIdx.toString());
    if (response['data'] == null) {
      list.add(PostElement.empty());
    } else {
      for (var data in response['data']) {
        list.add(PostElement(
          univBoardId: data['univBoardId'] ?? 0,
          title: data['title'].toString() ?? '',
          content: data['content'] ?? '',
          nickname: data['nickname'] ?? '',
          regDt: data['regDt'] ?? '',
          place: data['place'] ?? '',
          udtDt: data['udtDt'] ?? '',
          lat: data['lat'] ?? '',
          lng: data['lng'] ?? '',
          eventName: data['eventName'] ?? '',
          categoryName: data['categoryName'] ?? '',
          clubName: data['clubName'] ?? '',
          postImageUrls: (data['postImageUrls'] as List<dynamic>?)
                  ?.map<String>((imageUrl) => imageUrl.toString())
                  .toList() ??
              [],
          profileImgUrl: data['profileImgUrl'] ??
              'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        ));
      }
      debugPrint(list.toString());
    }

    return list;
  }

  /*
 * 유저 프로필 정보 조회
 * @return userProfile 객체:
 * 생성자 : 이정훈
 * */
  Future<userProfile> getProfile() async {
    String? memberIdx = await UserData.getMemberIdx();
    // 사용자 정보를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api.get('/member/profile?memberIdx=${memberIdx}');
    if (response['memberIdx'].toString() == memberIdx) {
      // 조회 성공
      print(response);
      String formatSchool = '';
      // 끝에 2자리에 "학교" 라는 단어가 있으면 제거하고 formatSchool 에 저장
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}
