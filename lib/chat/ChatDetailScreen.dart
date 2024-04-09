import 'package:flutter/material.dart';
import 'ChatListWidget.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatItem chatItem;

  const ChatDetailScreen({Key? key, required this.chatItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat Title: ${chatItem.title}'),
            Text('Chat Subtitle: ${chatItem.subtitle}'),
            // 여기에 채팅에 대한 상세 정보를 보여주는 내용을 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
