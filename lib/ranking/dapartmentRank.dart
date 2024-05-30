import 'package:flutter/material.dart';
import 'package:universus/ranking/ranking_model.dart';
/*
class DeptRanklistWidget extends StatefulWidget {
  const DeptRanklistWidget({Key? key}) : super(key: key);

  @override
  _DeptRanklistWidgetState createState() => _DeptRanklistWidgetState();
}

class _DeptRanklistWidgetState extends State<DeptRanklistWidget> {
  Future<List<DepartmentRanking>>? _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = DepartmentRankingModel().getDepartmentRankings(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepartmentRanking>>(
      future: _rankingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          var rankings = snapshot.data!;
          return ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              if (index < 3) return Container(); // Skip top 3 for this widget
              final ranking = rankings[index];
              return buildRankItem(context, ranking, index + 1);
            },
          );
        } else {
          return Center(child: Text("No rankings available"));
        }
      },
    );
  }

  Widget buildRankItem(BuildContext context, DepartmentRanking ranking, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x35000000),
              offset: Offset(0.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFFF1F4F8),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  rank.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Color(0xFFBEC5C7),
                        fontSize: 35,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.network(
                  ranking.logoImg,
                  width: 45,
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ranking.deptName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      '${ranking.rankPoint}P',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/