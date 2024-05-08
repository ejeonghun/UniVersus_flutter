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
        eventName = null;
}
