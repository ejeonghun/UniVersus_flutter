import 'package:flutter/material.dart';

class EmailLoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // 배경색 설정
      appBar: AppBar(
        title: Text('이메일 로그인'),
        centerTitle: true, // 제목 가운데 정렬
        backgroundColor: Colors.deepPurple, // 앱바 색상 설정
      ),
      body: SingleChildScrollView( // 키보드 올라올 때 스크롤 가능하도록
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40), // 여백 추가
              // Image.asset(
              //   'assets/images/logo.png', // 로고 이미지
              //   width: 150,
              // ),
              SizedBox(height: 40), // 여백 추가
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일 주소',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true, // 입력창 채우기
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20), // 여백 추가
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true, // 입력창 채우기
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 40), // 여백 추가
              SizedBox(
                width: double.infinity, // 버튼 가로로 꽉 채우기
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple, // 버튼 색상 설정
                  ),
                  child: Text('로그인', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    // TODO: Implement email login
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}