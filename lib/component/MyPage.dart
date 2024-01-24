import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/MainPage.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final storage = FlutterSecureStorage();
  String? userId;
  String? userNickname;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    userId = await storage.read(key: 'user_id');
    userNickname = await storage.read(key: 'nickname');
    userEmail = await storage.read(key: 'user_email');
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
                backgroundImage: AssetImage("assets/images/profile.png"),
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
            ],
          ),
        ],
      ),
    );
  }
}