import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';

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
    if (recentChatDate != null) {
      try {
        DateTime parsedDate = DateTime.parse(recentChatDate!);
        DateTime currentDate = DateTime.now();

        if (parsedDate.year == currentDate.year &&
            parsedDate.month == currentDate.month &&
            parsedDate.day == currentDate.day) {
          return DateFormat('HH:mm').format(parsedDate); // 같은 날이면 HH:mm 형식으로 반환
        } else {
          return DateFormat('yyyy-MM-dd')
              .format(parsedDate); // 그 외는 yyyy-MM-dd 형식으로 반환
        }
      } catch (e) {
        print('날짜 형식 오류: $e');
        return null; // 날짜 형식 오류 발생 시 null 반환
      }
    }
    return null; // recentChatDate가 null인 경우 null 반환
  }
}

class ChatsModel extends ChangeNotifier {
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
      return []; // 에러 발생 시 빈 리스트 반환
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
          chatRoomList.add(
            ChatRoom(
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
            ),
          );
        }
        return chatRoomList;
      } else {
        print("Empty or invalid response data.");
        return []; // 데이터 없음 또는 유효하지 않은 응답 데이터인 경우 빈 리스트 반환
      }
    } catch (e) {
      print("Failed to fetch chat rooms: $e");
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }
}
