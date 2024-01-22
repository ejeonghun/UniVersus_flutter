import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KakaoLogin {
  final storage = FlutterSecureStorage();

  void _get_user_info() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

      // Save user info in secure storage
      await storage.write(key: 'user_id', value: '${user.id}');
      await storage.write(
          key: 'nickname', value: user.kakaoAccount?.profile?.nickname);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<void> login() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
        _get_user_info();
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        try {
          await UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공');
          _get_user_info();
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
        _get_user_info();
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
      }
    }
  }
}
