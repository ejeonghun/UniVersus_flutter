import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'package:universus/shared/GoogleMap.dart';
import 'package:universus/versus/component/teamMemberDropdown.dart';
import 'package:universus/versus/deptVersus/deptVersusProceeding_Widget.dart';
import 'package:universus/versus/versusProceeding_Widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/Template.dart';
import 'deptVersusDetail_Model.dart';
export 'deptVersusDetail_Model.dart';

class deptVersusDetailWidget extends StatefulWidget {
  final int battleId;
  const deptVersusDetailWidget({super.key, required this.battleId});

  @override
  State<deptVersusDetailWidget> createState() => _deptVersusDetailWidgetState();
}

class _deptVersusDetailWidgetState extends State<deptVersusDetailWidget> {
  late VersusDetailModel _model;
  late String? memberIdx;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersusDetailModel());
    getMemberIdx();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> getMemberIdx() async {
    memberIdx = await UserData.getMemberIdx();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _model.getVersusDetail(widget.battleId),
        builder: (BuildContext context, AsyncSnapshot<versusDetail> snapshot) {
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
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                appBar: AppBar(
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  iconTheme: IconThemeData(
                      color: FlutterFlowTheme.of(context).primaryText),
                  automaticallyImplyLeading: true,
                  title: Text(
                    '[학과]대항전 상세',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  actions: [
                    // 대항전 일반 참가
                    FlutterFlowIconButton(
                      borderColor: Color(0x004B39EF),
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      fillColor: Color(0x00FFFFFF),
                      icon: Icon(
                        Icons.login,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () {
                        _model.showInputDialog(context, widget.battleId);
                      },
                    ),
                  ],
                  centerTitle: false,
                  elevation: 2.0,
                ),
                body: SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _model.getIcon(snapshot.data!.eventId!),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    3.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  "${_model.getEventText(snapshot.data!.eventId!)}",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 32.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          indent: 30.0,
                          endIndent: 30.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        if (snapshot.data!.winUnivName != 'null')
                          Text(
                            "승리팀 : ${snapshot.data!.winUnivName}",
                            style: TextStyle(fontSize: 22),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 5.0),
                                    child: Text(
                                      '제 1팀',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      width: 120.0,
                                      height: 120.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        snapshot.data!.hostTeamUnivLogo ??
                                            'https://picsum.photos/seed/260/600',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 0.0),
                                    child: Container(
                                      width: 100.0, // Column의 너비를 고정
                                      child: AutoSizeText(
                                        snapshot.data!.hostTeamName ?? ' 오류 ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: false,
                                            ),
                                        maxLines: 2,
                                        minFontSize: 10,
                                        textAlign:
                                            TextAlign.center, // 텍스트를 중앙 정렬
                                      ),
                                    ),
                                  ),
                                  TeamMemberDropdown(
                                    teamMembers:
                                        snapshot.data!.hostTeamMembers!,
                                    hostLeader: snapshot.data!.hostLeaderId!,
                                    guestLeader: snapshot.data!.guestLeaderId,
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Frame_26.png',
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 5.0),
                                    child: Text(
                                      '제 2팀',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      width: 120.0,
                                      height: 120.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        snapshot.data!.hostTeamUnivLogo ??=
                                            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 0.0),
                                    child: Container(
                                      width: 100.0, // Column의 너비를 고정
                                      child: AutoSizeText(
                                        snapshot.data!.guestTeamName ?? ' 오류 ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: false,
                                            ),
                                        maxLines: 2,
                                        minFontSize: 10,
                                        textAlign:
                                            TextAlign.center, // 텍스트를 중앙 정렬
                                      ),
                                    ),
                                  ),
                                  TeamMemberDropdown(
                                      teamMembers:
                                          snapshot.data!.guestTeamMembers!,
                                      hostLeader: snapshot.data!.hostLeaderId!,
                                      guestLeader:
                                          snapshot.data!.guestLeaderId),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: _model.getColor(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _model.getText(),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 5.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 5.0, 5.0, 5.0),
                              child: Text(
                                '${snapshot.data!.content} \n참가비 : ${snapshot.data!.cost}원',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '생성일 : ${snapshot.data!.getRegDate}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                if (snapshot.data!.endDate != '')
                                  Text(
                                    '종료일 : ${snapshot.data!.getEndDate}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // "모집중" 일 때만 대결 신청 버튼 활성화
                        // "모집중"이 아닐 때는 초대코드 표시
                        if (snapshot.data!.status == 'RECRUIT')
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (await _model.repAttend(widget.battleId) ==
                                    true) {
                                  CustomSnackbar.success(
                                      context, "성공", "참가가 완료되었습니다.", 2);
                                } else {
                                  CustomSnackbar.error(
                                      context, "실패", "같은 학과는 참가할 수 없습니다.", 2);
                                }
                                setState(() {});
                              },
                              text: '대결 신청',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.85,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Color(0xC6ABA4A4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      '초대코드 : ${snapshot.data!.invitationCode ??= "모집 중"}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        /* 
                          현재 "준비완료" 상태이고 host리더만이 경기를 시작할 수 있다.
                          */
                        if (snapshot.data!.status == "PREPARED" &&
                            snapshot.data!.hostLeaderId ==
                                int.parse(memberIdx!))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (await _model.matchStart(widget.battleId) ==
                                    true) {
                                  CustomSnackbar.success(
                                      context, "성공", "경기가 시작되었습니다.", 2);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              deptVersusProceedingWidget(
                                                battleId: widget.battleId,
                                              )));
                                } else {
                                  CustomSnackbar.error(
                                      context,
                                      "실패",
                                      "경기를 시작 할 수 없습니다. \n 경기시작에 필요한 인원이 부족합니다.",
                                      2);
                                }
                                setState(() {});
                              },
                              text: '경기 시작',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        /* 
                          이 상태는 경기가 시작하였지만 host리더가 경기 진행창을 벗어났을경우를 대처해
                          다시 들어갈 수 있도록 만들어놈
                          */
                        if (snapshot.data!.status == 'IN_PROGRESS' &&
                            snapshot.data!.hostLeaderId ==
                                int.parse(memberIdx!))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            deptVersusProceedingWidget(
                                              battleId: widget.battleId,
                                            )));
                              },
                              text: '경기로 돌아가기',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 5.0),
                          child: snapshot.data!.getPlace != '없음'
                              ? Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.85,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xC6ABA4A4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          '주소 : ${snapshot.data!.place}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 0.0)),
                                  ),
                                )
                              : SizedBox(), // Render an empty SizedBox if any of the values are null
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: snapshot.data!.place != '없음'
                              ? GoogleMapWidget(
                                  lat: snapshot.data!.getLat!,
                                  lng: snapshot.data!.getLng!,
                                )
                              : SizedBox(), // Render an empty SizedBox if any of the values are null
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
