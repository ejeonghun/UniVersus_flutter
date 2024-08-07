import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/versus/versusElement.dart';
import 'package:universus/versus/deptVersus/deptVersusDetail_Widget.dart';
import 'package:universus/versus/versusDetail_Widget.dart';

import 'versusElement_Model.dart';
export 'versusElement_Model.dart';

class VersusElementWidget extends StatefulWidget {
  final versusElement element;
  const VersusElementWidget({super.key, required this.element});

  @override
  State<VersusElementWidget> createState() => _VersusElementWidgetState();
}

class _VersusElementWidgetState extends State<VersusElementWidget> {
  late VersusElementModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersusElementModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          // 해당 대항전으로 이동하는 코드 추가
          // 만약 대학 대항전이라면 대학 대항전 상세 페이지로 이동
          if (widget.element.univBattleId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VersusDetailWidget(
                  battleId: widget.element.univBattleId!,
                ),
              ),
            );
          } else {
            debugPrint("학과 임");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => deptVersusDetailWidget(
                  battleId: widget.element.deptBattleId!,
                ),
              ),
            );
          }
        },
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
                              _model.getIcon(widget.element.eventId!),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    3.0, 0.0, 15.0, 0.0),
                                child: Text(
                                  "${_model.getEventText(widget.element.eventId!)}",
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                        fontSize: 20.0,
                      ),
                ),),]
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(50, 0, 0, 0),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Color.fromARGB(0, 0, 0, 0),
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    widget.element.getHostTeamUnivLogo
                                        .toString(),
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 10.0, 10.0, 0.0),
                                child: AutoSizeText(
                                  widget.element.hostTeamName.toString(),
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  minFontSize: 1.0,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              widget.element.hostTeamDept ??= '', // null이면 빈 칸
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF6F61EF),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset(
                    'assets/lottie/sword.json',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.fill,
                    animate: true,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(50, 0, 0, 0),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    widget.element.guestTeamUnivLogo ??=
                                        'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 10.0, 10.0, 0.0),
                                child: AutoSizeText(
                                  widget.element.guestTeamName ??= '모집 중...',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  minFontSize: 13.0,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              widget.element.guestTeamDept ??= '', // null이면 빈 칸
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF6F61EF),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _model.getColor(widget.element.status!),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                    child: Text(
                      _model.getText(widget.element.status!),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Color(0xCCA5A5A5),
            ),
          ],
        ),
      ),
    );
  }
}
