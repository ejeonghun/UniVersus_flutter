import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/club/Components/clublist_ex_Model.dart';
import 'ClubList_Widget.dart' show ClubListWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubListModel extends FlutterFlowModel<ClubListWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for clublist_ex component.
  late ClublistExModel clublistExModel;

  @override
  void initState(BuildContext context) {
    clublistExModel = createModel(context, () => ClublistExModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    clublistExModel.dispose();
  }

  Future<List<ClubElement>> getClubList() async {
    try {
      DioApiCall api = DioApiCall();
      final response = await api
          .get('/club/list?memberIdx=${await UserData.getMemberIdx()}');
      List<ClubElement> clubList = [];
      for (var item in response['data']) {
        clubList.add(ClubElement(
          clubId: item['clubId'],
          eventName: item['eventName'], // Adjusted as per your model
          clubName: item['clubName'],
          introduction: item['introduction'],
          currentMembers: item['currentMembers'],
          imageUrl: item['clubImageUrl'] != ''
              ? item['clubImageUrl']
              : 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        ));
      }

      return clubList;
    } catch (e) {
      print('Error fetching club list: $e');
      return [];
    }
  }
}
