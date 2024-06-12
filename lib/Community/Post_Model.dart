import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/Community/replyElement.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/IOSAlertDialog.dart';
import 'Post_Widget.dart' show PostWidget;

class PostModel extends FlutterFlowModel<PostWidget> {
  DioApiCall api = DioApiCall();
  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool? anonymousCheck = false;

  int get anonymousCheckInt => anonymousCheck! ? 1 : 0;

  void getMemberIdx() async {
    memberIdx = await UserData.getMemberIdx();
  }

  String? memberIdx;

  @override
  void initState(BuildContext context) {}

  /*
 * 댓글 조회
 * @param univBoardId: 게시글 아이디
 * @return PostElement: 게시글 정보
 * @throws Exception: 게시글 조회 실패 시 예외 발생
 * 생성자 : 이정훈
 * */
  Future<PostElement> getPost(int univBoardId) async {
    DioApiCall api = DioApiCall();
    final response =
        await api.get('/univBoard/info?univBoardId=${univBoardId}');
    // 조회 성공
    print(response);
    if (response['success'] == true) {
      return PostElement(
        univBoardId: response['data']['univBoardId'] ?? 0,
        title: response['data']['title'].toString() ?? '제목 없음',
        content: response['data']['content'] ?? '',
        nickname: response['data']['nickOrAnon'] ?? '',
        regDt: response['data']['regDt'] ?? '',
        place: response['data']['place'] ?? '',
        udtDt: response['data']['udtDt'] ?? '',
        lat: response['data']['lat'] ?? '',
        lng: response['data']['lng'] ?? '',
        eventName: response['data']['eventName'] ?? '',
        categoryName: response['data']['categoryName'] ?? '',
        clubName: response['data']['clubName'] ?? '',
        PostMemberIdx: response['data']['memberIdx'] ?? 0,
        postImageUrls: (response['data']['postImageUrls'] as List<dynamic>)
            .map<String>((imageUrl) => imageUrl.toString())
            .toList(),
        // postImage 배열로 불러온다.
        categoryId: response['data']['categoryId'],
        profileImgUrl: response['data']['profileImgUrl'] ??
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        eventId: response['data']['eventId'],
      );
    } else {
      // 조회 실패
      print(response);
      return PostElement.empty(); // 빈 Post 반환
    }
  }

  /*
 * 댓글 조회
 * @param univBoardId: 게시글 아이디
 * @return List<Reply>: 댓글 리스트
 * @throws Exception: 댓글 조회 실패 시 예외 발생
 * 생성자 : 이정훈
 * */
  Future<List<Reply>> getReply(int univBoardId) async {
    DioApiCall api = DioApiCall();
    final response = await api.get('/reply/list?univBoardId=${univBoardId}');
    List<Reply> replies = [];

    // 조회 성공
    if (response['success'] == true) {
      debugPrint(response.toString());
      if (response['data'] == null) {
        Reply reply = Reply.empty();
        // 댓글이 없으면 "첫 댓글을 작성해보세요!" 라는 댓글을 반환
        replies.add(reply);
        return replies;
      }
      for (var data in response['data']) {
        Reply reply = Reply(
          profileImageUrl: data['profileImgUrl'] ?? '',
          nickname: data['nickOrAnon'] ?? '',
          content: data['content'] ?? '',
          timestamp: data['lastDt'] ?? '',
          replyId: data['replyId'] ?? 0,
        );
        replies.add(reply);
      }
    } else {
      print('Failed to load replies');
    }
    debugPrint(replies.toString());
    return replies;
  }

  Future<void> postComment(int univBoardId, String content) async {
    DioApiCall api = DioApiCall();
    final response = await api.post('/reply/create', {
      'univBoardId': univBoardId,
      'content': content,
      'memberIdx': memberIdx,
      'anonymous': anonymousCheckInt,
    });
    debugPrint('${memberIdx} ${content}, ${univBoardId}, ${anonymousCheckInt}');

    if (response['success'] == true) {
      // 댓글이 성공적으로 작성됨
      // 필요한 경우 여기서 새로운 댓글을 가져오는 메서드를 호출할 수 있습니다.
      // getComments(univBoardId);
    } else {}
  }

  Future<void> deletePost(int univBoardId, BuildContext context) async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    IOSAlertDialog.confirm(
      context: context,
      title: '게시글 삭제',
      content: '게시글을 삭제하시겠습니까?',
      onConfirm: () async {
        final response = await api.delete(
            '/univBoard/delete?univBoardId=${univBoardId}&memberIdx=${memberIdx}');
        if (response['success'] == true) {
          return IOSAlertDialog.show(
              content: '게시글이 삭제되었습니다.', title: '성공', context: context);
        } else {
          return IOSAlertDialog.show(
              content: '다른 회원이 작성한 게시글을 삭제할 수 없습니다.',
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
    debugPrint(univBoardId.toString());
  }

  Future<void> modifyPost(PostElement post, BuildContext context) async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();

    // 사용자 확인을 받음
    IOSAlertDialog.confirm(
      context: context,
      title: '게시글 수정',
      content: '게시글을 수정하시겠습니까?',
      onConfirm: () async {
        // 사용자가 확인을 눌렀을 때 실행될 콜백
        final response;
        if (post.eventId == null) {
          response = await api.modifyPost(
              '/univBoard/modify?univBoardId=${post.univBoardId}&memberIdx=${memberIdx}&title=${post.title}&content=${post.content}&anonymous=${0}&categoryId=${post.categoryId}');
        } else {
          response = await api.modifyPost(
              '/univBoard/modify?univBoardId=${post.univBoardId}&memberIdx=${memberIdx}&title=${post.title}&content=${post.content}&anonymous=${0}&categoryId=${post.categoryId}&eventId=${post.eventId}');
        }

        debugPrint("Response: $response");

        if (response['success'] == true) {
          IOSAlertDialog.show(
              content: '게시글이 수정되었습니다.', title: '성공', context: context);
        } else {
          IOSAlertDialog.show(
              content: '다른 회원이 작성한 게시글을 수정할 수 없습니다.',
              title: '실패',
              context: context);
        }
      },
      onCancel: () {
        // 뒤로가기 또는 취소 동작
      },
    );

    debugPrint("실행");
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
