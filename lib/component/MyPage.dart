import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/MainPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:moyo/main.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProfileImgURL ?? 'https://i.ibb.co/X3wqTFm/image-upload.png'),
              ),
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
                    '로그아웃',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                if (userPlatform == 'kakao') { // 만약 카카오 로그인이면 카카오 SDK 로그아웃 함수 호출
                  try {
                    await UserApi.instance.logout();
                    debugPrint("카카오 로그아웃 호출");
                  } catch(error) {
                    debugPrint('로그아웃 실패, SDK에서 토큰 삭제 $error');
                  }
                }
                await storage.delete(key: 'user_id'); // 저장된 유저 정보 삭제
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp()), // 로그인 화면으로 이동
                );
                },
              ),
            ),
            ],
          ),
        ],
      ),
    );
  }
}