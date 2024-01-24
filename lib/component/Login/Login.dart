import 'package:flutter/material.dart';
import 'package:moyo/component/Login/KakaoLogin.dart';
import 'package:moyo/component/Login/EmailLogin.dart';
import 'package:moyo/component/MainPage.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            KakaoLoginButton(),
            SizedBox(height: 10),
            EmailLoginButton(),
          ],
        ),
      ),
    );
  }
}

// KakaoLoginButton and EmailLoginButton classes remain the same

class KakaoLoginButton extends StatelessWidget {
  final KakaoLogin kakaoLogin = KakaoLogin();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFFFE812)),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
        child: Text("카카오 로그인", style: TextStyle(color: Colors.black)),
        onPressed: () async {
          bool loginSuccess = await kakaoLogin.login(context);
          if (loginSuccess) {
            // 로그인 성공 시 스택을 모두 지우고 MainApp으로 이동
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainApp()),
              (route) => false,
            );
          }
        });
  }
}

class EmailLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
        child: Text("이메일 로그인", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmailLoginForm()),
          );
        });
  }
}
