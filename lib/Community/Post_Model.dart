import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'Post_Widget.dart' show PostWidget;

class PostModel extends FlutterFlowModel<PostWidget> {
  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  Future<PostElement> getPost(int univBoardId) async {
    DioApiCall api = DioApiCall();
    final response =
        await api.get('/univBoard/info?univBoardId=${univBoardId}');
    // 조회 성공
    print(response);
    if (response['success'] == true) {
      return PostElement(
        univBoardId: response['data']['univBoardId'] ?? 0,
        title: response['data']['title'].toString() ?? '',
        content: response['data']['content'] ?? '',
        nickname: response['data']['nickname'] ?? '',
        regDt: response['data']['regDt'] ?? '',
        place: response['data']['place'] ?? '',
        udtDt: response['data']['udtDt'] ?? '', // 이 값이 없을 경우 빈 문자열로 처리됨
        lat: response['data']['lat'] ?? '',
        lng: response['data']['lng'] ?? '',
        eventName: response['data']['eventName'] ?? '',
        categoryName: response['data']['categoryName'] ?? '',
        clubName: response['data']['clubName'] ?? '',
        postImageUrls: (response['data']['postImageUrls'] as List<dynamic>)
            .map<String>((imageUrl) => imageUrl.toString())
            .toList(),

        profileImgUrl: response['data']['profileImgUrl'] ??
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
      );
    } else {
      // 조회 실패
      print(response);
      return PostElement.empty(); // 빈 리스트 반환
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
