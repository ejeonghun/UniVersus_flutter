import 'package:flutter/material.dart';
import 'MessageWidget.dart'; // MessageWidget 클래스 import 추가
import 'MessageInputWidget.dart'; // MessageInputWidget 클래스 import 추가
import 'ChatHeaderWidget.dart'; // ChatHeaderWidget 클래스 import 추가
import 'MessageLoadingIndicatorWidget.dart'; // MessageLoadingIndicatorWidget 클래스 import 추가

class ChatConversationWidget extends StatelessWidget {
  final List<Message> messages; // 메시지 목록
  final String channelName; // 채널 이름
  final bool isLoading; // 메시지 로딩 상태

  const ChatConversationWidget({
    Key? key,
    required this.messages,
    required this.channelName,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 채팅 헤더: 채팅 화면의 헤더에 해당하는 부분을 표시
        ChatHeaderWidget(channelName: channelName),
        Expanded(
          child: Stack(
            children: [
              // 메시지 목록 표시
              ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = messages[index];
                  return MessageWidget(
                    message: message.message,
                    senderName: message.senderName, // senderName 추가
                    sentTime: message.sentTime, // sentTime 추가
                  );
                },
              ),
              // 메시지 로딩 중인 경우 로딩 인디케이터 표시
              if (isLoading)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MessageLoadingIndicatorWidget(),
                ),
            ],
          ),
        ),
        // 메시지 입력창 표시
        MessageInputWidget(),
      ],
    );
  }
}
