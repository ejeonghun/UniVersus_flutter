import 'package:flutter/material.dart';
import 'package:universus/ranking/dapartmentRankList.dart';
import 'package:universus/ranking/rankList.dart';
import 'package:universus/ranking/topRank.dart'; // 상위 랭크 위젯

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '학교'),
            Tab(text: '학과'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 학교 랭킹 페이지
          Column(
            children: [
              TopRankWidget(), // 상위 랭킹 위젯
              Expanded(
                child: RanklistWidget(), // 4위 이상 랭크 리스트
              ),
            ],
          ),
          // 학과 랭킹 페이지
          Column(
            children: [
              Expanded(
                child: DepartmentRanklistWidget(), // 학과 랭킹 리스트
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
