import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:moyo/component/Login/Login.dart';
import 'package:moyo/component/MainPage.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'c50414fe89e5d4854cee2d5648658978');
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loginInfo;

  @override
  void initState() {
    super.initState();
    _loginInfo = checkLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _loginInfo,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            if (snapshot.data == true) {
              return MainPage();
            } else {
              return Login();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoginInfo() async {
    await Future.delayed(Duration(seconds: 3)); // Show logo for 3 seconds
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'user_id');
    return value != null;
  }
}

class  SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoSize = 0.0;

  @override
  void initState() {
    super.initState();
    _animateLogo();
  }

  void _animateLogo() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _logoSize = 250;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              width: _logoSize,
              height: _logoSize,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(height: 20),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text('나의 모임을 만나는 앱',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}