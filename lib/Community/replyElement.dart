import 'package:flutterflow_ui/flutterflow_ui.dart';

class Reply {
  final String profileImageUrl;
  final String nickname;
  final String content;
  final String timestamp;
  final int replyId;
  final int memberIdx;

  Reply({
    required this.profileImageUrl,
    required this.nickname,
    required this.content,
    required this.timestamp,
    required this.replyId,
    required this.memberIdx,
  });

  String getFormattedDate() {
    // Assuming timestamp is in ISO 8601 format, for example "2023-05-21T10:30:00"
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('MM/dd HH:mm').format(dateTime);
  }

  static empty() {
    return Reply(
        profileImageUrl:
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        nickname: '사용자',
        content: '첫 댓글을 작성해보세요!',
        timestamp: DateTime.now().toString(),
        replyId: 0,
        memberIdx: 0);
  }
}
