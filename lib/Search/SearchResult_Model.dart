import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/main/Components/clubElement_Model.dart';
import 'SearchResult_Widget.dart' show SearchResultWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchResultModel extends FlutterFlowModel<SearchResultWidget> {
  ///  State fields for stateful widgets in this page.
  late ClubElementModel clubElementModel;

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  
  Future<List<ClubElement>> getClubList() async {
    final token = await FirebaseMessaging.instance.getToken();
    try {
      DioApiCall api = DioApiCall();
      final response = await api.get(
          '/club/suggest?memberIdx=${await UserData.getMemberIdx()}&fcmToken=${token}');

      // 가져온 데이터가 null이거나 List가 아닌 경우 처리
      if (!response.isNotEmpty) {
        print('Failed to fetch club list');
        return [];
      }

      // 클럽 목록 생성
      List<ClubElement> clubList = [];
      for (var clubData in response['data']) {
        clubList.add(ClubElement(
          clubId: clubData['clubId'],
          eventName: clubData['eventName'],
          clubName: clubData['clubName'],
          currentMembers: clubData['currentMembers'],
          imageUrl: clubData['imageUrl'] == ""
              ? 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png'
              : clubData['imageUrl'],
        ));
      }

      // 클럽 목록 반환
      debugPrint(clubList.toString());
      return clubList;
    } catch (e) {
      // 오류 처리
      print('Error fetching club list: $e');
      return [];
    }
  }
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    tabBarController?.dispose();
  }
}
