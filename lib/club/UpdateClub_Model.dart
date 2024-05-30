import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'UpdateClub_Widget.dart' show UpdateClubWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateClubModel extends FlutterFlowModel<UpdateClubWidget> {
  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  FocusNode? clubNameFocusNode;
  TextEditingController? clubNameController;
  String? Function(BuildContext, String?)? clubNameControllerValidator;
  int? countControllerValue;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  FocusNode? clubPriceFocusNode;
  TextEditingController? clubPriceController;
  String? Function(BuildContext, String?)? clubPriceControllerValidator;
  FocusNode? clubIntroFocusNode;
  TextEditingController? clubIntroController;
  String? Function(BuildContext, String?)? clubIntroControllerValidator;

  int? eventId; // 카테고리 아이디
  String? uploadedImageUrl; // 이미지 URL
  String? clubId; // 모임 id

  void inputTest() {
    debugPrint(clubNameController?.text);
    debugPrint(clubPriceController?.text);
    debugPrint(clubIntroController?.text);
    debugPrint(dropDownValue);
    debugPrint(countControllerValue.toString());
  }

  Future<bool> getClub(String clubId) async {
    ApiCall api = ApiCall();
    final response = await api.get(
        '/club/info?clubId=${clubId}&memberIdx=${await UserData.getMemberIdx()}');
    if (response['success'] == true) {
      debugPrint(response.toString());
      debugPrint("동아리 정보 가져오기 성공");
      clubNameController?.text = response['data']['clubName'];
      clubPriceController?.text = response['data']['price'].toString();
      clubIntroController?.text = response['data']['introduction'];
      countControllerValue = response['data']['maximumMembers'];
      print(response['data']['maximumMembers']);
      eventId = response['data']['eventId'];
      print(response['data']['clubImage'][0]['imageUrl']);
      uploadedImageUrl = response['data']['clubImage'][0]['imageUrl'];
      this.clubId = clubId;
      return true;
    } else {
      debugPrint(response.toString());
      debugPrint("동아리 정보 가져오기 실패");
      return false;
    }
  }

// 1개의 파일 업로드
  XFile? imageFile;

  Future<bool> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, //위치는 갤러리
      maxHeight: 300,
      maxWidth: 800,
      imageQuality: 70, // 이미지 크기 압축을 위해 퀄리티를 30으로 낮춤.
    );
    if (image != null) {
      imageFile = image;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateClub() async {
    var formData;
    if (imageFile != null) {
      final filePath = imageFile!.path;

      // 파일 경로를 통해 formData 생성
      formData = FormData.fromMap({
        'clubId': clubId,
        'clubImage': await MultipartFile.fromFile(filePath),
        'memberIdx': await UserData.getMemberIdx(),
        'clubName': clubNameController?.text,
        'price': clubPriceController?.text,
        'introduction': clubIntroController?.text,
        'eventId': eventId.toString(),
        'maximumMembers': countControllerValue.toString(),
        'univId': await UserData.getUnivId(),
      });
    } else {
      // 이미지 파일이 없을 경우.
      formData = FormData.fromMap({
        'clubId': clubId,
        'memberIdx': await UserData.getMemberIdx(),
        'clubName': clubNameController?.text,
        'price': clubPriceController?.text,
        'introduction': clubIntroController?.text,
        'eventId': eventId.toString(),
        'maximumMembers': countControllerValue.toString(),
        'univId': await UserData.getUnivId(),
      });
    }
    // 업로드 요청
    var dio = Dio();
    final response = await dio.patch(
        'https://moyoapi.lunaweb.dev/api/v1/club/modify',
        data: formData);
    return response.statusCode == 200;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    clubNameFocusNode?.dispose();
    clubNameController?.dispose();

    clubPriceFocusNode?.dispose();
    clubPriceController?.dispose();

    clubIntroFocusNode?.dispose();
    clubIntroController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
