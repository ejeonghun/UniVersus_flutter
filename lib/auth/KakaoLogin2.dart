import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moyo/class/auth/kakaoauth.dart';
import 'package:moyo/class/user/user.dart';
import 'package:moyo/class/api/ApiCall.dart';
import 'package:moyo/class/auth/kakaoauth.dart';

class KakaoLogin2 {
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
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<KakaoAuthDto> _backendReq(String Kakao_token) async {
    debugPrint("카카오 OAuth2.0 토큰값 " + Kakao_token);
    try {
      User user = await UserApi.instance.me();
      var apiCall = ApiCall();
      var responseBody =
          await apiCall.get('/auth/kakao/callback?code=${Kakao_token}');
      if (responseBody['success'] == true) {
        // 요청이 성공적으로 처리 되면?
        if (responseBody['type'] == '기존회원') {
          // 이미 가입이 되어 있으면?
          String BackendResponseEmail = responseBody['userInfo']['email'];
          String BackendResponseToken =
              responseBody['data']['tokenDto']['accessToken'].toString();
          UserData myUser = UserData(
              id: BackendResponseEmail,
              token: BackendResponseToken, // JWT 토큰
              platform: 'kakao');

          await myUser.saveUser();
          // 홈 화면으로 "home"
          return KakaoAuthDto(
              email: null,
              memberidx: null,
              nickname: null,
              accessToken: BackendResponseToken,
              memberStatus: 0);
        } else if (responseBody['type'] == '신규회원') {
          // 신규회원이면?
          // 추가 정보 기입 창으로
          User user = await UserApi.instance.me();
          String BackendResponseToken =
              responseBody['data']['tokenDto']['accessToken'].toString();
          return KakaoAuthDto(
              email: user.kakaoAccount?.email,
              memberidx: user.id.toString(),
              nickname: user.kakaoAccount?.profile?.nickname,
              accessToken: BackendResponseToken,
              memberStatus: 1);
        } else {
          return KakaoAuthDto(
              email: null,
              memberidx: null,
              nickname: null,
              accessToken: 'error',
              memberStatus: 2);
        }
      } else {
        return KakaoAuthDto(
            email: null,
            memberidx: null,
            nickname: null,
            accessToken: 'error',
            memberStatus: 2);
      }
    } catch (e, stackTrace) {
      print('Exception details:\n $e');
      print('Stack trace:\n $stackTrace');
      return KakaoAuthDto(
          email: null,
          memberidx: null,
          nickname: null,
          accessToken: 'error',
          memberStatus: 2);
    }
  }

  Future<KakaoAuthDto> login(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _get_user_info(context);
        return await _backendReq(token.accessToken);
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공');
          debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');

          await _get_user_info(context);
          return await _backendReq(token.accessToken);
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
          return KakaoAuthDto(
              email: null,
              memberidx: null,
              nickname: null,
              accessToken: 'error',
              memberStatus: 2);
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _get_user_info(context);
        return await _backendReq(token.accessToken);
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
        return KakaoAuthDto(
            email: null,
            memberidx: null,
            nickname: null,
            accessToken: 'error',
            memberStatus: 2);
      }
    }
  }
}
