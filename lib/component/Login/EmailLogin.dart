import 'package:flutter/material.dart';

class EmailLoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('이메일 로그인')),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: '이메일 주소'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                ),
                ElevatedButton(
                  child: Text('로그인'),
                  onPressed: () {
                    // TODO: Implement email login
                  },
                ),
              ],
            )));
  }
}
