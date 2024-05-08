class RecruitmentElement {
  int univBoardId;
  String title;
  String eventName;
  String latitude;
  String longitude;
  String place;
  String? imageUrl;

  RecruitmentElement({
    required this.univBoardId,
    required this.title,
    required this.eventName,
    required this.latitude,
    required this.longitude,
    required this.place,
    this.imageUrl,
  });

  get getImageUrl =>
      imageUrl ??
      'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png';
}
