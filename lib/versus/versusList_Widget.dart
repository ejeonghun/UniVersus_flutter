import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/versus/versusElement.dart';
import 'package:universus/versus/component/versusElement_Widget.dart';
import 'package:universus/versus/component/versusSearch_Widget.dart';
import 'versusList_Model.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VersusListWidget extends StatefulWidget {
  const VersusListWidget({super.key});

  @override
  State<VersusListWidget> createState() => _VersusListWidgetState();
}

class _VersusListWidgetState extends State<VersusListWidget>
    with SingleTickerProviderStateMixin {
  int statusCode = 0; // status 전역 상태값
  late VersusListModel _model;
  bool _showVersusSearchWidget = false; // 검색창 보이기 여부
  late TabController _tabController;
  List<versusElement> versusList = [];
  List<versusElement> filteredList = [];
  bool _isLoading = true; // Loading state
  String searchQuery = '';

  // 상태값 변경 함수
  void setStatusCode(int code) {
    setState(() {
      statusCode = code;
      _loadVersusList();
    });
  }

  // 검색값 변경 함수
  void setSearchValue(String value) {
    setState(() {
      searchQuery = value;
      _filterList();
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersusListModel());
    _tabController = TabController(length: 2, vsync: this);

    _loadVersusList();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadVersusList();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVersusList() async {
    setState(() {
      _isLoading = true;
    });

    if (_tabController.index == 0) {
      versusList = await _model.getVersusList(statusCode);
    } else {
      versusList = await _model.getVersusListDept(statusCode);
    }

    _filterList(); // Apply search filter

    setState(() {
      _isLoading = false;
    });
  }

  void _filterList() {
    if (searchQuery.isEmpty) {
      filteredList = versusList;
    } else {
      filteredList = versusList
          .where((element) =>
              element.hostTeamName!.contains(searchQuery) ||
              element.guestTeamName!.contains(searchQuery) ||
              element.content!.contains(searchQuery))
          .toList();
    }
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
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              icon: FaIcon(
                FontAwesomeIcons.trophy,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/ranking');
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: '학교'),
              Tab(text: '학과'),
            ],
            indicatorColor: FlutterFlowTheme.of(context).primaryText,
            labelColor: FlutterFlowTheme.of(context).primaryText,
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVersusList(context),
            _buildVersusList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVersusList(BuildContext context) {
    return _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(), // 로딩 바 추가
                SizedBox(height: 20), // 로딩 바와 텍스트 사이에 간격 추가
                Text('데이터를 불러오는 중...'),
              ],
            ),
          )
        : SafeArea(
            top: true,
            child: ListView(
              children: [
                Lottie.asset(
                  'assets/lottie/vs.json',
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 190.0,
                  fit: BoxFit.fill,
                  animate: true,
                ),
                if (_showVersusSearchWidget)
                  wrapWithModel(
                    model: _model.versusSearchModel,
                    updateCallback: () => setState(() {}),
                    child: VersusSearchWidget(
                      onSearch:
                          setSearchValue, // Pass the setSearchValue callback
                      setStatusCode:
                          setStatusCode, // Pass the setStatusCode callback
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
                if (filteredList.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 1.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return wrapWithModel(
                        model: _model.versusElementModel1,
                        updateCallback: () => setState(() {}),
                        child: VersusElementWidget(
                          element: filteredList[index],
                        ),
                      );
                    },
                  )
                else
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text("대항전이 존재하지 않습니다!"),
                  ),
              ],
            ),
          );
  }
}
