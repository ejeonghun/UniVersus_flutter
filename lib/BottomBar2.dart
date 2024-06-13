import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class BottomBar2 extends StatefulWidget {
  const BottomBar2({Key? key}) : super(key: key);

  @override
  _BottomBar2State createState() => _BottomBar2State();
}

class _BottomBar2State extends State<BottomBar2> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });

        switch (index) {
          case 0:
            debugPrint("메인으로 이동");
            Navigator.of(context).pushNamed('/main1');
            break;
          case 1:
            debugPrint('대항전으로 이동');
            Navigator.of(context).pushNamed('/versusList');
            break;
          case 2:
            Navigator.of(context).pushNamed('/Community');
            debugPrint('내 정보 클릭');
            break;
          case 3:
            Navigator.of(context).pushNamed('/chat/main');
            debugPrint('3');
            break;
          case 4:
            Navigator.of(context).pushNamed('/profile');
            debugPrint('4');
            break;
          default:
            debugPrint('의도하지 않은 버튼');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.sports_mma), label: '대항전'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: '커뮤니티'),
        BottomNavigationBarItem(icon: Icon(Icons.sms), label: '채팅'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필')
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      unselectedItemColor: FlutterFlowTheme.of(context).primaryText,
      selectedItemColor: FlutterFlowTheme.of(context).primaryText, // 선택된 항목의 아이콘 색상을 선택되지 않은 항목과 같게 설정
      currentIndex: _selectedIndex, // 현재 선택된 인덱스 반영
      selectedLabelStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryText), // 선택된 항목의 텍스트 색상을 선택되지 않은 항목과 같게 설정
      unselectedLabelStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryText), // 선택되지 않은 항목의 텍스트 색상
    );
  }
}
