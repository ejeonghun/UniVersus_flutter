class userProfile {
  String userName;
  String nickname;
  String univName;
  String deptName;
  String profileImage;

  userProfile(
      {required this.userName,
      required this.nickname,
      required this.univName,
      required this.deptName,
      required this.profileImage});

  static userProfile nullPut() {
    return userProfile(
        userName: '정보를 가져오는데 실패했습니다.',
        nickname: '재시도',
        univName: '',
        deptName: '',
        profileImage: '');
  }

// getter
  String get getUserName => userName;
  String get getNickname => nickname;
  String get getUnivName => univName;
  String get getDeptName => deptName;
  String get getProfileImage => profileImage;
}
