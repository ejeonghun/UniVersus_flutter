import 'package:flutterflow_ui/flutterflow_ui.dart';

class clubInfo {
  int clubId; // 클럽 아이디
  int clubLeader; // 클럽 개설자
  String eventId; // 클럽 카테고리
  String clubName; // 클럽 이름
  String clubIntro; // 클럽 소개
  String regDate; // 클럽 생성일
  String? imageUrl; // 클럽 이미지
  int price; // 클럽 회비
  int currentMembers; // 현재 클럽 인원
  int maximumMembers; // 클럽 최대 인원
  String? LeaderProfileImg; // 클럽 개설자 프로필 이미지
  String? LeaderNickname; // 클럽 개설자 닉네임
  int? joinedStatus; // 클럽 가입 여부 0 , 1

  clubInfo({
    required this.clubId,
    required this.clubLeader,
    required this.eventId,
    required this.clubName,
    required this.clubIntro,
    required this.regDate,
    this.imageUrl,
    required this.price,
    required this.currentMembers,
    required this.maximumMembers,
    this.LeaderNickname,
    this.LeaderProfileImg,
    this.joinedStatus,
  });

  String? get getRegDate {
    DateTime parsedDate = DateTime.parse(this.regDate!);
    return DateFormat('yyyy/MM/dd').format(parsedDate);
  }

  static nullPut() {
    return clubInfo(
      clubId: 0,
      clubLeader: 0,
      eventId: "",
      clubName: '',
      clubIntro: '',
      regDate: '',
      imageUrl: '',
      price: 0,
      currentMembers: 0,
      maximumMembers: 0,
    );
  }
}
