import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

/// 프로필 수정 페이지 모델 클래스
/// 생성자 : 이정훈
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

  /**
   * 사용자 정보 불러오기
   * @param memberIdx : 사용자 고유번호
   * @return 사용자 정보
   * 생성자 : 이정훈
   */
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
      return updateProfileImage();
    } else {
      return false;
    }
  }

  /**
   * 프로필 이미지 수정
   * @return 성공 여부
   * 생성자 : 이정훈
   */
  Future<bool> updateProfileImage() async {
    if (imageFile != null) {
      MultipartFile profileImage;

      if (kIsWeb) {
        Uint8List imageBytes = await imageFile!.readAsBytes();
        profileImage = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFile!.name,
        );
      } else {
        profileImage = await MultipartFile.fromFile(imageFile!.path);
      }

      DioApiCall api = DioApiCall();
      final response = await api.ImageReq('/member/updateImage', {
        'memberIdx': await UserData.getMemberIdx(),
        'profileImage': profileImage,
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

  /**
   * 프로필 수정
   * @param memberIdx : 사용자 고유번호
   * @return 성공 여부
   * 생성자 : 이정훈
   */
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
