import 'dart:developer';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubInfo.dart';
import 'package:universus/class/club/clubPost.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'package:universus/club/Components/clubPost_Model.dart';
import 'ClubMain_Widget.dart' show ClubMainWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubMainModel extends FlutterFlowModel<ClubMainWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  late ClubPostModel clubPostModel;

  /**
   * Club 정보 조회
   * @param clubId
   * @return clubInfo 객체:
   * 생성자 : 이정훈
   */
  Future<clubInfo> getClubInfo(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/club/info?clubId=${clubId}');
    if (response['success'] == true) {
      return clubInfo(
          clubId: response['data']['clubId'],
          clubName: response['data']['clubName'],
          clubIntro: response['data']['introduction'],
          price: response['data']['price'],
          clubLeader: 0,
          imageUrl: response['data']['clubImageUrls'].isNotEmpty
              ? response['data']['clubImageUrls'][0]
              : 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          eventId: response['data']['eventName'],
          regDate: response['data']['regDt'],
          currentMembers: response['data']['currentMembers'],
          maximumMembers: response['data']['maximumMembers'],
          LeaderNickname: response['data']['nickname'],
          LeaderProfileImg: response['data']['memberImageUrl']);
    } else {
      return clubInfo.nullPut();
    }
  }

  /**
   * Club 게시글 조회
   * @param clubId
   * @return List<clubPost> 객체:
   * 생성자 : 이정훈
   */
  Future<List<ClubPost>> getClubPosts(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get(
        '/univBoard/list?memberIdx=${await UserData.getMemberIdx()}&clubId=${clubId}&categoryId=1');
    if (response['success'] == true) {
      List<ClubPost> clubPosts = [];
      for (var item in response['data']) {
        clubPosts.add(ClubPost(
          univBoardId: item['univBoardId'],
          clubName: item['clubName'],
          memberProfileImg: item['profileImgUrl'],
          title: item['title'],
          content: item['content'],
          regDt: item['regDt'],
          imageUrl:
              item['postImageUrls'] != null && item['postImageUrls'].isNotEmpty
                  ? item['postImageUrls'][0]
                  : 'none', // 추후 이미지 없을 때 처리 해야함
          categoryName: item['categoryName'],
          nickname: item['nickname'],
        ));
      }
      return clubPosts;
    } else {
      return [];
    }
  }

  /**
   * Club 가입
   * @param clubId
   * @return bool:
   * 생성자 : 이정훈
   */
  Future<bool> joinClub(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.post('/club/join', {
      'memberIdx': await UserData.getMemberIdx(),
      'clubId': clubId,
    });
    if (response['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState(BuildContext context) {
    clubPostModel = createModel(context, () => ClubPostModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    clubPostModel.dispose();
  }
}
