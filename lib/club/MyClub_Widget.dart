import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/club/Components/MyClubComponent_Widget.dart';
import 'package:universus/club/Components/MyClubComponent_Model.dart';

import 'MyClub_Model.dart';
export 'MyClub_Model.dart';

class MyClubWidget extends StatefulWidget {
  const MyClubWidget({super.key});

  @override
  State<MyClubWidget> createState() => _MyClubWidgetState();
}

class _MyClubWidgetState extends State<MyClubWidget> {
  late MyClubModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int memberIdx = 1; // Replace with the actual member index

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyClubModel());
    _model.fetchJoinedClubs(memberIdx); // Fetch joined clubs on initialization
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
        appBar: responsiveVisibility(
          context: context,
          tablet: false,
        )
            ? AppBar(
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '내 클럽',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                letterSpacing: 0,
                              ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 30,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushNamed('/createClub');
                      },
                    ),
                  ),
                ],
                centerTitle: false,
                elevation: 0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: FutureBuilder(
            future: _model.fetchJoinedClubs(memberIdx),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      wrapWithModel(
                        model: _model.myClubComponentModel,
                        updateCallback: () => setState(() {}),
                        child: MyClubComponentWidget(
                          clubs: _model.joinedClubs,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
