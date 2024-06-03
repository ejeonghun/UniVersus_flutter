import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'myclubcomponent_Widget.dart' show MyClubComponentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubElement.dart';

Future<List<ClubElement>> getJoinedClubsList(int memberIdx) async {
  try {
    DioApiCall api = DioApiCall();
    final response = await api.get('/club/joinedClubsList?memberIdx=$memberIdx');
    List<ClubElement> joinedClubsList = [];
    for (var item in response['data']) {
      joinedClubsList.add(ClubElement(
        clubId: item['clubId'] ?? 0,
        eventName: item['eventId'].toString(), // Adjusted as per your model
        clubName: item['clubName'],
        introduction: item['introduction'],
        currentMembers: item['currentMembers'],
        joinedDt: item['joinedDt'],
        imageUrl: item['imageUrl'] ?? 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
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
