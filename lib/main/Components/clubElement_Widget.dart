import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/club/ClubMain_Widget.dart';
import 'package:universus/class/club/clubElement.dart';
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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.83, 0.44),
                  child: Icon(
                    Icons.sports_soccer,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.44),
                  child: Text(
                    '축구',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF00F627),
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(-0.79, 0.49),
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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
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
