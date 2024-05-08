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

  Future<clubInfo> getClubInfo(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/club/info?clubId=${clubId}');
    if (response['success'] == true) {
      return clubInfo(
          clubId: response['data']['clubId'],
          clubName: response['data']['clubName'],
          clubIntro: response['data']['introduction'],
          price: response['data']['price'],
          clubLeader: response['data']['memberIdx'],
          imageUrl: response['data']['clubImage'].isNotEmpty
              ? response['data']['clubImage'][0]['imageUrl']
              : 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
          eventId: response['data']['eventId'],
          regDate: response['data']['regDt'],
          currentMembers: response['data']['currentMembers'],
          maximumMembers: response['data']['maximumMembers'],
          LeaderNickname: response['data']['leaderNickname'],
          LeaderProfileImg: response['data']['leaderProfileImg']);
    } else {
      return clubInfo.nullPut();
    }
  }

  Future<List<ClubPost>> getClubPosts(int clubId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get(
        '/univBoard/list?memberIdx=${await UserData.getMemberIdx()}&clubId=${clubId}');
    if (response['success'] == true) {
      List<ClubPost> clubPosts = [];
      for (var item in response['data']) {
        clubPosts.add(ClubPost(
          univBoardId: item['univBoardId'],
          clubName: item['clubName'],
          memberIdx: item['memberIdx'],
          memberProfileImg: item['memberProfileImg'],
          title: item['title'],
          content: item['content'],
          regDt: item['regDt'],
          imageUrl: item['imageUrl'],
          categoryName: item['categoryName'],
          nickname: item['nickname'],
        ));
      }
      return clubPosts;
    } else {
      return [];
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
