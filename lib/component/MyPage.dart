import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universus/component/MainPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:universus/main.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final storage = FlutterSecureStorage();
  String? userId;
  String? userNickname;
  String? userEmail;
  String? userPlatform;
  String? userProfileImgURL;
  String? JWTToken;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    userId = await storage.read(key: 'user_id');
    userNickname = await storage.read(key: 'nickname');
    userEmail = await storage.read(key: 'user_email');
    userPlatform = await storage.read(key: 'platform');
    userProfileImgURL = await storage.read(key: 'user_profile_img');
    JWTToken = await storage.read(key: 'JWT');
    setState(() {});
  }

  void StorageUserClear() async {
    await storage.delete(key: 'user_id'); // 저장된 유저 정보 삭제
    await storage.delete(key: 'JWT');
    await storage.delete(key: 'nickname');
    await storage.read(key: 'user_email');
    await storage.read(key: 'platform');
    await storage.read(key: 'user_profile_img');
    await storage.read(key: 'JWT');
  }

  @override
  Widget build(BuildContext context) {
    Widget _gap() => const SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text("마이 페이지"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          // 프로필 사진과 이름
          Row(
            children: [
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("닉네임"),
                  Text("${userNickname}"),
                ],
              ),
            ],
          ),
          // 정보
          Column(
            children: [
              ListTile(
                title: Text("회원 정보"),
                subtitle: Text("회원 ID: ${userId}"),
              ),
              ListTile(
                title: Text("계정 정보"),
                subtitle: Text("이메일: ${userEmail}"),
              ),
              ListTile(
                title: Text("개인 정보"),
                subtitle: Text("생년월일: 1990-01-01"),
              ),
              ListTile(
                title: Text("플랫폼"),
                subtitle: Text("${userPlatform}"),
              ),
              ListTile(
                title: Text("UUID"),
                subtitle: Text("${JWTToken}"),
              ),
            ],
          ),
          // 설정
          Column(
            children: [
              ListTile(
                title: Text("알림 설정"),
              ),
              ListTile(
                title: Text("보안 설정"),
              ),
              ListTile(
                title: Text("기타 설정"),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '비밀번호 변경',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () async {
                      // 탈퇴하기 기능 구현
                    },
                  )),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '로그아웃',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () async {
                    if (userPlatform == 'kakao') {
                      // 만약 카카오 로그인이면 카카오 SDK 로그아웃 함수 호출
                      try {
                        await UserApi.instance.logout();
                        debugPrint("카카오 로그아웃 호출");
                      } catch (error) {
                        debugPrint('로그아웃 실패, SDK에서 토큰 삭제 $error');
                      } finally {
                        StorageUserClear(); // 저장된 유저 정보 삭제
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp()), // 로그인 화면으로 이동
                        );
                      }
                    } else {
                      StorageUserClear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyApp()), // 로그인 화면으로 이동
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '탈퇴하기',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () async {
                      // 탈퇴하기 기능 구현
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
