import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:universus/BottomBar2.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/Community/replyElement.dart';
import 'package:universus/Community/reply_Widget.dart';
import 'package:universus/shared/GoogleMap.dart';
import 'package:universus/shared/Template.dart';
import 'package:universus/shared/memberDetails.dart';

import 'Post_Model.dart';
export 'Post_Model.dart';

class PostWidget extends StatefulWidget {
  final int univBoardId;

  const PostWidget({
    super.key,
    required this.univBoardId,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostModel _model;
  bool _isModifying = false;
  late TextEditingController _contentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostModel());
    debugPrint(widget.univBoardId.toString());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.getMemberIdx();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleModifyingMode(PostElement post) {
    setState(() {
      _isModifying = !_isModifying;
      if (_isModifying) {
        _contentController.text =
            post.content ?? ''; // null 대신 빈 문자열을 사용하여 초기화합니다.
      } else {
        _contentController.clear();
      }
    });
  }

  Future<void> _saveChanges(PostElement post) async {
    // 데이터 전송 전에 _contentController.text가 비어있지 않은지 확인합니다.
    if (_contentController.text.isNotEmpty) {
      // 내용이 있다면 업데이트를 진행합니다.
      setState(() {
        post.content = _contentController.text;
        _isModifying = false;
      });
      // 여기서 서버에 데이터를 전송하는 로직을 추가합니다.
    } else {
      // 내용이 비어있다면 사용자에게 알립니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('내용을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _model.getPost(widget.univBoardId),
        _model.getReply(widget.univBoardId),
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
          PostElement post = snapshot.data![0];
          List<Reply> replies = snapshot.data![1];
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              appBar: AppBar(
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
                    post.title,
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20,
                          letterSpacing: 0,
                        ),
                  ),
                ),
                actions: [],
                centerTitle: true,
                elevation: 0,
              ),
              body: SafeArea(
                top: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (post.nickname != '익명') {
                                      await MemberDetails(post.PostMemberIdx)
                                          .showMemberDetailsModal(context);
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.network(
                                      post.getProfileImgUrl,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          post.nickname,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 20,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        post.getFormattedDate(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color: Color(0xFF979797),
                                              letterSpacing: 0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(), // Spacer 추가
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'modify') {
                                      _toggleModifyingMode(post);
                                    } else if (value == 'delete') {
                                      _model
                                          .deletePost(
                                              widget.univBoardId, context)
                                          .then((_) {
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
                          child: _isModifying
                              ? TextFormField(
                                  controller: _contentController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: '내용을 입력하세요...',
                                    border: OutlineInputBorder(),
                                  ),
                                )
                              : AutoSizeText(
                                  post.content,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                        ),
                      ),
                      if (_isModifying)
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(60, 10, 0, 0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _model.modifyPost(
                                      post,
                                      context,
                                    );
                                    _saveChanges(post);
                                  },
                                  child: Text('저장'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => _toggleModifyingMode(post),
                                  child: Text('취소'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                        child: post.postImageUrls.isEmpty
                            ? SizedBox()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: post.postImageUrls.length == 1
                                    ? Image.network(
                                        post.postImageUrls[0],
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.9,
                                        fit: BoxFit.fill,
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                        ),
                                        itemCount: post.postImageUrls.length,
                                        itemBuilder: (context, index) {
                                          return Image.network(
                                            post.postImageUrls[index],
                                            fit: BoxFit.fill,
                                          );
                                        },
                                      ),
                              ),
                      ),
                      if (post.categoryName == '모집' &&
                          post.place != '없음') // 모집글이면서 주소 정보가 있는 경우에만 컨테이너 표시
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: post!.place != '없음'
                              ? GoogleMapWidget(
                                  lat: post!.getLat!,
                                  lng: post!.getLng!,
                                )
                              : SizedBox(), // Render an empty SizedBox if any of the values are null
                        ),
                      if (post.categoryName == '모집') // 모집글인 경우에만 해당 위젯을 표시합니다.
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 0.0),
                          child: Text(
                            '주소 : ${post!.place}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var reply in replies)
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: ReplyWidget(reply: reply),
                              ),
                          ],
                        ),
                      ),
                      Builder(builder: (context) {
                        return Align(
                          alignment: AlignmentDirectional(0, -1),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Theme(
                                data: ThemeData(
                                  checkboxTheme: CheckboxThemeData(
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  unselectedWidgetColor: Color(0xCCA5A5A5),
                                ),
                                child: Checkbox(
                                  value: _model.anonymousCheck ??= false,
                                  onChanged: (newValue) async {
                                    setState(() =>
                                        _model.anonymousCheck = newValue!);
                                  },
                                  activeColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                  checkColor: FlutterFlowTheme.of(context).info,
                                ),
                              ),
                              Text(
                                '익명',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Color(0xCCA5A5A5),
                                      fontSize: 15,
                                      letterSpacing: 0,
                                    ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: TextFormField(
                                    controller: _model.textController,
                                    focusNode: _model.textFieldFocusNode,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                          ),
                                      hintText: '댓글 입력',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 15,
                                            letterSpacing: 0,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              8, 0, 0, 0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                    minLines: null,
                                    validator: _model.textControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  // 댓글을 업로드하는 함수 호출
                                  await _model.postComment(widget.univBoardId,
                                      _model.textController.text);
                                  // 댓글을 업로드한 후 UI를 업데이트합니다.
                                  setState(() {});
                                  _model.textController?.clear();
                                },
                                text: '입력',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      2, 0, 2, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0x00EE8B60),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        letterSpacing: 0,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomBar2(selectedIndex: 2,),
            ),
          );
        }
      },
    );
  }
}
