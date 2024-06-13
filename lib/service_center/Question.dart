import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late Future<List<SupportItem>> _supportListFuture;

  @override
  void initState() {
    super.initState();
    _supportListFuture = SupportListRepository().fetchSupportList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SupportItem>>(
        future: _supportListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return QuestionWidget(supportItems: snapshot.data!);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final List<SupportItem> supportItems;

  QuestionWidget({required this.supportItems});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool _showInquiryCard = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.supportItems.length,
          itemBuilder: (context, index) {
            String formattedDate =
                DateUtil.formatDateTime(widget.supportItems[index].regDt);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionDetailScreen(
                      supportItem: widget.supportItems[index],
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.question_answer),
                title: Text(widget.supportItems[index].title),
                subtitle: Text(widget.supportItems[index].content),
                trailing: Text(formattedDate),
              ),
            );
          },
        ),
        if (_showInquiryCard)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: InquiryCard(),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: FFButtonWidget(
              onPressed: () {
                setState(() {
                  _showInquiryCard = !_showInquiryCard;
                });
              },
              text: '✉  1 : 1 문의',
              options: FFButtonOptions(
                width: double.infinity,
                height: 40,
                color: Theme.of(context).primaryColor,
                textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InquiryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(116.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1 : 1 문의',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '문의하실 내용을 이메일로 보내주세요.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {
                sendEmail();
              },
              child: Text('이메일로 문의하기'),
            ),
          ],
        ),
      ),
    );
  }

  void sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'j2201083@g.yju.ac.kr',
      query: 'subject=1:1 문의',
    );
    final url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class QuestionDetailScreen extends StatelessWidget {
  final SupportItem supportItem;

  QuestionDetailScreen({required this.supportItem});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateUtil.formatDateTime(supportItem.regDt);

    return Scaffold(
      appBar: AppBar(
        title: Text('질문'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supportItem.title,
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
              supportItem.content,
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

class SupportItem {
  final int idx;
  final int memberIdx;
  final String title;
  final String content;
  final String regDt;
  final String? udtDt;

  SupportItem({
    required this.idx,
    required this.memberIdx,
    required this.title,
    required this.content,
    required this.regDt,
    this.udtDt,
  });

  factory SupportItem.fromJson(Map<String, dynamic> json) {
    return SupportItem(
      idx: json['idx'],
      memberIdx: json['memberIdx'],
      title: json['title'],
      content: json['content'],
      regDt: json['regDt'],
      udtDt: json['udtDt'],
    );
  }
}

class SupportListRepository {
  Future<List<SupportItem>> fetchSupportList() async {
    DioApiCall api = DioApiCall();
    try {
      final response = await api.get('/support/list');
      print("API Response:  $response");

      List<dynamic> data = response['data'];
      List<SupportItem> supportItemList =
          data.map((item) => SupportItem.fromJson(item)).toList();

      return supportItemList;
    } catch (e) {
      print('Error fetching support list: $e');
      return []; // Return an empty list in case of error
    }
  }
}

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
