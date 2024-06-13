import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/api/DioApiCall.dart';
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
  String? _clubId; // 모임 id
  String? memberIdx;
  String? univId;

  void inputTest() {
    debugPrint(clubNameController?.text);
    debugPrint(clubPriceController?.text);
    debugPrint(clubIntroController?.text);
    debugPrint(dropDownValue);
    debugPrint(countControllerValue.toString());
    debugPrint(_clubId);
  }

  Future<bool> getClub(String clubId) async {
    ApiCall api = ApiCall();
    _clubId = clubId;
    memberIdx = await UserData.getMemberIdx();
    univId = await UserData.getUnivId();
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
      return true;
    } else {
      debugPrint(response.toString());
      debugPrint("동아리 정보 가져오기 실패");
      return false;
    }
  }

// 1개의 파일 업로드
  XFile? imageFile;

  /**
   * 이미지 선택
   * @return 성공 여부
   */
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image;

    if (kIsWeb) {
      // 웹일 경우
      image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 800,
        imageQuality: 90, // 이미지 크기 압축을 위해 퀄리티를 90으로 설정.
      );
    } else {
      // 모바일일 경우
      image = await _picker.pickImage(
        source: ImageSource.gallery, //위치는 갤러리
        maxHeight: 300,
        maxWidth: 800,
        imageQuality: 90, // 이미지 크기 압축을 위해 퀄리티를 90으로 설정.
      );
    }

    if (image != null) {
      imageFile = image;
    }
  }

  /**
   * 동아리 수정
   * @return 성공 여부
   * 생성자 : 이정훈
   */
  Future<bool> updateClub() async {
    var formData;
    if (imageFile != null) {
      // 이미지가 있을 때
      MultipartFile clubImage;
      if (kIsWeb) {
        debugPrint("웹 이미지 업로드");
        Uint8List imageBytes = await imageFile!.readAsBytes();
        clubImage = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFile!.name,
        );
        formData = FormData.fromMap({
          'clubImage': clubImage,
          'clubId': _clubId,
          'memberIdx': memberIdx,
          'clubName': clubNameController?.text,
          'price': clubPriceController?.text,
          'introduction': clubIntroController?.text,
          'eventId': eventId.toString(),
          'maximumMembers': countControllerValue.toString(),
          'univId': univId,
        });
      } else {
        debugPrint("모바일 이미지 업로드");
        formData = FormData.fromMap({
          'clubId': _clubId,
          'clubImage': await MultipartFile.fromFile(imageFile!.path),
          'memberIdx': memberIdx,
          'clubName': clubNameController?.text,
          'price': clubPriceController?.text,
          'introduction': clubIntroController?.text,
          'eventId': eventId.toString(),
          'maximumMembers': countControllerValue.toString(),
          'univId': univId,
        });
      }
    } else {
      // 이미지가 없을 때
      debugPrint("이미지 없음");
      formData = FormData.fromMap({
        'clubId': _clubId,
        'memberIdx': memberIdx,
        'clubName': clubNameController?.text,
        'price': clubPriceController?.text,
        'introduction': clubIntroController?.text,
        'eventId': eventId.toString(),
        'maximumMembers': countControllerValue.toString(),
        'univId': univId,
      });
    }

    // 업로드 요청
    var dio = DioApiCall();
    debugPrint(formData.toString());
    final response = await dio.multipartPatchReq('/club/modify', formData);
    if (response['success']) {
      debugPrint("동아리 수정 성공");
      return true;
    } else {
      debugPrint("동아리 수정 실패");
      return false;
    }
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
