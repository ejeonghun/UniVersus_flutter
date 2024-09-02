import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class BottomBar2 extends StatefulWidget {
  final int selectedIndex; // 선택된 인덱스를 매개변수로 받습니다.

  const BottomBar2({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomBar2State createState() => _BottomBar2State();
}

class _BottomBar2State extends State<BottomBar2> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // 초기화 시 부모 위젯에서 받은 값으로 설정
  }

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
            Navigator.of(context).pushReplacementNamed('/main');
            break;
          case 1:
            debugPrint('대항전으로 이동');
            Navigator.of(context).pushReplacementNamed('/versusList');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('/Community');
            debugPrint('내 정보 클릭');
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed('/chat/main');
            debugPrint('3');
            break;
          case 4:
            Navigator.of(context).pushReplacementNamed('/profile');
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
      selectedItemColor: Colors.orange,
      currentIndex: _selectedIndex,
      selectedIconTheme: IconThemeData(color: Colors.orange),
      unselectedIconTheme: IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
      selectedLabelStyle: TextStyle(color: Colors.orange),
      unselectedLabelStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
    );
  }
}