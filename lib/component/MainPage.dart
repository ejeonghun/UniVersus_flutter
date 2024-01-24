import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyo/component/Login/Login.dart';
import 'package:moyo/main.dart';
import 'package:moyo/component/Member/MyPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final storage = FlutterSecureStorage();
  final categories = ['카테고리1', '카테고리2', '카테고리3'];

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
        title: Image.asset(
          'images/logo.png',
          width: 100, // Adjust width as needed
          height: 50, // Adjust height as needed
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
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
                // TODO: Implement settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그 아웃'),
              onTap: () async {
                String? platform = await storage.read(key: 'platform');
                if (platform == 'kakao') { // 만약 카카오 로그인이면 카카오 SDK 로그아웃 함수 호출
                  await UserApi.instance.logout();
                  debugPrint("카카오 로그아웃 호출");
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
          Container(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 81, 81, 82)),
                    ),
                    child: Text(categories[index], style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // TODO: Implement category filter
                    },
                  ),
                );
              },
            ),
          ),
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
    );
  }
}
