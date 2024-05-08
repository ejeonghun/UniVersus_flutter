// ListViewBuilderWidget.dart
import 'package:flutter/material.dart';
import 'ChatListWidget.dart';
import 'ChatDetailScreen.dart';

class ListViewBuilderWidget extends StatelessWidget {
  final List<ChatItem> chatItems;

  const ListViewBuilderWidget({Key? key, required this.chatItems})
      : super(key: key);

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
