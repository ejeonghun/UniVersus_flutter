
class Reply {
  final String profileImageUrl;
  final String nickname;
  final String content;
  final String timestamp;

  Reply({
    required this.profileImageUrl,
    required this.nickname,
    required this.content,
    required this.timestamp,
  });

  static empty() {
    return Reply(
      profileImageUrl: 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
      nickname: '사용자',
      content: '첫 댓글을 작성해보세요!',
      timestamp: DateTime.now().toString()
    );
  }
}
