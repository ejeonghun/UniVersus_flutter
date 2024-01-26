import 'package:flutter/material.dart';
import 'package:moyo/component/Group.dart';

class MainPageGroupList extends StatelessWidget {
  final List<List<Group>> groups;

  MainPageGroupList({required this.groups});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // 열 개수를 설정합니다.
        childAspectRatio: 3.0, // 가로 세로 비율을 설정합니다. 이 값을 조절하여 아이템의 높이를 조정합니다.
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Group group = groups[index ~/ 5][index % 5];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(group.image),
              title: Text(group.title),
              subtitle: Text(group.description),
              onTap: () {
                // 네비게이션
              },
            ),
          );
        },
        childCount: groups.length * 5, // 아이템의 총 개수를 설정합니다.
      ),
    );
  }
}
