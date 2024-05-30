import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:universus/Community/replyElement.dart';
import 'dart:convert';
import 'package:universus/Community/reply_Widget.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/IOSAlertDialog.dart';

class ReplyModel extends FlutterFlowModel<ReplyWidget> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  /**
   * 댓글 삭제
   * @param replyId: 댓글 아이디
   * @return bool: 댓글 삭제 성공 여부
   * @throws Exception: 댓글 삭제 실패 시 예외 발생
   * 생성자 : 이정훈
  */
  @override
  void initState(BuildContext context) {}

  Future<void> deleteReply(int replyId, BuildContext context) async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    IOSAlertDialog.confirm(
      context: context,
      title: '댓글 삭제',
      content: '댓글을 삭제하시겠습니까?',
      onConfirm: () async {
        final response = await api
            .delete('/reply/delete?replyId=${replyId}&memberIdx=${memberIdx}');
        if (response['data'] == true) {
          return IOSAlertDialog.show(
              content: '댓글이 삭제되었습니다.', title: '성공', context: context);
        } else {
          return IOSAlertDialog.show(
              content: '다른 회원이 작성한 댓글을 삭제할 수 없습니다.',
              title: '실패',
              context: context);
        }
      },
      onCancel: () {
        // 뒤로가기
      },
    );
    debugPrint("실행");
    debugPrint(memberIdx);
    debugPrint(replyId.toString());
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocusNode.dispose();
  }
}
