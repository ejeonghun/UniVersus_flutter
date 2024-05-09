import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/user/user.dart';
import 'package:web_socket_channel/io.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universus/chat/chats.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId; // chatRoomId를 위한 필드 추가
  final int chatRoomType;
  final String? customChatRoomName;

// 네비게이터 연결 해야함
  ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.chatRoomType,
    this.customChatRoomName,
  }) : super(key: key); // 생성자 수정

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late IOWebSocketChannel channel;
  List<ChatMessage> messages = [];
  String? currentMemberIdx;

  @override
  void initState() {
    super.initState();
    getCurrentMemberIdxAndInitializeWebSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // UI 빌드 완료 후 스크롤
    });
  }

  Future<void> getCurrentMemberIdxAndInitializeWebSocket() async {
    currentMemberIdx = await UserData.getMemberIdx();
    setState(() {});

    // WebSocket 연결 초기화
    channel = IOWebSocketChannel.connect(
      Uri.parse(
          'ws://moyoapi.lunaweb.dev/ws/chat/${widget.chatRoomType}/${widget.chatRoomId}'),
      headers: {'memberIdx': currentMemberIdx ?? ''}, // 사용자 식별자 추가
    );

    // 메시지 수신 리스너 설정
    channel.stream.listen((data) {
      processMessage(data);
      _scrollToBottom(); // 새 메시지 수신 후 자동으로 스크롤합니다.
    });
  }

  // 서버로부터 받은 데이터를 처리하는 함수
  void processMessage(String data) {
    setState(() {
      try {
        var decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('type') &&
            decoded['type'] == 'system') {
          messages.add(ChatMessage(
              nickname: 'System',
              content: decoded['content'],
              memberIdx: 0,
              profileImg: decoded['profileImg'],
              regDt: DateTime.now().toIso8601String(),
              type: 'system'));
        } else {
          messages
              .addAll(List.from(decoded).map((m) => ChatMessage.fromJson(m)));
          messages.sort((a, b) => a.regDt.compareTo(b.regDt));
        }
      } catch (e) {
        messages.add(ChatMessage(
            nickname: 'System',
            content: data,
            memberIdx: 0,
            profileImg: '',
            regDt: DateTime.now().toIso8601String(),
            type: 'system'));
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
      _scrollToBottom(); // 메시지 전송 후 스크롤
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
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            // 기존의 입력 필드 및 전송 버튼 코드
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: '메시지 보내기',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  tooltip: '메시지 보내기',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    bool isMine = int.parse(currentMemberIdx ?? '0') == message.memberIdx;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(message.profileImg),
              backgroundColor: Colors.transparent,
              onBackgroundImageError: (_, __) => Icon(Icons.account_circle),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _messageContentBubble(message, isMine),
              ],
            ),
          ] else ...[
            _messageContentBubble(message, isMine),
          ]
        ],
      ),
    );
  }

  Widget _messageContentBubble(ChatMessage message, bool isMine) {
    return Container(
      decoration: BoxDecoration(
        color: isMine ? Color(0xFF7465F6) : Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
        border: isMine ? Border.all(color: Color(0xFF7465F6), width: 2) : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: isMine ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              message.regDt, // 'regDt' should be formatted to show only time.
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
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
