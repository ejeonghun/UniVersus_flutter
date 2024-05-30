import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/class/user/userProfile.dart';
import 'updateProfile_Widget.dart' show updateProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileEditModel extends FlutterFlowModel<updateProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  FocusNode? nicknameFocusNode;
  TextEditingController? nicknameController;
  String? Function(BuildContext, String?)? nicknameControllerValidator;
  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  String? Function(BuildContext, String?)? phoneControllerValidator;
  // State field(s) for dept widget.
  String? deptValue;
  FormFieldController<String>? deptValueController;
  // State field(s) for oneLineIntro widget.
  FocusNode? oneLineIntroFocusNode;
  TextEditingController? oneLineIntroController;
  String? Function(BuildContext, String?)? oneLineIntroControllerValidator;

  Future<userProfile> getProfile(String memberIdx) async {
    // 사용자 정보를 불러오는 메소드
    DioApiCall api = DioApiCall();
    final response = await api.get('/member/profile?memberIdx=${memberIdx}');
    if (response['memberIdx'].toString() == memberIdx) {
      // 조회 성공
      print(response);
      return userProfile(
        userName: response['userName'],
        nickname: response['nickname'],
        memberIdx: response['memberIdx'].toString(),
        univName: response['schoolName'].toString(),
        deptName: response['deptName'].toString(),
        profileImage: response['imageUrl'],
        phone: response['phone'] ?? '전화번호를 입력해주세요',
        oneLineIntro: response['oneLineIntro'] != null &&
                response['oneLineIntro'].isNotEmpty
            ? response['oneLineIntro']
            : '한 줄 소개를 입력해주세요.',
        univLogoImage: '',
      );
    } else {
      // 조회 실패
      print(response);
      return userProfile.nullPut();
    }
  }

  XFile? imageFile; // 이미지 파일 저장 변수

  Future<bool> pickImage() async {
    // 이미지 선택 메소드
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, //위치는 갤러리
      maxHeight: 300,
      maxWidth: 800,
      imageQuality: 70, // 이미지 크기 압축을 위해 퀄리티를 30으로 낮춤.
    );
    if (image != null) {
      imageFile = image;
      return updateProfileImage();
    } else {
      return false;
    }
  }

  Future<bool> updateProfileImage() async {
    if (imageFile != null) {
      final filePath = imageFile!.path;

      DioApiCall api = DioApiCall();
      final response = await api.ImageReq('/member/updateImage', {
        'memberIdx': await UserData.getMemberIdx(),
        'profileImage': await MultipartFile.fromFile(filePath),
      });

      if (response['success'] == true) {
        debugPrint("프로필 이미지 수정 성공");
        return true;
      } else {
        debugPrint("프로필 이미지 수정 실패");
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(String memberIdx) async {
    DioApiCall api = DioApiCall();
    final response = await api.post('/member/updateProfile', {
      'memberIdx': memberIdx,
      'nickname': nicknameController?.text,
      'phone': phoneController?.text,
      // 'deptId': deptValue, 학과는 변경 불가
      'oneLineIntro': oneLineIntroController?.text,
    });
    if (response['success'] == true) {
      debugPrint("프로필 수정 성공");
      return true;
    } else {
      debugPrint("프로필 수정 실패");
      return false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nicknameFocusNode?.dispose();
    nicknameController?.dispose();

    phoneFocusNode?.dispose();
    phoneController?.dispose();

    oneLineIntroFocusNode?.dispose();
    oneLineIntroController?.dispose();
  }
}
