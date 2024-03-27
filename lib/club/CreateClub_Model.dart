import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'CreateClub_Widget.dart' show CreateClubWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateClubModel extends FlutterFlowModel<CreateClubWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for clubName widget.
  FocusNode? clubNameFocusNode;
  TextEditingController? clubNameController;
  String? Function(BuildContext, String?)? clubNameControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for clubPrice widget.
  FocusNode? clubPriceFocusNode;
  TextEditingController? clubPriceController;
  String? Function(BuildContext, String?)? clubPriceControllerValidator;
  // State field(s) for clubIntro widget.
  FocusNode? clubIntroFocusNode;
  TextEditingController? clubIntroController;
  String? Function(BuildContext, String?)? clubIntroControllerValidator;

  int? eventId;

  void inputTest() {
    debugPrint(clubNameController?.text);
    debugPrint(clubPriceController?.text);
    debugPrint(clubIntroController?.text);
    debugPrint(dropDownValue);
    debugPrint(countControllerValue.toString());
  }

  Future<bool> createClub() async {
    ApiCall api = ApiCall();
    final response = await api.multipartReq(
        '/club/create',
        {
          'memberIdx': '103',
          'clubName': clubNameController?.text,
          'price': clubPriceController?.text,
          'introduction': clubIntroController?.text,
          'eventId': eventId.toString(),
          'maximumMembers': countControllerValue.toString(),
        },
        imageFile: imageFile);
    if (response['success'] == true) {
      debugPrint(response.toString());
      debugPrint("동아리 생성 성공");
      return true;
    }
    debugPrint(response.toString());
    debugPrint("동아리 생성 실패");
    return false;
  }

  // Future<bool> uploadImage() async {
  //   Dio dio = Dio();
  //   String path = imageFile; // 이미지 파일 경로
  //   String url = 'https://moyoapi.lunaweb.dev/api/v1/club/create'; // 서버 URL

  //   FormData formData = FormData.fromMap({
  //     "clubImage":
  //         await MultipartFile.fromFile(path, filename: "upload.jpg"), // 파일 업로드
  //     'memberIdx': '103',
  //     'clubName': clubNameController?.text,
  //     'price': clubPriceController?.text,
  //     'introduction': clubIntroController?.text,
  //     'eventId': eventId.toString(),
  //     'maximumMembers': countControllerValue.toString(),
  //   });

  //   var response = await dio.post(url, data: formData);
  //   if (response.statusCode == 200) {
  //     print('Image uploaded successfully');
  //     return true;
  //   } else {
  //     print('Image upload failed');
  //     return false;
  //   }
  // }

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

  Future<bool> uploadFile() async {
    // file picker를 통해 파일 선택
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (imageFile != null) {
      final filePath = imageFile!.path;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'clubImage': await MultipartFile.fromFile(filePath),
        'memberIdx': await UserData.getMemberIdx(),
        'clubName': clubNameController?.text,
        'price': clubPriceController?.text,
        'introduction': clubIntroController?.text,
        'eventId': eventId.toString(),
        'maximumMembers': countControllerValue.toString(),
      });

      // 업로드 요청
      final response = await dio.post(
          'https://moyoapi.lunaweb.dev/api/v1/club/create',
          data: formData);
      return response.statusCode == 200;
    } else {
      // 아무런 파일도 선택되지 않음.
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
