import 'dart:ui';

class PostElement {
  int univBoardId;
  int memberIdx;
  String nickname;
  String categoryName;
  String clubName;
  String title;
  String content;
  String regDt;
  String udtDt; // This is nullable
  List postImageUrls;
  String lat; // These are nullable
  String lng;
  String place;
  String eventName;

  PostElement({
    required this.univBoardId,
    required this.memberIdx,
    required this.nickname,
    required this.categoryName,
    required this.clubName,
    required this.title,
    required this.content,
    required this.regDt,
    required this.udtDt,
    required this.postImageUrls,
    required this.lat,
    required this.lng,
    required this.place,
    required this.eventName,
  });

   PostElement.empty()
      : univBoardId = 0,
        memberIdx = 0,
        nickname = '',
        categoryName = '',
        clubName = '',
        title = '',
        content = '',
        regDt = '',
        udtDt = '',
        postImageUrls = [],
        lat = '',
        lng = '',
        place = '',
        eventName = '';
}