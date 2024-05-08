// 메시지 출력 위젯

import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String senderName;
  final String sentTime;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.senderName,
    required this.sentTime,
  }) : super(key: key);


  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 4.0),
          Text(
            '$senderName - $sentTime',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Message 클래스 정의
class Message {
  final String message;
  final String senderName;
  final String sentTime;

  Message({
    required this.message,
    required this.senderName,
    required this.sentTime,
  });
}
