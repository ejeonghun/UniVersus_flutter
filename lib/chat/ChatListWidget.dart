import 'package:flutter/material.dart';
import 'ChatDetailScreen.dart'; // ChatDetailScreen 파일 import 추가


class ChatListWidget extends StatelessWidget {
  final List<ChatItem> chatItems;

  const ChatListWidget({Key? key, required this.chatItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatItems.length,
      itemBuilder: (BuildContext context, int index) {
        final ChatItem chatItem = chatItems[index];
        return ListTile(
          title: Text(chatItem.title),
          subtitle: Text(chatItem.subtitle),
          onTap: () {
            // 채팅 항목을 클릭했을 때의 동작을 여기에 구현하세요
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(chatItem: chatItem),
              ),
            );
          },
        );
      },
    );
  }
  
}

class ChatItem {
  final String title;
  final String subtitle;

  ChatItem({required this.title, required this.subtitle});
}
