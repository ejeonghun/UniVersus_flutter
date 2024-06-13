import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/BottomBar2.dart';
import 'package:universus/chat/chatRoom.dart';
import 'package:universus/chat/createChatRoom.dart';
import 'package:universus/class/user/user.dart'; // 사용자 클래스 import
import 'dart:convert';
import 'chats_Model.dart';
export 'chats_Model.dart';

// Singleton class for managing Dio instance with base URL
class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  late Dio dio;

  factory ApiManager() {
    return _instance;
  }

  ApiManager._internal() {
    // Initialize Dio instance with base URL
    dio = Dio(BaseOptions(
      baseUrl: 'https://moyoapi.lunaweb.dev/api/v1', // Your base URL here
    ));
  }
}

class ChatRoomItem extends StatelessWidget {
  final ChatRoom chatRoom;

  ChatRoomItem({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chatRoom.chatRoomId.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("채팅방 나가기"),
              content: Text("이 채팅방을 나가시겠습니까?"),
              actions: <Widget>[
                TextButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop(false); // 취소
                  },
                ),
                TextButton(
                  child: Text("나가기"),
                  onPressed: () async {
                    String? currentMemberIdx = await UserData.getMemberIdx();
                    if (currentMemberIdx != null) {
                      bool success = await deleteChatRoom(
                          chatRoom.chatRoomId.toString(), currentMemberIdx);
                      if (success) {
                        // 채팅방에서 나간 시스템 메시지 생성 및 전송
                        String systemMessage =
                            '${UserData.getMemberIdx()} 님이 나갔습니다.';
                        sendSystemMessage(systemMessage);
                      }
                      Navigator.of(context).pop(success); // 성공 여부 반환
                    } else {
                      // currentMemberIdx가 null인 경우 처리
                      Navigator.of(context).pop(false); // 실패 여부 반환하거나 필요한 처리 수행
                    }
                  },
                ),
              ],
            );
          },
        );
        return confirm;
      },
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("채팅방에서 나갔습니다."),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: chatRoom.chatRoomImg != null
                ? NetworkImage(chatRoom.chatRoomImg!)
                : AssetImage('assets/default_room.png') as ImageProvider,
            backgroundColor: Colors.transparent,
            onBackgroundImageError: (_, __) => Icon(Icons.error),
          ),
          title: Text(chatRoom.customChatRoomName ?? 'Unnamed'),
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
        ),
      ),
    );
  }

  Future<bool> deleteChatRoom(String chatRoomId, String memberIdx) async {
    try {
      ApiManager apiManager = ApiManager();
      final response = await apiManager.dio.delete(
        '/chat/delete?chatRoomId=$chatRoomId&memberIdx=$memberIdx',
      );

      print("API 응답: $response");

      return response.data['success'] ?? false;
    } catch (e) {
      print("삭제 API 오류: $e");
      return false;
    }
  }

  void sendSystemMessage(String message) {
    try {
      ApiManager apiManager = ApiManager();
      apiManager.dio.post(
        '/chat/sendMessage',
        data: {
          'chatRoomId': chatRoom.chatRoomId,
          'content': message,
          'type': 'system'
        },
      );
    } catch (e) {
      print("시스템 메시지 전송 오류: $e");
    }
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
      bottomNavigationBar: BottomBar2(), // 바텀 네비게이션 추가
    );
  }
}
