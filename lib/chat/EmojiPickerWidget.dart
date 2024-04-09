// 이모지 선택창 위젯

import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected; // 선택된 이모지를 전달하는 콜백 함수

  const EmojiPickerWidget({Key? key, required this.onEmojiSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // 열 수
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: emojiList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // 이모지 선택 콜백 호출
              onEmojiSelected(emojiList[index]);
            },
            child: Center(
              child: Text(
                emojiList[index],
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 이모지 리스트 (예시)
List<String> emojiList = [
  "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣",
  "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "😘",
  "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪",
  "🤨", "🧐", "🤓", "😎", "🤩", "🥳", "😏", "😒",
  // 추가 이모지를 원하는 대로 추가할 수 있습니다.
];
