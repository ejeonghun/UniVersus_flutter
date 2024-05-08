import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:universus/Community/replyElement.dart';
import 'dart:convert';
import 'package:universus/Community/reply_Widget.dart';
import 'package:universus/class/api/DioApiCall.dart';

class replyModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();



  Future<void> postComment(int univBoardId, String content) async {
    final url = Uri.parse('https://moyoapi.lunaweb.dev/api/v1/comment/write');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'univBoardId': univBoardId, 'content': content});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // 댓글이 성공적으로 작성됨
        // 필요한 경우 여기서 새로운 댓글을 가져오는 메서드를 호출할 수 있습니다.
        // getComments(univBoardId);
      } else {
        throw Exception('Failed to post comment');
      }
    } catch (e) {
      print('Error posting comment: $e');
    }
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }
}
