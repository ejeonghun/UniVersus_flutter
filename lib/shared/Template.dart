import 'package:flutter/material.dart';

class Template {
  static Icon getIcon(String eventName, {double size = 20.0}) {
    switch (eventName) {
      case '배드민턴':
        return Icon(
          Icons.sports_tennis_sharp,
          size: size,
        );
      case '볼링':
        return Icon(
          Icons.sports,
          size: size,
        );
      case '축구':
        return Icon(Icons.sports_soccer, size: size);
      case '풋살':
        return Icon(Icons.sports_soccer, size: size);
      case '야구':
        return Icon(Icons.sports_baseball, size: size);
      case '농구':
        return Icon(Icons.sports_basketball, size: size);
      case '당구/포켓볼':
        return Icon(Icons.workspaces, size: size);
      case '탁구':
        return Icon(Icons.sports_tennis, size: size);
      case 'E-Sport':
        return Icon(Icons.sports_esports, size: size);
      default:
        return Icon(Icons.help_outline, size: size);
    }
  }

  static String getEventText(String eventName) {
    switch (eventName) {
      case '배드민턴':
        return '배드민턴';
      case '볼링':
        return '볼링';
      case '축구':
        return '축구';
      case '풋살':
        return '풋살';
      case '야구':
        return '야구';
      case '농구':
        return '농구';
      case '당구/포켓볼':
        return '당구/포켓볼';
      case '탁구':
        return '탁구';
      case 'E-Sport':
        return 'E-Sport';
      default:
        return '알 수 없음';
    }
  }

  static Color getEventTextColor(String eventName) {
    switch (eventName) {
      case '배드민턴':
        return Colors.brown;
      case '볼링':
        return Colors.blue;
      case '축구':
        return Colors.green;
      case '풋살':
        return Colors.cyan;
      case '야구':
        return Colors.purple;
      case '농구':
        return Colors.orange;
      case '당구/포켓볼':
        return Colors.yellow;
      case '탁구':
        return Colors.red;
      case 'E-Sport':
        return Colors.black;
      // 다른 종목에 대한 색상을 반환합니다.
      default:
        return Colors.black;
    }
  }

  static int getEventId(String eventName) {
    switch (eventName) {
      case '배드민턴':
        return 1;
      case '볼링':
        return 2;
      case '축구':
        return 3;
      case '풋살':
        return 4;
      case '야구':
        return 5;
      case '농구':
        return 6;
      case '당구/포켓볼':
        return 7;
      case '탁구':
        return 8;
      case 'E-sport':
        return 9;
      default:
        return 0;
    }
  }

  static String getEventIdToText(int eventName) {
    switch (eventName) {
      case 1:
        return '배드민턴';
      case 2:
        return '볼링';
      case 3:
        return '축구';
      case 4:
        return '풋살';
      case 5:
        return '야구';
      case 6:
        return '농구';
      case 7:
        return '당구/포켓몬';
      case 8:
        return '탁구';
      case 9:
        return 'E-sport';
      default:
        return '';
    }
  }

  static int getCategoryId(String? value) {
    switch (value) {
      case '자유':
        return 1;
      case '모집':
        return 2;
      case '정보':
        return 3;
      default: // null이면 0으로
        return 4;
    }
  }
}
