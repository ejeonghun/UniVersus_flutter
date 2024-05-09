import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/chat/chatRoom.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'dart:convert';
import 'chats_Model.dart';
export 'chats_Model.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoom chatRoom;

  ChatRoomItem({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: chatRoom.chatRoomImg != null
            ? NetworkImage(chatRoom.chatRoomImg!)
            : AssetImage('assets/default_room.png') as ImageProvider,
        backgroundColor: Colors.transparent,
        onBackgroundImageError: (_, __) => Icon(Icons.error),
      ),
      title: Text(chatRoom.customChatRoomName ?? '상대가 지정되지 않음'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chatRoom.recentChat != null) Text(chatRoom.recentChat!),
              ],
            ),
          ),
          if (chatRoom.getRecentChatDate != null)
            Text(chatRoom.getRecentChatDate!),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ChatScreen(
            chatRoomType: chatRoom.chatRoomType,
            chatRoomId: chatRoom.chatRoomId,
            customChatRoomName: chatRoom.customChatRoomName,
          );
        }));
      },
    );
  }
}

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late ChatsModel _model;
  late Future<List<ChatRoom>> _chatRooms;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _model = ChatsModel();
    _chatRooms = _model.getChatRoomsListSorted();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _refreshData());
  }

  void _refreshData() {
    setState(() {
      _chatRooms = _model.getChatRoomsListSorted();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅방 목록')),
      body: FutureBuilder<List<ChatRoom>>(
        future: _chatRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            // Show loading only on the first load
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("데이터 로드 실패: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return SafeArea(
              child: ListView(
                children: snapshot.data!
                    .map((chatRoom) => ChatRoomItem(chatRoom: chatRoom))
                    .toList(),
              ),
            );
          } else {
            return Center(child: Text('데이터가 없습니다.'));
          }
        },
      ),
    );
  }
}
