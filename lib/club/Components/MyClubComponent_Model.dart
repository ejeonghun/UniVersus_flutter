import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/user/user.dart';
import 'myclubcomponent_Widget.dart' show MyClubComponentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubElement.dart';

Future<String?> getMemberIdx() async {
  return UserData.getMemberIdx();
}

Future<List<ClubElement>> getJoinedClubsList() async {
  try {
    DioApiCall api = DioApiCall();
    final response = await api
        .get('/club/joinedClubsList?memberIdx=${await getMemberIdx()}');
    List<ClubElement> joinedClubsList = [];
    for (var item in response['data']) {
      joinedClubsList.add(ClubElement(
        clubId: item['clubId'] ?? 0,
        eventName: item['eventId'].toString(), // Adjusted as per your model
        clubName: item['clubName'],
        introduction: item['introduction'],
        currentMembers: item['currentMembers'],
        joinedDt: item['joinedDt'],
        imageUrl: item['clubImageUrl'] == ''
            ? 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png'
            : item['clubImageUrl'],
      ));
    }
    return joinedClubsList;
  } catch (e) {
    print('Error fetching joined clubs list: $e');
    return [];
  }
}

class MyClubComponentModel extends FlutterFlowModel<MyClubComponentWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
