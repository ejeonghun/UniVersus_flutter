import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();  // 사용자 입력을 관리하는 컨트롤러
  final ScrollController _scrollController = ScrollController();  // 스크롤 컨트롤러를 생성합니다.
  late IOWebSocketChannel channel;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    // WebSocket 연결 초기화
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://moyoapi.lunaweb.dev/ws/chat/0/2'), // 채팅방 URL 가변 파라미터로 정의해야함
      headers: {'memberIdx': 2}, // 사용자 식별자 추가해야됨 UserData ....
    );

    // 메시지 수신 리스너 설정
    channel.stream.listen((data) {
      processMessage(data);
      _scrollToBottom();  // 새 메시지 수신 후 자동으로 스크롤합니다.
    });
  }

  // 서버로부터 받은 데이터를 처리하는 함수
  void processMessage(String data) {
    setState(() {
      try {
        var decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic> && decoded.containsKey('type') && decoded['type'] == 'system') {
          messages.add(ChatMessage(
            nickname: 'System',
            content: decoded['content'],
            memberIdx: 0,
            profileImg: '',
            regDt: DateTime.now().toIso8601String(),
            type: 'system'
          ));
        } else {
          messages.addAll(List.from(decoded).map((m) => ChatMessage.fromJson(m)));
        }
      } catch (e) {
        messages.add(ChatMessage(
          nickname: 'System',
          content: data,
          memberIdx: 0,
          profileImg: '',
          regDt: DateTime.now().toIso8601String(),
          type: 'system'
        ));
      }
    });
  }

  // 채팅 목록의 끝으로 자동 스크롤하는 함수
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    // 리소스 정리
    _controller.dispose();
    _scrollController.dispose();
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
      _controller.clear();
      _scrollToBottom();  // 메시지 전송 후 스크롤
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,  // 스크롤 컨트롤러 적용
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    leading: message.profileImg.isNotEmpty ? Image.network(message.profileImg, width: 40, height: 40) : null,
                    title: Text(message.nickname),
                    subtitle: Text(message.content),
                    trailing: Text(message.regDt),
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: '메시지 보내기'),
              onSubmitted: (_) => _sendMessage(),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('보내기'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String nickname;
  final String content;
  final int memberIdx;
  final String profileImg;
  final String regDt;
  final String type;

  ChatMessage({
    required this.nickname,
    required this.content,
    required this.memberIdx,
    required this.profileImg,
    required this.regDt,
    this.type = 'message',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      nickname: json['nickname'],
      content: json['content'],
      memberIdx: json['memberIdx'],
      profileImg: json['profileImg'],
      regDt: json['regDt'],
      type: json.containsKey('type') ? json['type'] : 'message',
    );
  }
}
