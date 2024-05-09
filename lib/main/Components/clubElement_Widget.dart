import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/versus/versusDetail.dart';
import 'package:universus/club/ClubMain_Widget.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/shared/Template.dart';
import 'clubElement_Model.dart';
export 'clubElement_Model.dart';

class ClubElementWidget extends StatefulWidget {
  final ClubElement clubElement;
  const ClubElementWidget({super.key, required this.clubElement});

  @override
  State<ClubElementWidget> createState() => _ClubElementWidgetState();
}

class _ClubElementWidgetState extends State<ClubElementWidget> {
  late ClubElementModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubElementModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            // 추후 수정 필요
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClubMainWidget(clubId: widget.clubElement.clubId),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.clubElement.imageUrl,
                  width: 130.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0), // 여기에 원하는 간격을 설정하세요
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.83, 0.44),
                  child: Template.getIcon(widget.clubElement.eventName,
                      size: 20.0),
                ),
                SizedBox(width: 3.0), // 아이콘과 텍스트 사이 간격
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.44),
                  child: Text(
                    Template.getEventText(widget
                        .clubElement.eventName), // eventName에 따라 종목 텍스트를 가져옵니다.
                    style: TextStyle(
                      color: Template.getEventTextColor(
                          widget.clubElement.eventName), // 종목 텍스트의 색상을 설정합니다.
                      fontFamily: 'Readex Pro',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0), // 여기에 원하는 간격을 설정하세요
            Align(
              alignment: AlignmentDirectional(-0.1, 0.49),
              child: Text(
                widget.clubElement.clubName,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-0.83, 0.54),
                    child: Icon(
                      Icons.person,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 15.0,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.74, 0.54),
                    child: Text(
                      '${widget.clubElement.currentMembers.toString() + '명'}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
