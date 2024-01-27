import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/Login/Login.dart';
import 'package:moyo/component/MainPageGroupList.dart';
import 'package:moyo/component/Shared/BottomBar2.dart';
import 'package:moyo/main.dart';
import 'package:moyo/component/MyPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:moyo/component/MainPageLikeCardLayout.dart';
import 'package:moyo/component/Group.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final storage = FlutterSecureStorage();
  final categories = ['스포츠', '게임', '스터디모임'];

  String? userId;
  String? userNickname;
  String? userPlatform;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    userId = await storage.read(key: 'user_id');
    userNickname = await storage.read(key: 'nickname');
    if (userId == null) {
      // 로그인 정보가 없으면 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      setState(() {});
    }
  }


  final posts = List.generate( // 메인페이지 최상단 카드 레이아웃 임시 데이터
    10,
    (index) => Post(
      title: 'Post $index',
      content: 'Content for Post $index',
      likes: index * 10,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("내 위치", style: TextStyle(fontSize: 14)),
            Spacer(),
            // 로고
            // Image.asset(
            //   'images/logo.png', // replace with your actual logo path
            //   height: 40, // adjust the height as needed
            //   width: 50, // adjust the width as needed
            // ),
            // Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Implement notification functionality
              },
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                // Implement message functionality
              },
            ),
          ],
        ),
      ),
body: CustomScrollView(
  slivers: <Widget>[
    SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 추가
            child: Text(
              '월간 오뭐했 Top3', // 섹션 제목
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Container( // 월간 "오뭐했" Top3
            height: 170, 
            child: MainPageLikeCardLayout(posts: posts),
          ),
          Divider(color: Colors.grey), // 구분선
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 추가
            child: Text(
              '추천 모임', // 섹션 제목
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
    MainPageGroupList(groups: [
      // 더미 데이터
      [
        Group(title: '모임1', description: '모임 설명1', image: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png'),
        Group(title: '모임2', description: '모임 설명2', image: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png'),
        Group(title: '모임3', description: '모임 설명3', image: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png'),
        Group(title: '모임4', description: '모임 설명4', image: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png'),
        Group(title: '모임5', description: '모임 설명5', image: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png'),
      ],
      // 추가 그룹 리스트
    ]),
  ],
),
bottomNavigationBar: BottomBar2(),
    );
  }
}
