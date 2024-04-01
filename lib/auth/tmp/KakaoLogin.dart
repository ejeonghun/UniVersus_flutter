import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universus/class/user/user.dart';

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

      // 만약 이메일이 없는 경우를 대비해 예외 처리 필요

      if (KakaoLoginBackendReq(user.kakaoAccount?.email, user.id,
              user.kakaoAccount?.profile?.nickname) ==
          true) {
        // 백엔드와 통신이 성공되면
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<bool> KakaoLoginBackendReq(
      String? email, int? KakaoIdx, String? nickname) async {
    final String? baseUrl = dotenv.env['BACKEND_URL'];

    try {
      // 1. 카카오 회원가입 진행
      var url = '${baseUrl}/auth/join'; // 백엔드 URL

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

        // 토큰을 UserData 객체에 저장
        UserData myUser = UserData(
            id: email!,
            token: responseBody['data']['tokenDto']['accessToken'].toString(),
            platform: 'kakao',
            memberIdx: "1",
            univId: "1");
        await myUser.saveUser();

        return true;
      }

      // 만약 회원가입이 실패하면? -> 아이디가 이미 존재한다는 뜻
      else {
        // 로그인으로 넘어감
        var LoginUrl = '${baseUrl}/auth/login';
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
          debugPrint("${LoginResponseBody['data']['message'].toString()}");
          debugPrint(
              'JWT토큰 : ${LoginResponseBody['data']['tokenDto']['accessToken'].toString()}');

          // 토큰을 UserData 객체에 저장
          UserData myUser = UserData(
              id: email!,
              token: LoginResponseBody['data']['tokenDto']['accessToken']
                  .toString(),
              platform: 'kakao',
              memberIdx: "1",
              univId: "1");
          await myUser.saveUser();

          return true;
        } else {
          // 배포 시 return false로 변경해줘야함
          debugPrint("로그인 실패");
          return false;
        }
      }
    } catch (e, stackTrace) {
      print('Exception details:\n $e');
      print('Stack trace:\n $stackTrace');
      return false;
    }
    debugPrint("백엔드와 연결되지 않음");
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
