class KakaoAuthDto {
  String? email; // 카카오 이메일
  int? kakaoIdx; // 카카오 idx값
  String? nickname;
  String? birthday; // 생년월일 (MMDD)
  String? birthyear; // 출생년도 (YYYY)
  String? gender; // 성별 (famale, male, other)
  String? phoneNumber; // 카카오톡에서 인증한 전화번호
  String? name; // 카카오계정 이름(본명)
  int memberStatus; // 기존회원인지 신규회원인지 확인
  // 0 : 기존회원 , 1 : 신규회원 , 2 : 에러

  KakaoAuthDto({this.email, this.kakaoIdx, this.nickname, 
   this.birthday,  this.birthyear,  this.gender, 
   this.phoneNumber,  this.name,  required this.memberStatus});


}