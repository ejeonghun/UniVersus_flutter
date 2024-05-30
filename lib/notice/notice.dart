import 'package:flutter/material.dart';
import 'package:universus/notice/notice_model.dart' as custom;

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  late Future<List<custom.Notification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = custom.NotificationModel().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 페이지'),
      ),
      body: FutureBuilder<List<custom.Notification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return buildNotificationItem(notification);
              },
            );
          } else {
            return Center(child: Text("No notifications available"));
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
          trailing: Text(notification.regDt),
        ),
      ),
    );
  }
}
