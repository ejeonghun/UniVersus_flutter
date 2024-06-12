import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/Community/Post_Widget.dart';
import 'package:universus/class/club/clubPost.dart';
import 'package:universus/class/club/clubPost.dart';

import 'clubPost_Model.dart';
export 'clubPost_Model.dart';

/* 
* 클럽 내 게시글 위젯
*/
class ClubPostWidget extends StatefulWidget {
  final ClubPost clubPost;
  const ClubPostWidget({super.key, required this.clubPost});

  @override
  State<ClubPostWidget> createState() => _ClubPostWidgetState();
}

class _ClubPostWidgetState extends State<ClubPostWidget> {
  late ClubPostModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubPostModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.clubPost.univBoardId != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostWidget(
                            univBoardId: widget.clubPost.univBoardId,
                          )),
                );
              }
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Image.network(
                          widget.clubPost.memberProfileImg!,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '${widget.clubPost.nickname}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(55.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '${widget.clubPost.getRegDt}',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Text(
                              '${widget.clubPost.title}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                    useGoogleFonts: false,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${widget.clubPost.content}',
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        // AlignmentDirectional(0.0, 0.0),

                        child: (widget.clubPost.imageUrl != null &&
                                widget.clubPost.imageUrl != 'none')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  widget.clubPost.imageUrl!,
                                  width: 100.0,
                                  height: 70.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(''),
                      ),
                    ].divide(SizedBox(width: 50.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
