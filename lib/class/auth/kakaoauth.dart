class KakaoAuthDto {
  String? email;
  String? memberidx;
  String? nickname;
  String? accessToken;
  int? memberStatus; // 기존회원인지 신규회원인지 확인
  // 0 : 기존회원 , 1 : 신규회원 , 2 : 에러

  KakaoAuthDto(
      {required this.email,
      required this.memberidx,
      required this.nickname,
      required this.accessToken,
      required this.memberStatus});
}
