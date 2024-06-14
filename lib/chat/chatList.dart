import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universus/BottomBar2.dart';
import 'package:universus/chat/chatRoom.dart';
import 'package:universus/class/user/user.dart'; // 사용자 클래스 import
import 'package:universus/chat/chats_Model.dart'; // ChatsModel import

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  late Dio _dio;

  factory ApiManager() {
    return _instance;
  }

  ApiManager._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://moyoapi.lunaweb.dev/api/v1', // 기본 URL 설정
    ));
  }

  Dio get dio => _dio;

  Future<bool> deleteChatRoom(String chatRoomId, String memberIdx) async {
    try {
      final response = await _dio.delete(
        '/chat/delete',
        queryParameters: {'chatRoomId': chatRoomId, 'memberIdx': memberIdx},
      );

      print("API 응답: $response");

      return response.data['success'] ?? false;
    } catch (e) {
      print("삭제 API 오류: $e");
      return false;
    }
  }

  Future<void> sendSystemMessage(int chatRoomId, String message) async {
    try {
      await _dio.post(
        '/chat/sendMessage',
        data: {'chatRoomId': chatRoomId, 'content': message, 'type': 'system'},
      );
    } catch (e) {
      print("시스템 메시지 전송 오류: $e");
    }
  }
}

class ChatRoomItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final Function(ChatRoom) onDismissed;

  ChatRoomItem({required this.chatRoom, required this.onDismissed});

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
                      bool success = await ApiManager().deleteChatRoom(
                        chatRoom.chatRoomId.toString(),
                        currentMemberIdx,
                      );
                      if (success) {
                        // 채팅방에서 나간 시스템 메시지 생성 및 전송
                        String systemMessage =
                            '${UserData.getMemberIdx()} 님이 나갔습니다.';
                        ApiManager().sendSystemMessage(
                          chatRoom.chatRoomId,
                          systemMessage,
                        );
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
      onDismissed: (direction) => onDismissed(chatRoom),
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
                    if (chatRoom.recentChat != null)
                      Text(
                        chatRoom.recentChat!,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Text(
                chatRoom.getRecentChatDate ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
}

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late ChatsModel _model;
  late Future<List<ChatRoom>> _chatRooms;
  Timer? _timer;
  List<ChatRoom> _chatRoomList = []; // 채팅방 목록을 유지하는 리스트

  @override
  void initState() {
    super.initState();
    _model = ChatsModel();
    _refreshData(); // 초기 데이터 로드
    _timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => _refreshData()); // 30초마다 데이터 업데이트
  }

  void _refreshData() {
    _chatRooms = _model.getChatRoomsListSorted();
    _chatRooms.then((chatRooms) {
      setState(() {
        _chatRoomList = chatRooms; // 채팅방 목록 업데이트
      });
    }).catchError((error) {
      print("Failed to fetch and sort chat rooms: $error");
    });
  }

  void _removeChatRoom(ChatRoom chatRoom) {
    setState(() {
      _chatRoomList.remove(chatRoom);
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshData(); // 새로고침 시 데이터 다시 로드
          },
          child: ListView.builder(
            itemCount: _chatRoomList.length,
            itemBuilder: (context, index) {
              ChatRoom chatRoom = _chatRoomList[index];
              return ChatRoomItem(
                chatRoom: chatRoom,
                onDismissed: _removeChatRoom, // 채팅방 제거 콜백 전달
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomBar2(), // 바텀 네비게이션 추가
    );
  }
}
