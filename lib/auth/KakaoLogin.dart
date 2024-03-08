import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moyo/class/user/user.dart';

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

      // User 객체 생성 및 저장
      UserData myUser = UserData(id: user.id.toString(), token: '', nickname: user.kakaoAccount?.profile?.nickname ?? '', platform: 'kakao');
      await myUser.saveUser();

      KakaoLoginBackendReq(user.kakaoAccount?.email, user.id, user.kakaoAccount?.profile?.nickname);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<void> KakaoLoginBackendReq(String? email, int? KakaoIdx, String? nickname) async {
    final String? baseUrl = dotenv.env['BACKEND_URL'];
    try {
      // 1. 카카오 회원가입 진행
      var url = '${baseUrl}/api/v1/auth/join'; // 백엔드 URL

      // 1-1. 카카오 email, idx, nickname으로 body 생성
      var body = jsonEncode({
        'email': email, // 카카오 이메일
        'password': KakaoIdx, // 카카오 idx값
        // 'nickname': nickname, // 카카오 닉네임 값
      });

      // 1-2. 백엔드로 Req 보냄
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      // 1-3. 백엔드의 응답을 받음
      var responseBody = jsonDecode(response.body);

      // 1-4. 회원가입에 성공되면
      if (responseBody['success'] == true) {
        debugPrint("${responseBody['data']['message'].toString()}");
        debugPrint('JWT토큰 : ${responseBody['data']['accessToken'].toString()}');

        // 토큰을 UserData 객체에 저장
        UserData? myUser = await UserData.getUser();
        if (myUser != null) {
          myUser.token = responseBody['data']['accessToken'].toString();
          await myUser.saveUser();
        }

        return true;

      // 만약 회원가입이 실패하면? -> 아이디가 이미 존재한다는 뜻
      } else {
        // 로그인으로 넘어감
        var LoginUrl = '${baseUrl}/api/v1/auth/login';
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
          debugPrint("${responseBody['data']['message'].toString()}");
          debugPrint('JWT토큰 : ${LoginResponseBody['data']['accessToken'].toString()}');

          // 토큰을 UserData 객체에 저장
          UserData? myUser = await UserData.getUser();
          if (myUser != null) {
            myUser.token = LoginResponseBody['data']['accessToken'].toString();
            await myUser.saveUser();
          }

          return true;
        } else {
          // 배포 시 return false로 변경해줘야함
          debugPrint("로그인 실패");
          return true;
        }
      }
    } catch (e) {
      print(e);
      // 배포 시 return false로 변경해줘야함
      return true;
    }
  }
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
