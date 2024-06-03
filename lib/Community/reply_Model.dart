import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/replyElement.dart';
import 'package:universus/Community/reply_Widget.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/IOSAlertDialog.dart';

class ReplyModel extends FlutterFlowModel<ReplyWidget> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

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

  Future<void> modifyReply(int replyId, String content, BuildContext context) async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    IOSAlertDialog.confirm(
      context: context,
      title: '댓글 수정',
      content: '댓글을 수정하시겠습니까?',
      onConfirm: () async {
        final response = await api.modify(
          '/reply/modify',
          {
            'replyId': replyId,
            'content': content,
            'memberIdx': memberIdx,
            'anonymous' : 0,
          },
        );
        if (response['data'] == true) {
          IOSAlertDialog.show(
              content: '댓글이 수정되었습니다.', title: '성공', context: context);
        } else {
          return IOSAlertDialog.show(
              content: '다른 회원이 작성한 댓글을 수정할 수 없습니다.',
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
