import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/club/Components/MyClubComponent_Model.dart';
import 'package:flutter/material.dart';
import 'package:universus/class/club/clubElement.dart';

class MyClubModel extends FlutterFlowModel {
  final unfocusNode = FocusNode();
  late MyClubComponentModel myClubComponentModel;
  List<ClubElement> joinedClubs = [];

  MyClubModel() {
    myClubComponentModel = MyClubComponentModel();
  }

  Future<void> fetchJoinedClubs() async {
    await getMemberIdx();
    joinedClubs = await getJoinedClubsList();
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    myClubComponentModel.dispose();
  }
}
