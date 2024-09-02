
```
# 모델 : 백엔드 및 기능 작동 부분


lib
├─ auth # 인증 관련
│  ├─ AdditionalInfo_Model.dart        # 추가정보기입 모델
│  ├─ AdditionalInfo_Widget.dart       # 추가정보기입 UI
│  ├─ CreateAccount_Model.dart         # 계정생성 모델
│  ├─ CreateAccount_Widget.dart        # 계정생성 UI
│  ├─ Login_Model.dart                 # 로그인 모델
│  ├─ Login_Widget.dart                # 로그인 UI
│  ├─ PasswordChange_Model.dart        # 비밀번호 변경 모델
│  ├─ PasswordChange_Widget.dart       # 비밀번호 변경 UI
│  ├─ PasswordForget_Model.dart        # 비밀번호 찾기 모델
│  ├─ PasswordForget_Widget.dart       # 비밀번호 찾기 UI
│  └─ tmp
│     ├─ CreateAccount_Model2.dart
│     ├─ CreateAccount_Widget2.dart
│     ├─ KakaoLogin.dart
│     └─ KakaoLogin3.dart
├─ BottomBar2.dart                     # 하단바 UI
├─ chat                                # 채팅
│  ├─ chatList.dart                    # 채팅방 리스트 UI
│  ├─ chatRoom.dart                    # 채팅방 UI 및 기능
│  ├─ chats_Model.dart                 # 채팅방 리스트 모델
│  └─ createChatRoom.dart             
├─ class
│  ├─ api
│  │  ├─ ApiCall.dart                  # API 통신 기능 커스텀 클래스
│  │  └─ DioApiCall.dart               # API 통신 기능 커스텀 클래스
│  ├─ auth
│  ├─ club
│  │  ├─ clubElement.dart              # 클럽 요소 데이터 클래스
│  │  ├─ clubInfo.dart                 # 클럽 정보 데이터 클래스
│  │  ├─ clubMember.dart               # 클럽 멤버 데이터 클래스
│  │  └─ clubPost.dart                 # 클럽 게시글 데이터 클래스
│  ├─ permission
│  ├─ theme
│  ├─ user
│  │  ├─ user.dart                     # 유저 정보 FlutterSecureStorage 저장 커스텀 클래스
│  │  └─ userProfile.dart              # 유저 프로필 정보 데이터 클래스
│  └─ versus
│     ├─ versusDetail.dart             # 대항전 정보 데이터 클래스
│     └─ versusElement.dart            # 대항전 리스트 조회 시 요소 데이터 클래스
├─ club
│  ├─ ClubList_Model.dart              # 클럽 리스트 모델
│  ├─ ClubList_Widget.dart             # 클럽 리스트 UI
│  ├─ ClubMain_Model.dart              # 클럽 메인 모델
│  ├─ ClubMain_Widget.dart             # 클럽 메인 UI
│  ├─ ClubPostList_Model.dart          # 클럽 게시글 리스트(커뮤니티) 모델
│  ├─ ClubPostList_Widget.dart         # 클럽 게시글 리스트(커뮤니티) UI
│  ├─ ClubPostWrite_Model.dart         # 클럽 게시글 작성(커뮤니티) 모델
│  ├─ ClubPostWrite_Widget.dart        # 클럽 게시글 작성(커뮤니티) UI
│  ├─ Components
│  │  ├─ clublist_ex_Model.dart        # 메인 페이지 클럽 더보기 요소 모델
│  │  ├─ clublist_ex_Widget.dart       # 메인 페이지 클럽 더보기 요소 UI
│  │  ├─ clubPost_Model.dart           # 클럽 게시글 요소 모델
│  │  ├─ clubPost_Widget.dart          # 클럽 게시글 요소 UI
│  │  ├─ MyClubComponent_Model.dart    # 내 클럽 요소 모델
│  │  ├─ MyClubComponent_Widget.dart   # 내 클럽 요소 UI
│  │  ├─ recommendclub_Model.dart      # 메인페이지 클럽 요소 모델
│  │  └─ recommendclub_Widget.dart     # 메인페이지 클럽 요소 UI
│  ├─ CreateClub_Model.dart            # 클럽 생성 모델
│  ├─ CreateClub_Widget.dart           # 클럽 생성 UI
│  ├─ MyClub_Model.dart                # 내 클럽 모델
│  ├─ MyClub_Widget.dart               # 내 클럽 UI
│  ├─ UpdateClub_Model.dart            # 클럽 수정 모델
│  └─ UpdateClub_Widget.dart           # 클럽 수정 UI
├─ Community
│  ├─ CommunityPost_Model.dart         # 커뮤니티 게시글 요소 모델
│  ├─ CommunityPost_Widget.dart        # 커뮤니티 게시글 요소 UI
│  ├─ Community_Model.dart             # 커뮤니티 메인 모델
│  ├─ Community_Widget.dart            # 커뮤니티 메인 UI
│  ├─ PostElement.dart                 # 커뮤니티 게시글 데이터 클래스
│  ├─ Post_Model.dart                  # 커뮤니티 게시글 모델
│  ├─ Post_Widget.dart                 # 커뮤니티 게시글 UI
│  ├─ replyElement.dart                # 커뮤니티 게시글 댓글 요소 데이터 클래스
│  ├─ reply_Model.dart                 # 커뮤니티 게시글 댓글 모델
│  ├─ reply_Widget.dart                # 커뮤니티 게시글 댓글 UI
│  ├─ Write_Model.dart                 # 커뮤니티 게시글 작성 모델
│  └─ Write_Widget.dart                # 커뮤니티 게시글 작성 UI
├─ firebase_options.dart               # 파이어베이스 설정 클래스
├─ flutter_flow
│  ├─ flutter_flow_icon_button.dart
│  ├─ flutter_flow_theme.dart
│  ├─ flutter_flow_util.dart
│  └─ flutter_flow_widgets.dart
├─ handleNotificationClick.dart        # 푸시알림 클릭 이벤트 핸들러
├─ main
│  ├─ Components
│  │  ├─ clubElement_Model.dart        # 메인페이지 클럽 요소 모델
│  │  ├─ clubElement_Widget.dart       # 메인페이지 클럽 요소 UI
│  │  ├─ recruitmentElement.dart       # 메인페이지 모집 게시글 데이터 클래스
│  │  ├─ recruit_Model.dart            # 메인페이지 모집 모델
│  │  └─ recruit_Widget.dart           # 메인페이지 모집 UI
│  ├─ main_Model.dart                  # 메인페이지 모델
│  └─ main_Widget.dart                 # 메인페이지 UI
├─ main.dart                           # 앱관련 설정
├─ member
│  ├─ profile_Model.dart               # 내 프로필 모델
│  ├─ profile_Widget.dart              # 내 프로필 UI
│  ├─ updateProfile_Model.dart         # 내 프로필 수정 모델
│  └─ updateProfile_Widget.dart        # 내 프로필 수정 UI
├─ notice
│  ├─ notice.dart                      # 알림창 UI
│  └─ notice_model.dart                # 알림창 모델
├─ permissonManage.dart                # 권한 설정 클래스
├─ ranking
│  ├─ dapartmentRankList.dart          # 학과 대항전 랭킹
│  ├─ ranking.dart                     # 랭킹 페이지 UI
│  ├─ ranking_model.dart               # 랭킹 페이지 모델
│  ├─ rankList.dart                    # 랭킹 요소(학교/학과) UI
│  └─ topRank.dart                     # Top3 랭킹 요소 UI
├─ Search
│  ├─ SearchCategory_Model.dart        # 카테고리 검색 모델
│  ├─ SearchCategory_Widget.dart       # 카테고리 검색 UI
│  ├─ SearchResultClubList_Model.dart  # 클럽 검색 결과 모델
│  ├─ SearchResultClubList_Widget.dart # 클럽 검색 결과 UI
│  ├─ SearchResult_Model.dart          # 커뮤니티 검색 결과 모델
│  ├─ SearchResult_Widget.dart         # 커뮤니티 검색 결과 UI
│  ├─ Search_Model.dart                # 검색 모델
│  └─ Search_Widget.dart               # 검색 UI
├─ service_center
│  ├─ Announcement.dart                # 공지사항 UI 및 모델
│  ├─ Question.dart                    # 자주하는 질문 UI 및 모델
│  ├─ service_center.dart              # 고객센터 UI 및 모델
│  └─ Withdraw.dart                    # 회원탈퇴 UI 및 모델
├─ shared
│  ├─ CustomSnackbar.dart              # 커스텀 스낵바 클래스
│  ├─ DeptList.dart                    # 학과 리스트 드롭다운 UI 및 모델 클래스
│  ├─ EventList.dart                   # 스포츠 카테고리 리스트 드롭다운 UI 및 모델 클래스
│  ├─ GoogleMap.dart                   # GoogleMap UI 및 모델 클래스
│  ├─ IOSAlertDialog.dart              # IOS 스타일 알람창 커스텀 클래스
│  ├─ memberDetails.dart               # 회원 자세히보기(프로필 사진, 1대1채팅, 한줄 소개, 닉네임) UI 및 모델 클래스
│  ├─ payment.dart                     # 포트원 결제 클래스
│  ├─ paymentResult.dart               # 포트원 결제 결과 클래스
│  ├─ placepicker.dart                 # GoogleMap 장소 선택 클래스
│  ├─ Template.dart                    # 카테고리, 아이콘 관련 커스텀 클래스
│  └─ UnivList.dart                    # 대학 리스트 드롭다운 UI 및 모델 클래스
├─ test
│  ├─ testscreen_Model.dart            # 테스트 페이지
│  └─ testscreen_Widget.dart           # 테스트 페이지
└─ versus
   ├─ component
   │  ├─ teamMemberDropdown.dart       # 대항전 팀 목록 리스트 드롭다운 UI 및 모델
   │  ├─ versusElement_Model.dart      # 대항전 리스트에서 대항전 요소 모델
   │  ├─ versusElement_Widget.dart     # 대항전 리스트에서 대항전 요소 UI
   │  ├─ versusSearch_Model.dart       # 대항전 리스트 검색 모델
   │  └─ versusSearch_Widget.dart      # 대항전 리스트 검색 UI
   ├─ deptVersus     # 학과 대항전
   │  ├─ deptVersusCheck_Model.dart    # 학과 대항전 경기결과 승낙 모델
   │  ├─ deptVersusCheck_Widget.dart   # 학과 대항전 경기결과 승낙 UI
   │  ├─ deptVersusDetail_Model.dart   # 학과 대항전 조회 모델
   │  ├─ deptVersusDetail_Widget.dart  # 학과 대항전 조회 UI
   │  ├─ deptVersusProceeding_Model.dart # 학과 대항전 진행중 모델
   │  ├─ deptVersusProceeding_Widget.dart # 학과 대항전 진행중 UI
   │  ├─ deptVersusResult_Model.dart   # 학과 대항전 경기결과 전송 모델
   │  └─ deptVersusResult_Widget.dart  # 학과 대항전 경기결과 전송 UI
   ├─ versusCheck_Model.dart           # 대항전 경기결과 승낙 모델
   ├─ versusCheck_Widget.dart          # 대항전 경기결과 승낙 UI
   ├─ versusCreate_Model.dart          # 대항전 생성 모델
   ├─ versusCreate_Widget.dart         # 대항전 생성 UI
   ├─ versusDetail_Model.dart          # 대항전 조회 모델
   ├─ versusDetail_Widget.dart         # 대항전 조회 UI
   ├─ versusList_Model.dart            # 대항전 리스트 모델
   ├─ versusList_Widget.dart           # 대항전 리스트 UI
   ├─ versusProceeding_Model.dart      # 대항전 진행중 모델
   ├─ versusProceeding_Widget.dart     # 대항전 진행중 UI
   ├─ versusResult_Model.dart          # 대항전 경기결과 전송 모델
   ├─ versusResult_Widget.dart         # 대항전 경기결과 전송 UI
   └─ winloseRecord
      ├─ record.dart                   # 대항전 승패 기록 UI
      └─ record_model.dart             # 대항전 승패 기록 모델

```