class ClubElement {
  int clubId;
  String eventName;
  String clubName;
  String? introduction;
  int currentMembers;
  String imageUrl;
  String? joinedDate;

  ClubElement({
    required this.clubId,
    required this.eventName,
    required this.clubName,
    this.introduction,
    required this.currentMembers,
    required this.imageUrl,
    this.joinedDate,
  });


}
