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
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    height: 100,
                  ),
                  Text('모임/동호회의 "오뭐했"을 이쁘게 만들어봐요!',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
            KakaoLoginButton(),
            SizedBox(height: 20),
            EmailLoginButton(),
          ],
        ),
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  final KakaoLogin kakaoLogin = KakaoLogin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFFFE812)),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
          child: Text("카카오 로그인",
              style: TextStyle(color: Colors.black, fontSize: 18)),
          onPressed: () async {
            bool loginSuccess = await kakaoLogin.login(context);
            if (loginSuccess) {
              debugPrint("메인으로 이동");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
            }
          }),
    );
  }
}

class EmailLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
          child: Text("이메일 로그인",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailLoginForm()),
            );
          }),
    );
  }
}
