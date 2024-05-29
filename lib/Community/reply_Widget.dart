import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/reply_Model.dart';
import 'replyElement.dart';
import 'package:provider/provider.dart';

class ReplyWidget extends StatefulWidget {
  final Reply reply;

  const ReplyWidget({super.key, required this.reply});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  late ReplyModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReplyModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

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
                  widget.reply.profileImageUrl, // 댓글 작성자 프로필 이미지
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: Text(
                  widget.reply.nickname, // 댓글 작성자 이름
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 15,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    // 수정 버튼 클릭 시 동작
                  } else if (value == 'delete') {
                    // 삭제 버튼 클릭 시 동작
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                        value: 'edit',
                        child: Text('수정'),
                        onTap: () async {
                          // 수정 버튼 클릭 시 동작
                        }),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('삭제'),
                        onTap: () async {
                          await _model.deleteReply(
                              widget.reply.replyId, context);
                          setState(() {});
                        }),
                  ];
                },
                icon: Icon(
                  Icons.more_vert,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
              child: Text(
                widget.reply.content, // 댓글 내용
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
                widget.reply.getFormattedDate(), // 댓글 작성 시간
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
