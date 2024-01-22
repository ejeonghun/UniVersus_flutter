import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          width: 100, // Adjust width as needed
          height: 50, // Adjust height as needed
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('채팅'),
              onTap: () {
                // TODO: Implement message screen
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('마이페이지'),
              onTap: () {
                // TODO: Implement profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('앱 설정'),
              onTap: () {
                // TODO: Implement settings screen
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with your list length
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.group),
            title: Text('모임 $index'), // Replace with your group name
            subtitle:
                Text('모임 설명 $index'), // Replace with your group description
            onTap: () {
              // TODO: Implement navigation to group detail screen
            },
          );
        },
      ),
    );
  }
}
