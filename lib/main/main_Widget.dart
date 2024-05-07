import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universus/Community/Community_Widget.dart';
import 'package:universus/class/user/userProfile.dart';
import 'package:universus/club/ClubList_Widget.dart';
import 'package:universus/club/Components/recommendclub_Widget.dart';
import 'package:universus/main/Components/recruit_Widget.dart';
import 'package:universus/main/main_Model.dart';
import 'package:universus/main/main_Widget.dart';
export 'main_Model.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late MainModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _model.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<userProfile> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(), // 로딩 바 추가
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            String schoolName = snapshot.data!.univName; // 학교 이름 가져오기
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
                        print('IconButton pressed ...');
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
                        print('IconButton pressed ...');
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
                                            controller: _model
                                                    .pageViewController ??=
                                                PageController(initialPage: 0),
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                      text: '팀',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 15, 239, 60),
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
                            Align(
                              alignment: AlignmentDirectional(0, -1),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      wrapWithModel(
                                        model: _model.recommendclubModel,
                                        updateCallback: () => setState(() {}),
                                        child: RecommendclubWidget(),
                                      ),
                                    ].divide(SizedBox(width: 20)),
                                  ),
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      wrapWithModel(
                                        model: _model.recruitModel,
                                        updateCallback: () => setState(() {}),
                                        child:
                                            RecruitWidget(), // recruit_Widget 컴포넌트 사용
                                      ),
                                    ],
                                  ),
                                ),
                                // 필요에 따라 추가적인 recruit_Widget를 여기에 반복해서 추가하세요.
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
