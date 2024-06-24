import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'versusElement_Widget.dart' show VersusElementWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// 대항전 리스트에서 사용하는 대항전 요소(컴포넌트)
/// 생성자 : 이정훈
class VersusElementModel extends FlutterFlowModel<VersusElementWidget> {
  @override
  void initState(BuildContext context) {}

  String getText(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return '진행중';
      case 'RECRUIT':
        return '모집중';
      case 'WAITING':
        return '대기중';
      case 'COMPLETED':
        return '종료';
      case "PREPARED":
        return '준비중';
      default:
        return '';
    }
  }

  Color getColor(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return Colors.yellow;
      case 'RECRUIT':
        return Colors.green;
      case 'WAITING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.red;
      case "PREPARED":
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  String getEventText(int eventId) {
    switch (eventId) {
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
        return '당구/포켓볼';
      case 8:
        return '탁구';
      case 9:
        return 'E-Sport';
      default:
        return '알 수 없음';
    }
  }

  Icon getIcon(int eventId) {
    switch (eventId) {
      case 1:
        return Icon(
          Icons.sports_tennis_sharp,
          size: 25.0,
        ); // 배드민턴
      case 2:
        return Icon(Icons.sports, size: 25.0); // 볼링
      case 3:
        return Icon(Icons.sports_soccer, size: 25.0); // 축구
      case 4:
        return Icon(Icons.sports_soccer, size: 25.0); // 풋살
      case 5:
        return Icon(Icons.sports_baseball, size: 25.0); // 야구
      case 6:
        return Icon(Icons.sports_basketball, size: 25.0); // 농구
      case 7:
        return Icon(Icons.sports_golf, size: 25.0); // 당구/포켓볼
      case 8:
        return Icon(Icons.sports_tennis, size: 25.0); // 탁구
      case 9:
        return Icon(Icons.sports_esports, size: 25.0); // E-Sport
      default:
        return Icon(Icons.help_outline, size: 25.0); // 알 수 없는 eventId
    }
  }

  @override
  void dispose() {}
}
