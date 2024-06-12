import 'dart:developer';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubInfo.dart';
import 'package:universus/class/club/clubMember.dart';
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

  late int? clubId;
  String? memberIdx;
  bool? isMemberIdx = false;
  Future<void> getMemberIdx() async {
    memberIdx = await UserData.getMemberIdx();
    isMemberIdx = true;
    debugPrint(memberIdx.toString());
  }

  /**
   * Club 정보 조회
   * @param clubId
   * @return clubInfo 객체:
   * 생성자 : 이정훈
   */
  Future<clubInfo> getClubInfo(int? clubId) async {
    DioApiCall api = DioApiCall();
    debugPrint(memberIdx.toString());
    if (isMemberIdx == false) {
      await getMemberIdx();
    }
    final response =
        await api.get('/club/info?clubId=${clubId}&memberIdx=${memberIdx}');
    if (response['success'] == true) {
      return clubInfo(
          clubId: response['data']['clubId'],
          clubName: response['data']['clubName'] ?? '',
          clubIntro: response['data']['introduction'] ?? '소개 없음',
          price: response['data']['price'] ?? 0,
          clubLeader: response['data']['memberIdx'],
          imageUrl: response['data']['clubImageUrls'].isNotEmpty
              ? response['data']['clubImageUrls'][0]
              : 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          eventId: response['data']['eventName'] ?? '',
          regDate: response['data']['regDt'],
          currentMembers: response['data']['currentMembers'],
          maximumMembers: response['data']['maximumMembers'],
          LeaderNickname: response['data']['nickname'],
          LeaderProfileImg: response['data']['memberImageUrl'],
          joinedStatus: response['data']['joinedStatus']);
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
  Future<List<ClubPost>> getClubPosts(int? clubId) async {
    DioApiCall api = DioApiCall();
    if (isMemberIdx == false) {
      await getMemberIdx();
    }
    final response = await api.get(
        '/univBoard/list?memberIdx=${memberIdx}&clubId=${clubId}&categoryId=1');
    if (response['success'] == true) {
      List<ClubPost> clubPosts = [];
      if (response['data'].isNotEmpty) {
        for (var item in response['data']) {
          debugPrint(item['profileImgUrl'].toString());
          clubPosts.add(ClubPost(
              univBoardId: item['univBoardId'],
              clubName: item['clubName'],
              memberProfileImg: item['profileImgUrl'],
              title: item['title'],
              content: item['content'],
              regDt: item['regDt'],
              imageUrl: item['postImageUrls'] != null &&
                      item['postImageUrls'].isNotEmpty
                  ? item['postImageUrls'][0]
                  : 'none', // 추후 이미지 없을 때 처리 해야함
              categoryName: item['categoryName'],
              nickname: item['nickOrAnon'],
              memberIdx: item['memberIdx']));
        }
        return clubPosts;
      }
      clubPosts.add(ClubPost(
        univBoardId: 0,
        clubName: '게시물이 없습니다',
        memberProfileImg:
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        title: '게시물이 없습니다',
        content: '게시물이 없습니다',
        regDt: DateTime.now().toString(),
        imageUrl:
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        categoryName: 'none',
        nickname: '관리자',
        memberIdx: 0,
      ));
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

  /**
   * Club Member 조회
   * 클럽 관리자만 사용 가능
   * @param clubId
   * @return List<ClubMember>:
   * 생성자 : 이정훈
   */
  Future<List<ClubMember>> getClubMembers(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api
        .get('/club/clubMembersList?clubId=${clubId}&memberIdx=${memberIdx}');
    if (response['success'] == true) {
      List<ClubMember> clubMembers = [];
      for (var item in response['data']) {
        clubMembers.add(ClubMember(
          memberIdx: item['memberIdx'],
          nickname: item['nickname'],
          profileImgUrl: item['profileImgUrl'],
        ));
      }
      return clubMembers;
    } else {
      return [];
    }
  }

  /**
   * Club 멤버 추방
   * 클럽 관리자만 사용 가능
   * @param clubId, expelMemberIdx
   * @return bool:
   * 생성자 : 이정훈
   */
  Future<bool?> expel(int clubId, int expelMemberIdx) async {
    DioApiCall api = DioApiCall();
    final response = await api.deleteForData('/club/expel', {
      'clubId': clubId,
      'expelMemberIdx': expelMemberIdx,
      'memberIdx': await UserData.getMemberIdx(),
    });
    if (response['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  /* 
  * Club 해체
  * 클럽 관리자만 사용 가능
  * @param clubId, memberIdx
  * @return bool:
  * 생성자 : 이정훈
  */
  Future<bool?> deleteClub(int clubId) async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    debugPrint(memberIdx);
    final response = await api
        .delete('/club/delete?clubId=${clubId}&memberIdx=${memberIdx}');
    if (response['success'] == true) {
      return true;
    } else {
      debugPrint(response.toString());
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
