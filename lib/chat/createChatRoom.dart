import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class CreateChatRoomScreen extends StatefulWidget {
  final int chatRoomId;

  const CreateChatRoomScreen({super.key, required this.chatRoomId});

  @override
  _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  List<ChatCreate> members = [];
  late IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    initializeWebSocket();
    fetchAllMembers();
  }

  void initializeWebSocket() {
    channel = IOWebSocketChannel.connect(
        'ws://moyoapi.lunaweb.dev/ws/chat/3/${widget.chatRoomId}');
    channel.stream.listen(
      (message) {
        processServerMessage(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  void fetchAllMembers() {
    // Simulate fetching members from an API or local storage
    // Example setup, replace with actual data fetch logic
    setState(() {
      members = [
        ChatCreate(
            nickname: "John Doe",
            memberIdx: 1,
            profileImg: "https://example.com/image.png",
            type: "create")
      ];
    });
  }

  void createChatRoom(ChatCreate member) {
    // Send a message to the WebSocket server to create a chat room
    var message = jsonEncode({
      'action': 'create_chat_room',
      'memberIdx': member.memberIdx,
      'nickname': member.nickname,
      'type': member.type,
    });
    channel.sink.add(message);
    print('Creating chat room with ${member.nickname}');
  }

  void processServerMessage(String message) {
    var decodedMessage = jsonDecode(message);
    if (decodedMessage['type'] == 'confirmation') {
      // Handle confirmation message, e.g., display a success notification
      print('Chat room created successfully!');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Chat Room')),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          var member = members[index];
          return ListTile(
            title: Text(member.nickname),
            subtitle: Text('Member ID: ${member.memberIdx}'),
            leading:
                CircleAvatar(backgroundImage: NetworkImage(member.profileImg)),
            onTap: () => createChatRoom(member),
          );
        },
      ),
    );
  }
}

class ChatCreate {
  final String nickname;
  final int memberIdx;
  final String profileImg;
  final String type;

  ChatCreate({
    required this.nickname,
    required this.memberIdx,
    required this.profileImg,
    this.type = 'create',
  });

  factory ChatCreate.fromJson(Map<String, dynamic> json) {
    return ChatCreate(
      nickname: json['nickname'],
      memberIdx: json['memberIdx'],
      profileImg: json['profileImg'],
      type: json.containsKey('type') ? json['type'] : 'create',
    );
  }
}
