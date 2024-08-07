import 'package:intl/intl.dart';

class versusDetail {
  // 대항전 상세 정보
  String? hostTeamName; // 대표 팀 학교 이름
  String? hostTeamDept; // 대표 팀 학과
  String? hostTeamUnivLogo; // 대표 팀 로고
  String? guestTeamName; // 게스트 팀 학교 이름
  String? guestTeamDept; // 게스트 팀 학과
  String? guestTeamUnivLogo; // 게스트 팀 로고
  int? BattleId; // 대항전 id
  String? status; // 대항전 상태
  int? hostLeaderId; // 대항전 생성자 memberId -> 관리자 메뉴 권한 추가
  int? guestLeaderId; // 대항전 생성자 memberId -> 관리자 메뉴 권한 추가
  String? lat; // 대항전 장소 위도
  String? lng; // 대항전 장소 경도
  String? place; // 대항전 장소
  String? battleDate; // 대항전 날짜
  String? regDate; // 대항전 등록 날짜
  String? invitationCode; // 대항전 초대 코드
  String? content; // 대항전 내용
  String? cost; // 비용
  int? eventId;
  DateTime? matchStartDt; // 대항전 시작 시간
  String? winUnivName; // 이긴 대학교 이름
  int? hostUnivId; // 대표 팀 대학 id
  int? guestUnivId; // 게스트 팀 대학 id
  String? endDate; // 대항전 종료 날짜
  int? hostScore; // 대표 팀 점수
  int? guestScore; // 게스트 팀 점수
  int? winUniv; // 이긴 대학 univId

  // 팀 정보
  List<Map<String, dynamic>>? hostTeamMembers; // 대표 팀 멤버 리스트
  List<Map<String, dynamic>>? guestTeamMembers; // 게스트 팀 멤버 리스트

  versusDetail({
    this.hostTeamName,
    this.hostTeamDept,
    this.hostTeamUnivLogo,
    this.guestTeamName,
    this.guestTeamDept,
    this.guestTeamUnivLogo,
    this.BattleId,
    this.status,
    this.hostLeaderId,
    this.guestLeaderId,
    this.lat,
    this.lng,
    this.place,
    this.battleDate,
    this.regDate,
    this.invitationCode,
    this.hostTeamMembers,
    this.guestTeamMembers,
    this.content,
    this.cost,
    this.eventId,
    this.matchStartDt,
    this.winUnivName,
    this.hostUnivId,
    this.guestUnivId,
    this.endDate,
    this.hostScore,
    this.guestScore,
    this.winUniv,
  });

  // Getter methods
  String? get getHostTeamName => this.hostTeamName;
  String? get getHostTeamDept => this.hostTeamDept;
  String? get getHostTeamUnivLogo => this.hostTeamUnivLogo;
  String? get getGuestTeamName => this.guestTeamName;
  String? get getGuestTeamDept => this.guestTeamDept;
  String? get getGuestTeamUnivLogo => this.guestTeamUnivLogo;
  int? get getUnivBattleId => this.BattleId;
  String? get getStatus => this.status;
  int? get getHostLeaderId => this.hostLeaderId;
  int? get getGuestLeaderId => this.guestLeaderId ?? 0;
  double? get getLat => double.parse(this.lat!);
  double? get getLng => double.parse(this.lng!);
  String? get getPlace => this.place;
  String? get getBattleDate {
    DateTime parsedDate = DateTime.parse(this.battleDate!);
    return DateFormat('yyyy/MM/dd').format(parsedDate);
  }

  String? get getRegDate {
    DateTime parsedDate = DateTime.parse(this.regDate!);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String? get getEndDate {
    DateTime parsedDate = DateTime.parse(this.endDate!);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String? get getInvitationCode => this.invitationCode;
  List<Map<String, dynamic>>? get getHostTeamMembers => this.hostTeamMembers;
  List<Map<String, dynamic>>? get getGuestTeamMembers => this.guestTeamMembers;
  String? get getContent => this.content;
  String? get getCost => this.cost;
  int? get getEventId => this.eventId;
  int? get getHostUnivId => this.hostUnivId;
  int? get getGuestUnivId => this.guestUnivId;
}
