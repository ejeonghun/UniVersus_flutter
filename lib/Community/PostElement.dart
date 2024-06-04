import 'package:flutterflow_ui/flutterflow_ui.dart';

class PostElement {
  int univBoardId;
  String nickname;
  String categoryName;
  String? clubName;
  String title;
  String content;
  String regDt;
  String? udtDt; // Nullable
  List<String> postImageUrls; // Specify type as List<String>
  String? lat; // Nullable
  String? lng; // Nullable
  String? place;
  String? eventName;
  String? profileImgUrl;
  int? PostMemberIdx;
  int? categoryId;

  PostElement({
    required this.univBoardId,
    required this.nickname,
    required this.categoryName,
    this.clubName, // Make nullable
    required this.title,
    required this.content,
    required this.regDt,
    this.udtDt, // Make nullable
    required this.postImageUrls,
    this.lat, // Make nullable
    this.lng, // Make nullable
    this.place,
    this.eventName,
    this.profileImgUrl,
    this.PostMemberIdx,
    this.categoryId,
  });

  get getProfileImgUrl =>
      profileImgUrl ??
      'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png';

  PostElement.empty()
      : univBoardId = 0,
        nickname = '',
        categoryName = '',
        clubName = null, // Initialize as null
        title = '',
        content = '',
        regDt = '',
        postImageUrls = [],
        lat = null, // Initialize as null
        lng = null, // Initialize as null
        place = null,
        eventName = null,
        profileImgUrl = null,
        PostMemberIdx = 0;

  String getFormattedDate() {
    // Assuming regDt is in ISO 8601 format, for example "2023-05-21T10:30:00"
    DateTime dateTime = DateTime.parse(regDt);
    return DateFormat('MM/dd HH:mm').format(dateTime);
  }

  static nullput() {
    return PostElement(
        univBoardId: 0,
        nickname: '',
        categoryName: '공지',
        title: '게시글 작성해보세요',
        content: '네',
        regDt: DateTime.now().toString(),
        postImageUrls: []);
  }
}
