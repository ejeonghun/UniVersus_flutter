import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universus/club/ClubList_Widget.dart';
import 'package:universus/main.dart';
import 'package:universus/main/main_Widget.dart';
import 'package:universus/versus/versusCheck_Widget.dart';
import 'package:universus/versus/versusDetail_Widget.dart';

/**
 * @param payload : 알림(FCM)의 payload(data) = title, content를 제외한 target, data
 * @return navigator
 * 생성자 : 이정훈
 */
void handleNotificationClick(String payload) {
  print("알림 클릭: $payload");
  if (payload.isNotEmpty) {
    final data = jsonDecode(payload);
    final target = data['target'];
    final dataValue = data['data'];
    print("target: $target, data: $dataValue");
    switch (target) {
      case 'club':
        ClubListWidget();
        break;
      case 'univBattle/info': // 대항전 관련 알림 시 대항전 상세페이지로 이동
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) =>
              VersusDetailWidget(battleId: int.parse(dataValue)),
        ));
        break;
      case 'chat':
        break;
      case 'univBattle/resultRes': // 참가자 결과 전송 알림 시
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) =>
              VersusCheckWidget(battleId: int.parse(dataValue)),
        ));
        break;
      case 'notice':
        break;
      default:
        print("알 수 없는 target: $target");
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => MainWidget(),
        ));
        break;
    }
  }
}
