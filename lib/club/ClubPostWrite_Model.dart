import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/Template.dart';
import 'ClubPostWrite_Widget.dart' show ClubPostWriteWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubPostWriteModel extends FlutterFlowModel<ClubPostWriteWidget> {
  final unfocusNode = FocusNode();
  String? dropDownValue;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  DateTime? _datePicked;
  double? lat; // 위도
  double? lng; // 경도
  String? placeName; // 장소명
  DateTime? get datePicked => _datePicked;
  XFile? imageFile; // 이미지 파일

  set datePicked(DateTime? value) {
    _datePicked = value;
    // Custom listener mechanism
    notifyDatePickedListeners();
  }

  void test() {
    debugPrint(textController1.text);
    debugPrint(textController2.text);
    debugPrint(dropDownValue); // null 이면 '자유' == 0
    debugPrint(_datePicked.toString()); // dropDownValue가 1이면 사용
    debugPrint(lat.toString()); // drop DownValue가 1이면 사용
    debugPrint(lng.toString()); // dropDownValue가 1이면 사용
    debugPrint(placeName.toString()); // dropDownValue가 1이면 사용
  }

  /*
  * 게시글 작성
  * @param memberIdx, categoryId, title, content, eventId, matchDt, lat, lng, place:
  * @return boolean: 성공 여부
  * @throws Exception: 게시글 생성 실패 시 예외 발생
  * 생성자 : 이정훈
  * */
  Future<bool> writePost(int clubId) async {
    DioApiCall api = DioApiCall();
    FormData formData = FormData();

    formData = FormData.fromMap({
      'memberIdx': await UserData.getMemberIdx(),
      'clubId': clubId,
      'categoryId': 1,
      'title': textController1?.text ?? '제목 없음',
      'content': textController2?.text ?? '내용 없음',
      'anonymous': 0
    });

    // image파일이 있으면 이미지 파라미터 추가
    if (imageFile != null) {
      if (!kIsWeb) {
        // 모바일 기기라면
        formData.files.add(MapEntry(
          'postImage',
          await MultipartFile.fromFile(imageFile!.path, filename: 'upload.jpg'),
        ));
      } else {
        // 웹 이라면
        Uint8List imageBytes = await imageFile!.readAsBytes();
        formData.files.add(MapEntry(
          'postImage',
          MultipartFile.fromBytes(
            imageBytes,
            filename: imageFile!.name,
          ),
        ));
      }
    }
    final response = await api.multipartReq('/univBoard/create', formData);
    if (response['success'] == true) {
      debugPrint(response.toString());
      return true;
    } else {
      debugPrint(response.toString());
      return false;
    }
  }

  /**
   * 이미지 선택
   * @return 성공 여부
   */
  Future<bool> pickImage() async {
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
      return true;
    } else {
      return false;
    }
  }

  // List of listeners for datePicked changes
  final List<VoidCallback> _datePickedListeners = [];

  // Method to add a listener for datePicked changes
  void addDatePickedListener(VoidCallback listener) {
    _datePickedListeners.add(listener);
  }

  // Method to remove a listener for datePicked changes
  void removeDatePickedListener(VoidCallback listener) {
    _datePickedListeners.remove(listener);
  }

  // Method to notify all listeners when datePicked changes
  void notifyDatePickedListeners() {
    for (final listener in _datePickedListeners) {
      listener();
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
