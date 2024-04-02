class userProfile {
  String userName;
  String nickname;
  String univName;
  String deptName;
  String profileImage;
  String memberIdx;
  String phone; // 사용해도되고 안해도 됨 현재(updateProfile)에서 사용함
  String oneLineIntro;

  userProfile(
      {required this.userName,
      required this.nickname,
      required this.univName,
      required this.deptName,
      required this.profileImage,
      required this.memberIdx,
      this.phone = '',
      this.oneLineIntro = ''});

  static userProfile nullPut() {
    return userProfile(
        userName: '정보를 가져오는데 실패했습니다.',
        nickname: '재시도',
        univName: '',
        deptName: '',
        profileImage: '',
        memberIdx: '');
  }

// getter
  String get getUserName => userName;
  String get getNickname => nickname;
  String get getUnivName => univName;
  String get getDeptName => deptName;
  String get getProfileImage => profileImage;
  String get getMemberIdx => memberIdx;
  String get getPhone => phone;
  String get getOneLineIntro => oneLineIntro;
}
