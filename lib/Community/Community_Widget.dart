import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/Community/CommunityPost_Widget.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/Write_Widget.dart';
import 'package:universus/class/user/userProfile.dart';
import 'Community_Model.dart';
export 'Community_Model.dart';

class CommunityWidget extends StatefulWidget {
  final int initialTabIndex; // 초기 탭 인덱스를 받을 필드 추가

  const CommunityWidget(
      {super.key, this.initialTabIndex = 0}); // 초기 탭 인덱스의 기본값은 0

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget>
    with TickerProviderStateMixin {
  late CommunityModel _model;
  Future<List<PostElement>>? _futurePostList;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: widget.initialTabIndex, // 인자로 받은 초기 탭 인덱스 설정
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_model.getMemberIdx(), _model.getProfile()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            userProfile profile = snapshot.data[1];
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
                    profile.getUnivName,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Noto Serif',
                          color: Color(0xFFEF0F1C),
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
                        FontAwesomeIcons.pencilAlt,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WriteWidget(),
                          ),
                        );
                      },
                    ),
                  ],
                  centerTitle: false,
                  elevation: 0,
                ),
                body: SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment(0, 0),
                        child: TabBar(
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                          unselectedLabelStyle: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                letterSpacing: 0,
                              ),
                          indicatorColor: FlutterFlowTheme.of(context).error,
                          tabs: [
                            Tab(text: '전체'),
                            Tab(text: '자유'),
                            Tab(text: '모집'),
                            Tab(text: '정보'),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) {
                            setState(() {
                              _futurePostList =
                                  _model.getPostList(i); // categoryId를 i로 설정
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<PostElement>>(
                          future: _model
                              .getPostList(_model.tabBarController!.index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text('No posts available.'));
                            }

                            List<PostElement> postList = snapshot.data!;
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: postList.map((post) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: CommunityPostWidget(post: post),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ); // 끝
          }
        });
  }
}
