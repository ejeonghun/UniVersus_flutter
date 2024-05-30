import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/club/Components/clublist_ex_Widget.dart';

import 'ClubList_Model.dart';
export 'ClubList_Model.dart';

class ClubListWidget extends StatefulWidget {
  const ClubListWidget({super.key});

  @override
  State<ClubListWidget> createState() => _ClubListWidgetState();
}

class _ClubListWidgetState extends State<ClubListWidget> {
  late ClubListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubListModel());
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
            Navigator.of(context).pop(); // 이전 화면으로 이동
          },
        ),
        title: Text(
          '지금 뜨는 인기 모임',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder(
        future: _model.getClubList(),
        builder: (BuildContext context, AsyncSnapshot<List<ClubElement>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            // ClublistExWidget을 사용하여 클럽 목록을 화면에 표시합니다.
            return ClublistExWidget(clubs: snapshot.data!);
          }
        },
      ),
    ),
  );
}
}