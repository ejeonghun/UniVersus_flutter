import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
      BuildContext context, String title, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(title),
          subtitle: Text(message),
        ),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

/*
사용법 

onPressed: () {
              CustomSnackbar.show(
                context,
                '알림',
                '이것은 커스텀 스낵바입니다.',
                3, // 스낵바가 떠있는 시간 (초)
              );
            },

*/