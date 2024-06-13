import 'package:flutter/material.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:timeago/timeago.dart' as timeago;

// announcement_screen.dart

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  late Future<List<AnnouncementList>> _announcementListFuture;

  @override
  void initState() {
    super.initState();
    _announcementListFuture =
        AnnouncementListRepository().fetchAnnouncementList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnnouncementList>>(
        future: _announcementListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return AnnouncementWidget(announcements: snapshot.data!);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// announcement_widget.dart

class AnnouncementWidget extends StatelessWidget {
  final List<AnnouncementList> announcements;

  AnnouncementWidget({required this.announcements});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        String formattedDate =
            DateUtil.formatDateTime(announcements[index].regDt);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnouncementDetailScreen(
                    announcement: announcements[index]),
              ),
            );
          },
          child: ListTile(
            leading: Icon(Icons.announcement), // 아이콘 추가
            title: Text(announcements[index].title),
            subtitle: Text(announcements[index].content),
            trailing: Text(formattedDate),
          ),
        );
      },
    );
  }
}

// announcement_detail_screen.dart
class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementList announcement;

  AnnouncementDetailScreen({required this.announcement});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateUtil.formatDateTime(announcement.regDt);

    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 상세 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '작성일: $formattedDate',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              announcement.content,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// date_util.dart
class DateUtil {
  static String formatDateTime(String dateTime) {
    DateTime now = DateTime.now();
    DateTime parsedDateTime = DateTime.parse(dateTime);
    Duration difference = now.difference(parsedDateTime);

    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 시간 전';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays == 2) {
      return '그저께';
    } else if (difference.inDays <= 30) {
      return '${difference.inDays} 일 전';
    } else {
      return timeago.format(parsedDateTime,
          locale: 'ko'); // 30일 이상인 경우 timeago 라이브러리 사용
    }
  }
}

// announcement_list.dart
class AnnouncementList {
  final int idx;
  final int memberIdx;
  final String title;
  final String content;
  final String regDt;
  final String? udtDt;

  AnnouncementList({
    required this.idx,
    required this.memberIdx,
    required this.title,
    required this.content,
    required this.regDt,
    this.udtDt,
  });

  factory AnnouncementList.fromJson(Map<String, dynamic> json) {
    return AnnouncementList(
      idx: json['idx'],
      memberIdx: json['memberIdx'],
      title: json['title'],
      content: json['content'],
      regDt: json['regDt'],
      udtDt: json['udtDt'],
    );
  }
}

// announcement_list_repository.dart

class AnnouncementListRepository {
  Future<List<AnnouncementList>> fetchAnnouncementList() async {
    DioApiCall api = DioApiCall();
    try {
      final response = await api.get('/announcement/list');
      print("API Response:  $response");

      List<dynamic> data = response['data'];
      List<AnnouncementList> announcementList =
          data.map((item) => AnnouncementList.fromJson(item)).toList();

      return announcementList;
    } catch (e) {
      print('Error fetching announcement list: $e');
      return []; // Return an empty list in case of error
    }
  }
}
