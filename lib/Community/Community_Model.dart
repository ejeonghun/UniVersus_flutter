import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'Community_Widget.dart' show CommunityWidget;
import 'package:flutter/material.dart';

class CommunityModel extends FlutterFlowModel<CommunityWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  Future<List<PostElement>> getPostList(int memberIdx, int categoryId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/univBoard/list?memberIdx=$memberIdx&categoryId=$categoryId');
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
    }
    
    return list;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}
