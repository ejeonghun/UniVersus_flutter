class ClubMember {
  final int memberIdx;
  final String nickname;
  final String profileImgUrl;
  final DateTime? joinedDt;

  ClubMember({
    required this.memberIdx,
    required this.nickname,
    required this.profileImgUrl,
    this.joinedDt,
  });
}
