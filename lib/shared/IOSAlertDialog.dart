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

  /// IOS 스타일의 Confirm 창임
  /// IOSAlertDialog.confirm(
  ///      context: context,
  ///      title: '경고',
  ///      content: '정말로 이 작업을 수행하시겠습니까?',
  ///      onConfirm: () {
  ///        // 확인 버튼을 눌렀을 때 실행할 코드
  ///      },
  ///      onCancel: () {
  ///        // 취소 버튼을 눌렀을 때 실행할 코드
  ///      },
  ///    ); 식으로 사용
  static void confirm({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('취소'),
              onPressed: () {
                if (onCancel != null) {
                  onCancel();
                }
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('확인'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
