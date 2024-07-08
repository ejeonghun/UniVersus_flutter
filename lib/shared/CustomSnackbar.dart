import 'package:flutter/material.dart';

/// Custom 스낵바
/// 생성자 : 이정훈
class CustomSnackbar {
  static void success(
      BuildContext context, String title, String message, int duration) {
    final snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          Icon(Icons.check_circle, color: Colors.white, size: 35),
          SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ]),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0, // 그림자
      duration: Duration(seconds: duration),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void error(
      BuildContext context, String title, String message, int duration) {
    final snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 223, 52, 60),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          Icon(Icons.error, color: Colors.white, size: 35),
          SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ]),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0, // 그림자
      duration: Duration(seconds: duration),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
