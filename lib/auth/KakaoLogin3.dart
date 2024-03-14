import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:moyo/class/auth/kakaoauth.dart';
import 'package:moyo/class/user/user.dart';
import 'package:moyo/class/api/ApiCall.dart';

class KakaoLogin3 {
  final storage = FlutterSecureStorage();

  Future<void> _getUserInfo(BuildContext context) async {
    try {
      User? user = await UserApi.instance.me();
      if (user != null) {
        print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}' // int
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}' // String?
            '\n프로필 링크: ${user.kakaoAccount?.profile?.profileImageUrl}' // String? 
            '\n이메일 : ${user.kakaoAccount?.email}' // String?
            '\n생년월일 : ${user.kakaoAccount?.birthday}' // String? (MMDD)
            '\n출생년도 : ${user.kakaoAccount?.birthyear}' // String? (YYYY)
            '\n성별 : ${user.kakaoAccount?.gender?.toString()}' // Gender?(famale, male, other)
            '\n전화번호 : ${user.kakaoAccount?.phoneNumber}' // String? 카카오톡에서 인증한 전화번호
            '\n카카오계정 이름 : ${user.kakaoAccount?.name}' // String? 카카오계정 이름
            );
      } else {
        print('사용자 정보 요청 실패');
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<String?> _backendReq(bool? loginStatus) async {
    try {
      User? user = await UserApi.instance.me();
      if (loginStatus == false) {
        return '실패';
      }
      String? email = user?.kakaoAccount?.email;
      int? kakaoIdx = user?.id;
      var apiCall = ApiCall();
      var responseBody =
          await apiCall.post('/auth/kakao/app', {'email': email, 'kakaoIdx': kakaoIdx});
      if (responseBody['success'] == true) {
        // 서버 요청이 성공적으로 처리 되면? -> 서버 오류는 false
        if (responseBody['message'] == '로그인 성공') {
          // 이미 가입이 되어 있으면?
          if (responseBody['data']['infoCheck'] == 0) {
            // 아직 추가 정보 기입을 하지 않았으면? -> 추가 정보 기입 페이지로
            return '추가정보기입';
          } else {
            // 추가 정보를 기입 했으면? -> 로그인 완료
            return '로그인';
          }
        } else if (responseBody['message'] == '회원가입이 완료되었습니다.') {
          // 신규회원이면? -> 추가 정보 기입 창으로
          return '추가정보기입';
        } else {
          // 그 외의 경우 예외 처리
          return '오류';
        }
      } else {
        // 서버 내부 오류 발생하면? -> success=false
        return '오류';
      }
    } catch (e, stackTrace) {
      print('Exception details:\n $e');
      print('Stack trace:\n $stackTrace');
      return null;
    }
  }

  Future<KakaoAuthDto?> resCheck(String? res) async {
     User? user = await UserApi.instance.me();
    if (res == '추가정보기입') {
      // 추가 정보 기입
      return Future.value(KakaoAuthDto(
        email: user.kakaoAccount?.email,
        kakaoIdx: user.id,
        nickname: user.kakaoAccount?.profile?.nickname?? '',
        birthday: user.kakaoAccount?.birthday ?? '',
        birthyear: user.kakaoAccount?.birthyear ?? '',
        gender: user.kakaoAccount?.gender?.toString() ?? '',
        phoneNumber: user.kakaoAccount?.phoneNumber ?? '',
        name: user.kakaoAccount?.name ?? '',
        memberStatus: 0,
      ));
    } else if (res == '로그인') {
      // 로그인 성공
      return Future.value(KakaoAuthDto(
        email: user.kakaoAccount?.email,
        kakaoIdx: user.id,
        memberStatus: 1,
      ));
    } else {
      // 에러 처리
      return Future.value(KakaoAuthDto(memberStatus: 2));
    }
  }

  Future<KakaoAuthDto?> login(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _getUserInfo(context);
        return await resCheck(await _backendReq(true));
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        return await resCheck(await _backendReq(false));
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
        debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
        await _getUserInfo(context);
        return await resCheck(await _backendReq(true));
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
        return await resCheck(await _backendReq(false));
      }
    }
  }
}

