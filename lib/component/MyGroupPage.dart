import 'package:flutter/material.dart';

class MyGroupPage extends StatelessWidget {
  final List<Group> groups = [
    Group(
      imageUrl: 'https://via.placeholder.com/150',
      title: '모임 1',
      description: '이것은 모임 1입니다.',
      memberCount: 10,
      region: '서울',
    ),
    Group(
      imageUrl: 'https://via.placeholder.com/150',
      title: '모임 2',
      description: '이것은 모임 2입니다.',
      memberCount: 20,
      region: '부산',
    ),
    // 추가적인 모임 데이터...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 모임'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.network(groups[index].imageUrl), // 모임의 사진
              title: Text(groups[index].title), // 모임 제목
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groups[index].description), // 모임의 소개
                  Text('현재 모임 회원수: ${groups[index].memberCount}'), // 현재 모임 회원수
                  Text('지역구: ${groups[index].region}'), // 지역구
                ],
              ),
              onTap: () {
                // 클릭하면 해당 모임으로 이동
              },
            ),
          );
        },
      ),
    );
  }
}

class Group {
  final String imageUrl;
  final String title;
  final String description;
  final int memberCount;
  final String region;

  Group({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.memberCount,
    required this.region,
  });
}
