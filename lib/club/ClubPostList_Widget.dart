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
import 'package:universus/club/ClubPostWrite_Widget.dart';
import 'ClubPostList_Model.dart';
export 'ClubPostList_Model.dart';

class ClubPostListWidget extends StatefulWidget {
  final int clubId;
  final String clubName;
  const ClubPostListWidget(
      {super.key, required this.clubId, required this.clubName});

  @override
  State<ClubPostListWidget> createState() => _ClubPostListWidgetState();
}

class _ClubPostListWidgetState extends State<ClubPostListWidget>
    with TickerProviderStateMixin {
  late CommunityModel _model;
  Future<List<PostElement>>? _futurePostList;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityModel());

    _futurePostList = _model.getPostList(widget.clubId); // '전체' 카테고리의 게시물 로드
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          _model.getMemberIdx(),
          _model.getProfile(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            userProfile? profile = snapshot.data?[1];
            if (profile != null) {
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
                      widget.clubName + ' 게시판',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
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
                          Navigator.of(context).pushNamed('/Search');
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
                              builder: (context) =>
                                  ClubPostWriteWidget(clubId: widget.clubId),
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
                        Expanded(
                          child: FutureBuilder<List<PostElement>>(
                            future: _futurePostList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(child: Text('게시물이 없습니다.'));
                              }

                              List<PostElement> postList = snapshot.data!;
                              postList.sort((a, b) => DateTime.parse(b.regDt)
                                  .compareTo(DateTime.parse(a.regDt)));
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
            } else {
              return Center();
            }
          }
        });
  }
}
