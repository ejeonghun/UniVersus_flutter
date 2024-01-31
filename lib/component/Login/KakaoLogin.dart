import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/MainPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KakaoLogin {
  final storage = FlutterSecureStorage();

  Future<void> _get_user_info(BuildContext context) async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n프로필 링크: ${user.kakaoAccount?.profile?.profileImageUrl}'
          '\n이메일 : ${user.kakaoAccount?.email}');

      if (await KakaoLoginBackendReq(user.kakaoAccount?.email, user.id,
              user.kakaoAccount?.profile?.nickname) ==
          true) {
        debugPrint('카카오 로그인 백엔드 Request 성공');
        await storage.write(key: 'user_id', value: '${user.id}');
        await storage.write(
            key: 'nickname', value: '${user.kakaoAccount?.profile?.nickname}');
        await storage.write(
            key: 'user_email', value: '${user.kakaoAccount?.email}');
        await storage.write(key: 'platform', value: 'kakao');
        await storage.write(
            key: 'user_profile_img',
            value: '${user.kakaoAccount?.profile?.profileImageUrl}');
      } else {
        debugPrint('카카오 로그인 백엔드 Request 실패');
      }
      ;
      // Save user info in secure storage
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<bool> KakaoLoginBackendReq(
      String? email, int? KakaoIdx, String? nickname) async {
    try {
      var url =
          'http://172.18.8.190:8080/api/v1/auth/join'; // 백엔드 URL을 여기에 입력하세요.
      var body = jsonEncode({
        'email': email, // 여기에 실제 키-값 쌍을 입력하세요.
        'password': KakaoIdx,
        'nickname': nickname,
      });

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      var responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        // 응답이 성공적이면, 응답 본문을 파싱하고 필요한 작업을 수행하세요.
        debugPrint("회원가입 성공");
        debugPrint('JWT토큰 : ${responseBody['data']['accessToken'].toString()}');
        JwtToken_Save(responseBody['data']['accessToken'].toString());
        return true;
      } else {
        // 로그인으로 넘어감
        var LoginUrl = 'http://172.18.8.190:8080/api/v1/auth/login';
        var LoginResponse = await http.post(
          Uri.parse(LoginUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'email': email,
            'password': KakaoIdx,
          }),
        );
        var LoginResponseBody = jsonDecode(LoginResponse.body);
        if (LoginResponseBody['success'] == true) {
          debugPrint("로그인 성공");
          debugPrint(
              'JWT토큰 : ${LoginResponseBody['data']['accessToken'].toString()}');
          JwtToken_Save(LoginResponseBody['data']['accessToken']);
          return true;
        } else {
          debugPrint("로그인 실패");
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void JwtToken_Save(String token) {
    storage.write(key: 'JWT', value: token);
  }

  Future<bool> login(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _get_user_info(context);
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공');
          debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
          await _get_user_info(context);
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _get_user_info(context);
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
    return true;
  }
}
