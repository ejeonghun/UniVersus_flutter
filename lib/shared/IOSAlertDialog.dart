import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * IOS 스타일의 Alert 창
 * 생성자 : 이정훈
 */

class IOSAlertDialog {
  /// IOS 스타일의 Alert 창임
  /// IOSAlertDialog.show(
  ///      context: context,
  ///      title: '실패',
  ///      content: '자신과의 채팅은 불가능합니다.',
  ///    ); 식으로 사용
  static void show({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
