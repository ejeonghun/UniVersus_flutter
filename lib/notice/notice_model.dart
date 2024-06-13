import 'package:dio/dio.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';

class Notification {
  final int notifId;
  final int receiver;
  final String? caller;
  final String title;
  final String content;
  final String type;
  final String regDt;
  final String targetUrl;
  final int relatedItemId;
  final bool read;

  Notification({
    required this.notifId,
    required this.receiver,
    this.caller,
    required this.title,
    required this.content,
    required this.type,
    required this.regDt,
    required this.targetUrl,
    required this.relatedItemId,
    required this.read,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notifId: json['notifId'],
      receiver: json['receiver'],
      caller: json['caller'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      regDt: json['regDt'],
      targetUrl: json['targetUrl'],
      relatedItemId: json['relatedItemId'],
      read: json['read'],
    );
  }
}

class NotificationModel {
  Future<List<Notification>> getNotifications() async {
    DioApiCall api = DioApiCall();
    String? memberIdx = await UserData.getMemberIdx();
    try {
      final response = await api.get('/notify/list?memberIdx=${memberIdx}');
      print("API Response: $response");
      if (response['success'] == true && response['data'] != null) {
        List<Notification> notifications = (response['data'] as List)
            .map((data) => Notification.fromJson(data))
            .toList();
        return notifications;
      }
      return [];
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
