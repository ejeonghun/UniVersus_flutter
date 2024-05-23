import 'package:flutter/material.dart';
import 'rankList.dart';
import 'topRank.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('랭킹 페이지'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: '학교'),
              Tab(text: '학과'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    TopRankWidget(), // 학교 탭 선택 시 TopRankWidget 표시
                    RanklistWidget(), // 학과 탭 선택 시 RanklistWidget 표시
                  ],
                ),
                Column(
                  children: [
                    TopRankWidget(), // 학교 탭 선택 시 TopRankWidget 표시
                    RanklistWidget(), // 학과 탭 선택 시 RanklistWidget 표시
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
