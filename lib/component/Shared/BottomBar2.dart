import 'package:flutter/material.dart';
import 'package:moyo/component/MainPage.dart';
import 'package:moyo/component/MyPage.dart';
import 'package:moyo/component/MainPageLikeCardLayout.dart';

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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
            break;
          case 1:
            debugPrint('test');
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
              );
            debugPrint('내 정보 클릭');
            break;
          case 3:
            debugPrint('3');
            break;
          default:
            debugPrint('의도하지 않은 버튼');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: '내 모임'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: '다이어리')
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue[200],
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedItemColor: Colors.amber[800],
      // unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      currentIndex: _selectedIndex,
      selectedLabelStyle: TextStyle(color: Colors.amber[800]),
      unselectedLabelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Set text color for unselected items
    );
  }
}