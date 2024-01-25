import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/Login/Login.dart';
import 'package:moyo/component/Shared/BottomBar2.dart';
import 'package:moyo/main.dart';
import 'package:moyo/component/MyPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:moyo/component/Shared/BottomBar.dart';


class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Current Location
            Text("내 위치", style: TextStyle(fontSize: 14)),
            // Spacer to separate text and logo
            Spacer(),
            // 로고
            // Image.asset(
            //   'images/logo.png', // replace with your actual logo path
            //   height: 40, // adjust the height as needed
            //   width: 50, // adjust the width as needed
            // ),
            // Icons on the right side
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(37.0), // adjust the height as needed
          child: Row(
            children: [
              // Your List Widget
              Expanded(
                child: ListTile(
                  title: Text("모임", style: TextStyle(fontSize: 13)),
                  // Add your list functionality here
                ),
              ),
              // Your AI Recommended Meeting Widget
              Expanded(
                child: ListTile(
                  title: Text("AI 추천 모임", style: TextStyle(fontSize: 13)),
                  // Add your meeting functionality here
                ),
              ),
              // Your Diary Widget
              Expanded(
                child: ListTile(
                  title: Text("Diary", style: TextStyle(fontSize: 13)),
                  // Add your diary functionality here
                ),
              ),
              // Add other widgets as needed
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 110, 85, 138),
              ),
              child: Text(
                '사용자 ID: $userId\n사용자 닉네임: $userNickname',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('채팅'),
              onTap: () {
                // TODO: Implement message screen
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('마이페이지'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('앱 설정'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그 아웃'),
              onTap: () async {
                userPlatform = await storage.read(key: 'platform');
                if (userPlatform == 'kakao') { // 만약 카카오 로그인이면 카카오 SDK 로그아웃 함수 호출
                  try {
                    await UserApi.instance.logout();
                    debugPrint("카카오 로그아웃 호출");
                  } catch(error) {
                    debugPrint("로그아웃 실패, SDK에서 토큰 삭제");
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
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your list length
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('모임 $index'),
                        backgroundColor: Color.fromARGB(255, 56, 83, 100),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      title: Text('모임 $index'),
                      subtitle: Text(
                          '모임 설명 $index'),
                      onTap: () {
                        // 네비게이션
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    bottomNavigationBar: BottomBar2(),
    );
  }
}
