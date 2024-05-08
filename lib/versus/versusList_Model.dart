import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/versus/versusElement.dart';
import 'package:universus/versus/component/versusElement_Widget.dart';
import 'package:universus/versus/component/versusSearch_Widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'versusList_Widget.dart' show VersusListWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class VersusListModel extends FlutterFlowModel<VersusListWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for versusSearch component.
  late VersusSearchModel versusSearchModel;
  // Model for versusElement component.
  late VersusElementModel versusElementModel1;
  // Model for versusElement component.
  late VersusElementModel versusElementModel2;

  Future<List<versusElement>> getVersusList(int statusCode) async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api.get('/univBattle/list?status=${statusCode}');
    if (response.isNotEmpty) {
      // response가 null이 아니면
      // 조회 성공
      print(response);
      List<versusElement> versusList = [];
      for (var item in response['data']) {
        versusList.add(versusElement(
          univBattleId: item['univBattleId'],
          hostTeamName: item['hostUnivName'].toString(),
          // hostTeamDept: item[''],
          hostTeamUnivLogo: item['hostUnivLogo'],
          guestTeamName: item['guestUnivName'],
          // guestTeamDept: item['place'],
          content: item['content'],
          guestTeamUnivLogo: item['guestUnivLogo'],
          status: item['matchStatus'],
        ));
      }
      return versusList;
    } else {
      // 조회 실패
      print(response);
      return [];
    }
  }

  @override
  void initState(BuildContext context) {
    versusSearchModel = createModel(context, () => VersusSearchModel());
    versusElementModel1 = createModel(context, () => VersusElementModel());
    versusElementModel2 = createModel(context, () => VersusElementModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    versusSearchModel.dispose();
    versusElementModel1.dispose();
    versusElementModel2.dispose();
  }
}
