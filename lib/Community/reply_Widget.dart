import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/reply_Model.dart';
import 'package:universus/shared/IOSAlertDialog.dart';
import 'package:universus/shared/memberDetails.dart';
import 'replyElement.dart';
import 'package:provider/provider.dart';

class ReplyWidget extends StatefulWidget {
  final Reply reply;

  const ReplyWidget({Key? key, required this.reply}) : super(key: key);

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  late ReplyModel _model;
  bool _isModifying = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReplyModel());
    _model.textController.text = widget.reply.content;
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
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  debugPrint(widget.reply.memberIdx.toString());
                  if (widget.reply.nickname != "익명") {
                    // 익명이 아니라면 프로필 조회 가능
                    await MemberDetails(widget.reply.memberIdx)
                        .showMemberDetailsModal(context);
                  } else {
                    // 익명은 프로필 조회 불가능
                    IOSAlertDialog.show(
                        context: context,
                        title: "프로필 조회 실패",
                        content: "익명 사용자입니다.");
                  }
                },
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    widget.reply.profileImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                child: Text(
                  widget.reply.nickname,
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
                  if (value == 'modify') {
                    setState(() {
                      _isModifying = true;
                      _model.textController.text = widget.reply.content;
                    });
                  } else if (value == 'delete') {
                    _model.deleteReply(widget.reply.replyId, context).then((_) {
                      setState(() {});
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'modify',
                      child: Text('수정'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('삭제'),
                    ),
                  ];
                },
                icon: Icon(
                  Icons.more_vert,
                  color: FlutterFlowTheme.of(context).primaryText,

                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
              child: _isModifying
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            decoration: InputDecoration(
                              hintText: '댓글을 입력하세요...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send_sharp),
                          onPressed: () async {
                            await _model
                                .modifyReply(widget.reply.replyId,
                                    _model.textController.text, context)
                                .then((_) {
                              setState(() {
                                _model.textController?.clear();
                              });
                              _isModifying = false;
                            });
                          },
                        ),
                      ],
                    )
                  : Text(
                      widget.reply.content,
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
                widget.reply.getFormattedDate(),
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
