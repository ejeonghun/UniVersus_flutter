// 사용자 목록 위젯 : 현재 채팅에 참여한 사용자 목록 표시 위젯 , 각 사용자의 프로필 사진이나 이름 표시


import 'package:flutter/material.dart';

class UserListWidget extends StatelessWidget {
  final List<String> userList; // 사용자 목록

  const UserListWidget({Key? key, required this.userList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participants:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userList.map((user) {
              return Text(
                user,
                style: TextStyle(fontSize: 16.0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
