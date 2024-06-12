class versusElement {
  String? hostTeamName; // 대표 팀 학교 이름
  String? hostTeamDept; // 대표 팀 학과
  String? hostTeamUnivLogo; // 대표 팀 로고
  String? guestTeamName; // 게스트 팀 학교 이름
  String? guestTeamDept; // 게스트 팀 학과
  String? guestTeamUnivLogo; // 게스트 팀 로고
  int? univBattleId; // 대항전 id
  String? status; // 대항전 상태
  String? content; // 대항전 내용
  int? deptBattleId; // 학과 대항전 id
  int? eventId; //대항전 카테고리 id

  versusElement(
      {this.hostTeamName,
      this.hostTeamDept,
      this.hostTeamUnivLogo,
      this.guestTeamName,
      this.guestTeamDept,
      this.guestTeamUnivLogo,
      this.univBattleId,
      this.status,
      this.content,
      this.eventId,
      this.deptBattleId});

  // Getter methods
  String? get getHostTeamName => this.hostTeamName;
  String? get getHostTeamDept => this.hostTeamDept;
  String? get getHostTeamUnivLogo => this.hostTeamUnivLogo;
  String? get getGuestTeamName => this.guestTeamName;
  String? get getGuestTeamDept => this.guestTeamDept;
  String? get getGuestTeamUnivLogo => this.guestTeamUnivLogo;
  int? get getUnivBattleId => this.univBattleId;
  String? get getStatus => this.status;
  String? get getContent => this.content;
  int? get getDeptBattleId => this.deptBattleId;
  int? get getEventId => this.eventId;
}
