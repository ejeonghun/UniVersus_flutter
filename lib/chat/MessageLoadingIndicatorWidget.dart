// 채팅 목록이나 대화창에서 메시지를 로딩할 때 표시하는 로딩 인디케이터 제공 위젯


import 'package:flutter/material.dart';

class MessageLoadingIndicatorWidget extends StatelessWidget {
  const MessageLoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 8.0),
          Text(
            'Loading messages...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
