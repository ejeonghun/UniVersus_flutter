import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/Template.dart';
import 'Write_Widget.dart' show WriteWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WriteModel extends FlutterFlowModel<WriteWidget> {
  final unfocusNode = FocusNode();
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool? checkboxValue;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? sportDropdownValue;
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
    debugPrint(sportDropdownValue); // dropDownValue가 1이면 사용
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
  Future<bool> writePost() async {
    DioApiCall api = DioApiCall();
    FormData formData = FormData();

    if (dropDownValue == '모집') {
      formData = FormData.fromMap({
        'memberIdx': await UserData.getMemberIdx(),
        'categoryId': Template.getCategoryId(dropDownValue),
        'title': textController1?.text ?? '제목 없음',
        'content': textController2?.text ?? '내용 없음',
        'eventId': Template.getEventId(sportDropdownValue ?? '축구'),
        'matchDt': _datePicked,
        'lat': lat,
        'lng': lng,
        'place': placeName,
      });
    } else {
      formData = FormData.fromMap({
        'memberIdx': await UserData.getMemberIdx(),
        'categoryId': Template.getCategoryId(dropDownValue),
        'title': textController1?.text ?? '제목 없음',
        'content': textController2?.text ?? '내용 없음',
      });
    }

    // image파일이 있으면 이미지 파라미터 추가
    if (imageFile != null) {
      formData.files.add(MapEntry(
        'postImage',
        await MultipartFile.fromFile(imageFile!.path, filename: 'upload.jpg'),
      ));
    }

    debugPrint(Template.getCategoryId(dropDownValue).toString());
    final response = await api.multipartReq('/univBoard/create', formData);
    if (response['success'] == true) {
      debugPrint(response.toString());
      return true;
    } else {
      debugPrint(response.toString());
      return false;
    }
  }

  /*
 * 이미지 선택 조회
 * @return boolean: 이미지가 선택 여부
 * 생성자 : 이정훈
 * */
  Future<bool> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, //위치는 갤러리
      maxHeight: 500,
      maxWidth: 800,
      imageQuality: 90, // 이미지 크기 압축을 위해 퀄리티를 30으로 낮춤.
    );
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
