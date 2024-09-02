import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universus/chat/chatRoom.dart';
import 'package:universus/chat/chats_Model.dart';
import 'package:universus/notice/notice_model.dart' as custom;
import 'package:universus/versus/deptVersus/deptVersusDetail_Widget.dart';
import 'package:universus/versus/versusDetail_Widget.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotificationsAndChats();
  }

  Future<List<dynamic>> _fetchNotificationsAndChats() async {
    var notifications = await custom.NotificationModel().getNotifications();
    var chatMessages = await ChatsModel().getChatRoomsListSorted();
    var allItems = [...notifications, ...chatMessages];

    allItems.sort((a, b) {
      DateTime dateA, dateB;
      if (a is custom.Notification) {
        dateA = DateTime.parse(a.regDt);
      } else if (a is ChatRoom) {
        dateA = a.recentChatDate != null
            ? DateTime.parse(a.recentChatDate!)
            : DateTime.fromMillisecondsSinceEpoch(0);
      } else {
        return 0;
      }

      if (b is custom.Notification) {
        dateB = DateTime.parse(b.regDt);
      } else if (b is ChatRoom) {
        dateB = b.recentChatDate != null
            ? DateTime.parse(b.recentChatDate!)
            : DateTime.fromMillisecondsSinceEpoch(0);
      } else {
        return 0;
      }

      return dateB.compareTo(dateA);
    });

    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var notificationsAndChats = snapshot.data!;
            return ListView.builder(
              itemCount: notificationsAndChats.length,
              itemBuilder: (context, index) {
                var item = notificationsAndChats[index];
                if (item is custom.Notification) {
                  return buildNotificationItem(item);
                } else if (item is ChatRoom) {
                  return buildChatItem(context, item);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Center(child: Text("No notifications or chats available"));
          }
        },
      ),
    );
  }

  Widget buildNotificationItem(custom.Notification notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x35000000),
              offset: Offset(0.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFFF1F4F8),
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.content),
          trailing: Text(
            DateFormat('yyyy-MM-dd HH:mm')
                .format(DateTime.parse(notification.regDt)),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            // Handle notification tap
            // 대항전 알림 항목을 탭했을 때 DeptVersusDetailWidget 또는 VersusDetailWidget으로 이동하도록 처리
            if (notification.relatedItemId != null) {
              if (notification.type == 'UNIV_BATTLE') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersusDetailWidget(
                      battleId: notification.relatedItemId,
                    ),
                  ),
                );
              } else {
                // 대항전 상세 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => deptVersusDetailWidget(
                      battleId: notification.relatedItemId, // 대항전 ID 전달
                    ),
                  ),
                );
              }
            } else {
              // Handle case where relatedItemId is null
              print("relatedItemId is null");
            }
          },
        ),
      ),
    );
  }

  Widget buildChatItem(BuildContext context, ChatRoom chatRoom) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x35000000),
              offset: Offset(0.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFFF1F4F8),
            width: 1,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: chatRoom.chatRoomImg != null
                ? NetworkImage(chatRoom.chatRoomImg!)
                : AssetImage('assets/default_room.png') as ImageProvider,
            backgroundColor: Colors.transparent,
            onBackgroundImageError: (_, __) => Icon(Icons.error),
          ),
          title: Text(
            chatRoom.customChatRoomName ?? '상대가 지정되지 않음',
            style: TextStyle(
              color: Colors.black, // 원하는 색상으로 변경 가능
            ),
          ),
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
}
