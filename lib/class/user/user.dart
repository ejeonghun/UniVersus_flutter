import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData {
  // 사용자 정보를 저장하는 클래스
  String id; // id 값
  String token; // JWT토큰값
  String platform; // 플랫폼 -> 'kakao' , 'email'
  String memberIdx; // 회원번호
  String univId; // 대학 Id값

  UserData(
      {required this.id,
      required this.token,
      required this.platform,
      required this.memberIdx,
      required this.univId});

  // 사용자 정보를 Secure Storage에 저장하는 메소드
  Future<bool> saveUser() async {
    final storage = FlutterSecureStorage();

    await storage.write(key: 'user_id', value: this.id);
    await storage.write(key: 'token', value: this.token);
    await storage.write(key: 'memberIdx', value: this.memberIdx);
    await storage.write(key: 'platform', value: this.platform);
    await storage.write(key: 'univId', value: this.univId);

    print("유저 정보 저장 완료");
    return true;
  }

  // 사용자 정보를 Secure Storage에서 불러와서 값이 있으면 반환해주는 메소드
  static Future<UserData?> getUser() async {
    String? s_id;
    String? s_token;
    String? s_memberIdx;
    String? s_platform;
    String? s_univId;

    final storage = FlutterSecureStorage();

    s_id = await storage.read(key: 'user_id');
    s_token = await storage.read(key: 'token');
    s_memberIdx = await storage.read(key: 'memberIdx');
    s_platform = await storage.read(key: 'platform');
    s_univId = await storage.read(key: 'univId');

    // 값이 모두 존재하면 User 객체로 반환한다.
    if (s_id != null &&
        s_token != null &&
        s_memberIdx != null &&
        s_platform != null &&
        s_univId != null) {
      return UserData(
          id: s_id,
          token: s_token,
          memberIdx: s_memberIdx,
          platform: s_platform,
          univId: s_univId);
    } else {
      return null;
    }
  }

  static Future<String?> getMemberIdx() async {
    final storage = FlutterSecureStorage();
    if (await storage.read(key: 'memberIdx') == null) {
      return null;
    }
    return storage.read(key: 'memberIdx');
  }

  static Future<String?> getUnivId() async {
    final storage = FlutterSecureStorage();
    if (await storage.read(key: 'univId') == null) {
      return null;
    }
    return storage.read(key: 'univId');
  }
}
