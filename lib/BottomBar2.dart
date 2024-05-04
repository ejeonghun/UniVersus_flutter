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
            if (_selectedIndex != 0) {
              debugPrint("메인으로 이동");
              Navigator.of(context).pushNamed('/main');
            } else {
              debugPrint("현재 메인임");
            }
            break;
          case 1:
            debugPrint('대항전으로 이동');
            Navigator.of(context).pushNamed('/versusList');
            break;
          case 2:
            Navigator.of(context).pushNamed('/community');
            debugPrint('내 정보 클릭');
            break;
          case 3:
            Navigator.of(context).pushNamed('/profile');
            debugPrint('3');
            break;
          default:
            debugPrint('의도하지 않은 버튼');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: '대항전'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: '커뮤니티'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필')
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      unselectedItemColor: FlutterFlowTheme.of(context).primaryText,
      selectedItemColor: FlutterFlowTheme.of(context).tertiary,
      // unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      currentIndex: _selectedIndex,
      selectedLabelStyle: TextStyle(color: Colors.amber[800]),
      unselectedLabelStyle: TextStyle(
          color: const Color.fromARGB(
              255, 0, 0, 0)), // Set text color for unselected items
    );
  }
}
