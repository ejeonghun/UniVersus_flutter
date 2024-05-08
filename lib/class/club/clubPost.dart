import 'package:flutterflow_ui/flutterflow_ui.dart';

class ClubPost {
  int univBoardId; // 게시글 id
  int memberIdx; // 게시글 작성자
  String categoryName; // 카테고리 이름
  String clubName; // 동아리 이름
  String title; // 게시글 제목
  String content; // 게시글 내용
  String regDt; // 게시글 작성일
  String? imageUrl; // 게시글 이미지
  String nickname; // 게시글 작성자 닉네임
  String? memberProfileImg; // 게시글 작성자 프로필 이미지

  ClubPost({
    required this.univBoardId,
    required this.memberIdx,
    required this.categoryName,
    required this.clubName,
    required this.title,
    required this.content,
    required this.regDt,
    this.imageUrl,
    required this.nickname,
    this.memberProfileImg,
  });

  String? get getRegDt {
    DateTime parsedDate = DateTime.parse(this.regDt!);
    return DateFormat('yyyy.MM.dd hh:mm').format(parsedDate);
  }
}
