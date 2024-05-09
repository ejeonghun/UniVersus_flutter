import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'chats.dart' show ChatsPage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatRoom {
  final int idx;
  final int memberIdx;
  final int chatRoomType;
  final String? customChatRoomName;
  final int chatRoomId;
  final String? recentChat;
  final String? chatRoomImg;
  final String? recentChatDate;

  ChatRoom({
    required this.idx,
    required this.memberIdx,
    required this.chatRoomType,
    this.customChatRoomName,
    required this.chatRoomId,
    this.recentChat,
    this.chatRoomImg,
    required this.recentChatDate,
  });

  String? get getRecentChatDate {
    if (this.recentChatDate != null) {
      DateTime parsedDate = DateTime.parse(this.recentChatDate!);
      DateTime currentDate = DateTime.now();

      if (parsedDate.year == currentDate.year &&
          parsedDate.month == currentDate.month &&
          parsedDate.day == currentDate.day) {
        return DateFormat('HH:mm').format(parsedDate);
      } else {
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }
    }
    return null; // null 반환 추가
  }
}

class ChatsModel extends FlutterFlowModel<ChatsPage> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<List<ChatRoom>> getChatRoomsListSorted() async {
    try {
      List<ChatRoom> chatRoomList = await getChatRoomsList();
      chatRoomList.sort((a, b) {
        if (a.recentChatDate == null) {
          return 1;
        } else if (b.recentChatDate == null) {
          return -1;
        }
        return b.recentChatDate!.compareTo(a.recentChatDate!);
      });
      return chatRoomList;
    } catch (e) {
      print("Failed to fetch and sort chat rooms: $e");
      return [];
    }
  }

  Future<List<ChatRoom>> getChatRoomsList() async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    try {
      final response = await api.get('/chat/myChatList?memberIdx=${memberIdx}');
      print("API Response: $response");

      if (response.isNotEmpty && response['data'] != null) {
        List<ChatRoom> chatRoomList = [];
        for (var item in response['data']['chatRooms']) {
          chatRoomList.add(ChatRoom(
            recentChat: item['recentChat'] ?? '새 채팅을 시작해보세요',
            idx: item['chatRoom']['idx'],
            memberIdx: item['chatRoom']['memberIdx'],
            chatRoomId: item['chatRoom']['chatRoomId'],
            chatRoomType: item['chatRoom']['chatRoomType'],
            customChatRoomName:
                item['chatRoom']['customChatRoomName'] ?? '이름 미지정',
            chatRoomImg: item['chatRoom']['chatRoomImg'] ??
                'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png',
            recentChatDate: item['recentChatDate'],
          ));
        }
        return chatRoomList;
      } else {
        print("Empty or invalid response data.");
        return [];
      }
    } catch (e) {
      print("Failed to fetch chat rooms: $e");
      return [];
    }
  }
}
