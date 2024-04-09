// 채팅 헤더 위젯 : 헤더 부분 ,현재 채팅중인 사용자 목록, 채팅방이름 표시

import 'package:flutter/material.dart';

class ChatHeaderWidget extends StatelessWidget {
  final String channelName;

  const ChatHeaderWidget({Key? key, required this.channelName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: Colors.white),
          SizedBox(width: 12.0),
          Text(
            channelName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
