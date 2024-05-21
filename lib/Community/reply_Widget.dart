import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'replyElement.dart';

class ReplyWidget extends StatelessWidget {
  final Reply reply;

  const ReplyWidget({
    Key? key,
    required this.reply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 25,
                height: 25,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  reply.profileImageUrl, // 댓글 작성자 프로필 이미지
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: Text(
                  reply.nickname, // 댓글 작성자 이름
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 15,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
              child: Text(
                reply.content, // 댓글 내용
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 15,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
              child: Text(
                reply.getFormattedDate(), // 댓글 작성 시간
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: Color(0xFF979797),
                  fontSize: 10,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 0,
            color: FlutterFlowTheme.of(context).tertiary,
          ),
        ],
      ),
    );
  }
}
