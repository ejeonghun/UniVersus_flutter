import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universus/Community/CommunityPost_Widget.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/Search/SearchResultClubList_Widget.dart';
import 'package:universus/class/club/clubElement.dart';
import 'SearchResult_Model.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchQuery;
  const SearchResultWidget({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget>
    with TickerProviderStateMixin {
  late SearchResultModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchResultModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
            child: TextFormField(
              controller: _model.textController,
              focusNode: _model.textFieldFocusNode,
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                hintText: widget.searchQuery,
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      color: Color(0xFF979797),
                      letterSpacing: 0,
                    ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primaryText,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).tertiary,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                contentPadding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
              minLines: null,
            ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: 20,
                  borderWidth: 1,
                  buttonSize: 50,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.search_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 28,
                  ),
                  onPressed: () async {
                    final clubs = await _model
                        .getSearchClub(_model.textController?.text ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultWidget(
                          searchQuery: _model.textController?.text ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                        unselectedLabelStyle: TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).tertiary,
                        padding: EdgeInsets.all(4),
                        tabs: [
                          Tab(
                            text: '모임',
                          ),
                          Tab(
                            text: '게시물',
                          ),
                        ],
                        controller: _model.tabBarController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          FutureBuilder<List<ClubElement>>(
                            future: _model.getSearchClub(widget.searchQuery),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(child: Text('검색결과가 없습니다.'));
                              } else {
                                return SearchResultClubListWidget(
                                    clubs: snapshot.data!);
                              }
                            },
                          ),
                          FutureBuilder<List<PostElement>>(
                            future: _model.getSearchPost(widget.searchQuery),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(child: Text('검색결과가 없습니다.'));
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return CommunityPostWidget(
                                        post: snapshot.data![index]);
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
