import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/club/ClubMain_Widget.dart';

import 'clublist_ex_Model.dart';
export 'clublist_ex_Model.dart';

class ClublistExWidget extends StatefulWidget {
  final List<ClubElement> clubs;

  ClublistExWidget({
    required this.clubs,
  });
  @override
  State<ClublistExWidget> createState() => _ClublistExWidgetState();
}

class _ClublistExWidgetState extends State<ClublistExWidget> {
  late ClublistExModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClublistExModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: widget.clubs.length,
      itemBuilder: (context, index) {
        final club = widget.clubs[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
          child: GestureDetector(
            onTap: () {
              // 클럽 상세 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubMainWidget(clubId: club.clubId),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1.01, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      club.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.2, -0.96),
                        child: Text(
                          club.clubName,
                          style: GoogleFonts.getFont(
                            'Readex Pro',
                            fontSize: 17,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.13, 0.02),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                          child: Text(
                            club.introduction ?? 'no',
                            style: GoogleFonts.getFont(
                              'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 13,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // 텍스트 위젯의 상단 정렬
                        children: [
                          Text(
                            '${club.eventName}',
                            style: GoogleFonts.getFont(
                              'Readex Pro',
                              letterSpacing: 0,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(width: 10), // 가로 간격 조절을 위한 SizedBox
                          Text(
                            '👨‍🦳${club.currentMembers}',
                            style: GoogleFonts.getFont(
                              'Readex Pro',
                              letterSpacing: 0,
                              fontStyle: FontStyle.italic,
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
        );
      },
    );
  }
}
