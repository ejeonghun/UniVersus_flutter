import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/club/clubInfo.dart';
import 'package:universus/class/club/clubMember.dart';
import 'package:universus/class/club/clubPost.dart';
import 'package:universus/club/ClubPostList_Widget.dart';
import 'package:universus/club/ClubPostWrite_Widget.dart';
import 'package:universus/club/Components/clubPost_Widget.dart';
import 'package:universus/club/UpdateClub_Widget.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'package:universus/shared/IOSAlertDialog.dart';

import 'ClubMain_Model.dart';
export 'ClubMain_Model.dart';

class ClubMainWidget extends StatefulWidget {
  final int clubId;
  const ClubMainWidget({super.key, required this.clubId});

  @override
  State<ClubMainWidget> createState() => _ClubMainWidgetState();
}

class _ClubMainWidgetState extends State<ClubMainWidget> {
  var f = NumberFormat('###,###,###,###');
  late ClubMainModel _model;
  bool isMenuOpen = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubMainModel());
    _model.clubId = widget.clubId;
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
          _model.getClubInfo(_model.clubId),
          _model.getClubPosts(_model.clubId),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
            clubInfo clubInfoValue = snapshot.data![1];
            List<ClubPost> clubPosts = snapshot.data![2];
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                appBar: responsiveVisibility(
                  context: context,
                  tablet: false,
                )
                    ? AppBar(
                        backgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        automaticallyImplyLeading: false,
                        leading: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 60,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 30,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        title: Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Text(
                            clubInfoValue.clubName,
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 22,
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                        actions: [
                          FlutterFlowIconButton(
                            borderColor: Color(0x004B39EF),
                            borderRadius: 20,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: Color(0x004B39EF),
                            icon: Icon(
                              Icons.edit,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ClubPostWriteWidget(
                                        clubId: widget.clubId,
                                      )));
                            },
                          ),
                          FlutterFlowIconButton(
                            borderColor: Color(0x004B39EF),
                            borderRadius: 20,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: Color(0x004B39EF),
                            icon: FaIcon(
                              FontAwesomeIcons.facebookMessenger,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...12312');
                            },
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'memberManagement') {
                                if (clubInfoValue.clubLeader.toString() !=
                                    _model.memberIdx!) {
                                  return IOSAlertDialog.show(
                                    context: context,
                                    title: "실패",
                                    content: "모임장만 사용가능한 메뉴입니다.",
                                  );
                                }
                                List<ClubMember> clubMembers =
                                    await _model.getClubMembers(widget.clubId);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '멤버 관리',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: clubMembers.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              ClubMember member =
                                                  clubMembers[index];
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      member.profileImgUrl),
                                                ),
                                                title: Text(member.nickname),
                                                trailing: TextButton(
                                                  onPressed: () async {
                                                    // 추방 버튼 클릭 시 동작
                                                    if (await _model.expel(
                                                            widget.clubId,
                                                            member.memberIdx) ==
                                                        true) {
                                                      IOSAlertDialog.show(
                                                          context: context,
                                                          title: "성공",
                                                          content:
                                                              "해당 멤버를 추방하였습니다.");
                                                    }
                                                  },
                                                  child: Text('추방'),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (value == 'ClubUpdate') {
                                // 정보 수정 버튼 클릭 시 동작
                                if (clubInfoValue.clubLeader.toString() ==
                                    _model.memberIdx!) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateClubWidget(
                                        clubId: widget.clubId.toString()),
                                  ));
                                } else {
                                  IOSAlertDialog.show(
                                    context: context,
                                    title: "실패",
                                    content: "모임장만 가능합니다!",
                                  );
                                }
                              } else if (value == 'ClubDelete') {
                                IOSAlertDialog.confirm(
                                    context: context,
                                    title: "경고",
                                    content: "모임을 해체하시겠습니까?",
                                    onConfirm: () async {
                                      if (await _model
                                              .deleteClub(widget.clubId) ==
                                          true) {
                                        IOSAlertDialog.show(
                                          context: context,
                                          title: "완료",
                                          content: "모임이 해체되었습니다",
                                        );
                                      } else {
                                        IOSAlertDialog.show(
                                            context: context,
                                            title: "실패",
                                            content: "관리자만 가능합니다.");
                                      }
                                    });
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'memberManagement',
                                  child: Text('멤버 관리'),
                                ),
                                PopupMenuItem(
                                  value: 'ClubUpdate',
                                  child: Text('정보 수정'),
                                ),
                                PopupMenuItem(
                                  value: 'ClubDelete',
                                  child: Text('모임 삭제'),
                                ),
                              ];
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                        centerTitle: false,
                        elevation: 0,
                      )
                    : null,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            clubInfoValue.imageUrl ??
                                'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
                            width: 370,
                            height: 200,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent4,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: BoxConstraints(
                                        maxWidth: 800,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3,
                                            color: Color(0x33000000),
                                            offset: Offset(
                                              0,
                                              1,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.diversity_3,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24,
                                                      ),
                                                      Text(
                                                        '${clubInfoValue.currentMembers}/${clubInfoValue.maximumMembers}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              letterSpacing: 0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 5)),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.category_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24,
                                                      ),
                                                      Text(
                                                        '풋살',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              letterSpacing: 0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 5)),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .border_color_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24,
                                                      ),
                                                      Text(
                                                        '${clubPosts.length.toString()}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              letterSpacing: 0,
                                                              useGoogleFonts:
                                                                  false,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 5)),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 4)),
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '월 회비',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            letterSpacing: 0,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 1),
                                                      child: Text(
                                                        '₩${f.format(clubInfoValue.price)}원',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyLarge
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              letterSpacing: 0,
                                                            ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 4)),
                                                ),
                                                clubInfoValue.joinedStatus == 0
                                                    // 만약 가입되어 있다면 글작성 버튼, 아니면 가입하기 버튼
                                                    ? FFButtonWidget(
                                                        onPressed: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CupertinoAlertDialog(
                                                                title:
                                                                    Text("확인"),
                                                                content: Text(
                                                                    "모임에 가입하시겠습니까?"),
                                                                actions: [
                                                                  CupertinoDialogAction(
                                                                    child: Text(
                                                                        "취소"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context); // 다이얼로그 닫기
                                                                    },
                                                                  ),
                                                                  CupertinoDialogAction(
                                                                    child: Text(
                                                                        "확인"),
                                                                    onPressed:
                                                                        () async {
                                                                      if (await _model
                                                                              .joinClub(widget.clubId) ==
                                                                          true) {
                                                                        CustomSnackbar.success(
                                                                            context,
                                                                            "성공",
                                                                            '가입되었습니다',
                                                                            3);
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        CustomSnackbar.error(
                                                                            context,
                                                                            "실패",
                                                                            '이미 가입된 모임입니다',
                                                                            3);
                                                                      }
                                                                      Navigator.pop(
                                                                          context); // 다이얼로그 닫기
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        text: '가입하기\n',
                                                        options:
                                                            FFButtonOptions(
                                                          height: 40,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(24,
                                                                      0, 24, 0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0,
                                                                  ),
                                                          elevation: 3,
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          hoverColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .accent1,
                                                          hoverBorderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2,
                                                          ),
                                                          hoverTextColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                        ),
                                                      )
                                                    : FFButtonWidget(
                                                        onPressed: () {
                                                          debugPrint("클럽 글 작성");
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ClubPostWriteWidget(
                                                                            clubId:
                                                                                widget.clubId,
                                                                          )));
                                                        },
                                                        text: '글 작성',
                                                        options:
                                                            FFButtonOptions(
                                                          height: 40,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(24,
                                                                      0, 24, 0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Readex Pro',
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0,
                                                                  ),
                                                          elevation: 3,
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          hoverColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .accent1,
                                                          hoverBorderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2,
                                                          ),
                                                          hoverTextColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Text(
                                              clubInfoValue.clubIntro,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Text(
                                              '모임장',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 1),
                                              child: Container(
                                                width: double.infinity,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 4),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 44,
                                                        height: 44,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            child:
                                                                Image.network(
                                                              clubInfoValue
                                                                      .LeaderProfileImg ??
                                                                  'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
                                                              width: 40,
                                                              height: 40,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            clubInfoValue
                                                                    .LeaderNickname ??
                                                                '김철수',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 4)),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 12)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Text(
                                              '모임 생성일',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                            ),
                                            Text(
                                              '${clubInfoValue.getRegDate}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: BoxConstraints(
                                        maxWidth: 800.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3.0,
                                            color: Color(0x33000000),
                                            offset: Offset(
                                              0.0,
                                              1.0,
                                            ),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ClubPostListWidget(
                                                          clubId: widget.clubId,
                                                          clubName:
                                                              clubInfoValue
                                                                  .clubName,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    '더보기  ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Roboto',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts: true,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (clubPosts.isEmpty)
                                              Text(
                                                '작성된 게시글이 없습니다',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              )
                                            else
                                              ...clubPosts.map((post) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child: ClubPostWidget(
                                                      clubPost: post),
                                                );
                                              }).toList()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
