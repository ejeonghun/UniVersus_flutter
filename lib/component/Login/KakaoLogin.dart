import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/MainPage.dart';

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

      // Save user info in secure storage
      // 백엔드에서 user의 고유번호와 이메일을 받아서 추가 정보 기입? 하도록 연동?
      await storage.write(key: 'user_id', value: '${user.id}');
      await storage.write(
          key: 'nickname', value: '${user.kakaoAccount?.profile?.nickname}');
      await storage.write(key: 'user_email', value: '${user.kakaoAccount?.email}');
      await storage.write(key: 'platform', value:'kakao');
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<bool> login(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
        await _get_user_info(context);
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        try {
          await UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공');
          await _get_user_info(context);
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
        await _get_user_info(context);
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
    return true;
  }
}
