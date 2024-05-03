import 'package:universus/class/versus/versusElement.dart';
import 'package:universus/versus/component/versusElement_Widget.dart';
import 'package:universus/versus/component/versusSearch_Widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'versusList_Model.dart';
export 'versusList_Model.dart';

class VersusListWidget extends StatefulWidget {
  const VersusListWidget({super.key});

  @override
  State<VersusListWidget> createState() => _VersusListWidgetState();
}

class _VersusListWidgetState extends State<VersusListWidget> {
  int statusCode = 0; // status 전역 상태값
  late VersusListModel _model;
  bool _showVersusSearchWidget = false; // 검색창 보이기 여부

  //상태값 변경 함수
  setStatusCode(int Code) {
    setState(() {
      statusCode = Code;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersusListModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/versusCreate');
          },
          backgroundColor: Color(0xFFFFBE98),
          elevation: 6.0,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).primaryBackground,
            size: 24.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            '대항전',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Color(0x004B39EF),
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: Color(0x00FFFFFF),
              icon: Icon(
                Icons.search_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () {
                setState(() {
                  _showVersusSearchWidget = !_showVersusSearchWidget;
                });
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: Colors.transparent,
              icon: Icon(
                Icons.add,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
            FlutterFlowIconButton(
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              icon: FaIcon(
                FontAwesomeIcons.trophy,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: FutureBuilder(
            future: _model.getVersusList(statusCode),
            builder: (BuildContext context,
                AsyncSnapshot<List<versusElement>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(), // 로딩 바 추가
                      SizedBox(height: 20), // 로딩 바와 텍스트 사이에 간격 추가
                      Text('데이터를 불러오는 중...'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('오류: ${snapshot.error}');
              } else {
                return SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Lottie.asset(
                          'assets/lottie/vs.json',
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 190.0,
                          fit: BoxFit.fill,
                          animate: true,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_showVersusSearchWidget)
                                wrapWithModel(
                                  model: _model.versusSearchModel,
                                  updateCallback: () => setState(() {}),
                                  child: VersusSearchWidget(
                                    setStatusCode: setStatusCode,
                                    selectedIndex:
                                        statusCode, // 해당 값을 전해줌으로써 ChoiceChip에 선택이 되어 있게함
                                  ),
                                ),
                              if (responsiveVisibility(
                                context: context,
                                phone: false,
                                tablet: false,
                              ))
                                Container(
                                  width: double.infinity,
                                  height: 24.0,
                                  decoration: BoxDecoration(),
                                ),
                              Center(
                                  child: snapshot.data != null &&
                                          snapshot.data!.isNotEmpty
                                      ? ListView(
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            44.0,
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          children: snapshot.data!
                                              .map((versusElement element) {
                                                return wrapWithModel(
                                                  model: _model
                                                      .versusElementModel1,
                                                  updateCallback: () =>
                                                      setState(() {}),
                                                  child: VersusElementWidget(
                                                    element: element,
                                                  ),
                                                );
                                              })
                                              .toList()
                                              .expand((widget) => [
                                                    widget,
                                                    SizedBox(height: 1.0)
                                                  ])
                                              .toList(),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 30, 0, 0),
                                          child: Text("대항전이 존재하지 않습니다!"),
                                        )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
