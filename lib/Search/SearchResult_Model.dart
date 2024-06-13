import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/club/clubElement.dart';
import 'package:universus/main/Components/clubElement_Model.dart';
import 'SearchResult_Widget.dart' show SearchResultWidget;
import 'package:flutter/material.dart';

class SearchResultModel extends FlutterFlowModel {
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

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    tabBarController?.dispose();
  }

  Future<List<ClubElement>> getSearchClub(String? query) async {
    try {
      DioApiCall api = DioApiCall();
      final response = await api
          .getDynamic('/search/0?query=${Uri.encodeQueryComponent(query!)}');

      print(response.toString());
      if (response.isEmpty) {
        print('Failed to fetch club list');
        return [];
      }

      // 클럽 목록 생성
      List<ClubElement> clubList = [];
      for (var item in response) {
        var clubData = item['club'];
        clubList.add(ClubElement(
          clubId: clubData['clubId'],
          eventName:
              clubData['eventId'].toString(), // Adjusted as per your model
          clubName: clubData['clubName'],
          introduction: clubData['introduction'],
          currentMembers: clubData['currentMembers'],
          imageUrl: item['imageUrl'] ??
              'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
        ));
      }

      return clubList;
    } catch (e) {
      print('Error fetching club list: $e');
      return [];
    }
  }

  @override
  void initState(BuildContext context) {}

  Future<List<PostElement>> getSearchPost(String? query) async {
    debugPrint(query);
    try {
      DioApiCall api = DioApiCall();
      final response = await api
          .getDynamic('/search/1?query=${Uri.encodeQueryComponent(query!)}');

      if (!response.isNotEmpty) {
        print('Failed to fetch post list');
        return [];
      }

      List<PostElement> postList = [];
      for (var postData in response) {
        postList.add(PostElement(
          univBoardId: postData['univBoardId'],
          title: postData['title'],
          content: postData['content'],
          regDt: postData['regDt'],
          nickname: postData['nickname'] ?? 'sa',
          categoryName: postData['categoryName'].toString(),
          postImageUrls: [],
        ));
      }

      return postList;
    } catch (e) {
      print('Error fetching post list: $e');
      return [];
    }
  }
}
