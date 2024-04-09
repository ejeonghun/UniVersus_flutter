import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'versusDetail_Widget.dart' show VersusDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VersusDetailModel extends FlutterFlowModel<VersusDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  Future<Map<String, dynamic>> getVersusDetail() async {
    // 대결 리스트를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api.get('/univBattle/list?status=${0}');
    if (response.isNotEmpty) {
      // response가 null이 아니면
      // 조회 성공
      print(response);
      return response;
    } else {
      // 조회 실패
      print(response);
      return {};
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
