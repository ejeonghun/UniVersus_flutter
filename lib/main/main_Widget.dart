import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universus/BottomBar2.dart';
import 'package:universus/Community/Community_Widget.dart';
import 'package:universus/class/user/userProfile.dart';
import 'package:universus/club/ClubList_Widget.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/main/Components/clubElement_Widget.dart';
import 'package:universus/main/Components/recruit_Widget.dart';
import 'package:universus/main/Components/recruitmentElement.dart';
import 'package:universus/permissonManage.dart';
import 'main_Model.dart';
import 'package:universus/main/main_Widget.dart';
import 'dart:async';
export 'main_Model.dart';

PermissionManage permissionManage = PermissionManage();

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late MainModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_pageController.hasClients && _pageController.page != null) {
          if (_pageController.page!.round() == 2) {
            _pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        }
      });
    });
  }


  @override
  void dispose() {
    _model.dispose();
    super.dispose();
    _pageController.dispose();
    _timer.cancel(); // 타이머 취소
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          permissionManage.requestPermissions(context),
          _model.getClubList(),
          _model.getProfile(),
          _model.getrecuitmentElement()
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 현재 테마가 다크 모드인지 여부를 확인합니다.
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Container(
          color: isDarkMode ? Colors.black : Colors.white, // 다크 모드와 라이트 모드에 따라 배경색 설정
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(), // 로딩 바 추가
              ],
            ),
          ),
        );
          } else if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            bool isPermissionGranted = snapshot.data![0]; // 권한 허용 여부
            List<ClubElement> clubList = snapshot.data![1];
            userProfile userInfo = snapshot.data![2];
            List<RecruitmentElement> recruitList = snapshot.data![3];
            String schoolName = " ${userInfo.getUnivName}"; // 학교 이름 가져오기
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                appBar: AppBar(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  automaticallyImplyLeading: false,
                  title: Text(
                    schoolName,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Noto Serif',
                          color: FlutterFlowTheme.of(context).error,
                          fontSize: 25,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  actions: [
                    FlutterFlowIconButton(
                      borderColor: Color(0x004B39EF),
                      borderRadius: 20,
                      borderWidth: 0,
                      buttonSize: 40,
                      fillColor: Color(0x004B39EF),
                      icon: Icon(
                        Icons.search_sharp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Search');
                      },
                    ),
                    FlutterFlowIconButton(
                      borderColor: Color(0x004B39EF),
                      borderRadius: 20,
                      buttonSize: 40,
                      fillColor: Color(0x00C1BBF8),
                      icon: FaIcon(
                        FontAwesomeIcons.solidBell,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/notice');
                      },
                    ),
                  ],
                  centerTitle: false,
                  elevation: 0,
                ),
                body: SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0, -1),
                                  child: Container(
                                    width: 350,
                                    height: 350,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 40),
                                          child: PageView(
                                            controller: 
                                                _pageController,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/versusList');
                                                },
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          'assets/images/Main1.png',
                                                          width: 382,
                                                          height: 362,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommunityWidget(
                                                        initialTabIndex:
                                                            2, // 초기 탭 인덱스를 2로 설정하여 모집 탭 선택
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          'assets/images/Main2.png',
                                                          width: 382,
                                                          height: 362,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/Community');
                                                },
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          'assets/images/Main3.png',
                                                          width: 382,
                                                          height: 362,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 1),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 0, 0, 0),
                                            child: smooth_page_indicator
                                                .SmoothPageIndicator(
                                              controller:
                                                  _model.pageViewController ??=
                                                      PageController(
                                                          initialPage: 0),
                                              count: 3,
                                              axisDirection: Axis.horizontal,
                                              onDotClicked: (i) async {
                                                await _model.pageViewController!
                                                    .animateToPage(
                                                  i,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              effect: smooth_page_indicator
                                                  .SlideEffect(
                                                spacing: 0,
                                                radius: 0,
                                                dotWidth: 0,
                                                dotHeight: 0,
                                                dotColor:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                activeDotColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                paintStyle: PaintingStyle.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.83, 0.06),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '이런 ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 20,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '클럽',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 90, 112, 253),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '은 어떤가요?',
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.9, -1),
                              child: GestureDetector(
                                onTap: () {
                                  // 클릭 시 "clublist_widget"으로 이동하는 코드
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClubListWidget()),
                                  );
                                },
                                child: Text(
                                  '더보기',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ),
                            ),
                            // Generated code for this Row Widget...
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: clubList.map((club) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right: 15), // 오른쪽 여백 추가
                                      child: wrapWithModel(
                                        model: _model.clubElementModel,
                                        updateCallback: () => setState(() {}),
                                        child: ClubElementWidget(
                                            clubElement: club),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.84, 0.67),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '번개 ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .warning,
                                              fontSize: 20,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '모집',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 20,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.9, -1),
                                child: GestureDetector(
                                  onTap: () {
                                    // 클릭 시 "community_Widget"으로 이동하는 코드
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommunityWidget(
                                              initialTabIndex:
                                                  2)), // 초기 탭 인덱스를 2로 설정하여 모집 탭 선택
                                    );
                                  },
                                  child: Text(
                                    '더보기',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: SingleChildScrollView(
                                  child: recruitList.isEmpty
                                      ? Text("해당 학교에 게시글이 존재하지 않음")
                                      : Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: recruitList.map((recruit) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15), // 오른쪽 여백 추가
                                              child: wrapWithModel(
                                                model: _model.recruitModel,
                                                updateCallback: () =>
                                                    setState(() {}),
                                                child: RecruitWidget(
                                                  recruitmentElement: recruit,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomBar2(selectedIndex: 0,),
              ),
            );
          }
        });
  }
}
