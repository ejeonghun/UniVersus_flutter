import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData{
  String id; // id 값
  String token; // JWT토큰값
  String nickname; // 닉네임값
  String platform; // 플랫폼 -> 'kakao' , 'email'

  UserData({required this.id, required this.token, required this.nickname, required this.platform});

  // 사용자 정보를 Secure Storage에 저장하는 메소드
  Future<bool> saveUser() async {
    final storage = FlutterSecureStorage();

    await storage.write(key: 'user_id', value: this.id);
    await storage.write(key: 'token', value: this.token);
    await storage.write(key: 'nickname', value: this.nickname);
    await storage.write(key: 'platform', value: this.platform);

    print("유저 정보 저장 완료");
    return true;
  }

  // 사용자 정보를 Secure Storage에서 불러와서 값이 있으면 반환해주는 메소드
  static Future<UserData?> getUser() async {
    String? s_id;
    String? s_token;
    String? s_nickname;
    String? s_platform;

    final storage = FlutterSecureStorage();

    s_id = await storage.read(key: 'user_id');
    s_token = await storage.read(key: 'token');
    s_nickname = await storage.read(key: 'nickname');
    s_platform = await storage.read(key: 'platform');

    // 값이 모두 존재하면 User 객체로 반환한다.
    if(s_id != null && s_token != null && s_nickname != null && s_platform != null) {
      return UserData(id: s_id, token: s_token, nickname: s_nickname, platform: s_platform);
    } else {
      return null;
    }
  }
}
