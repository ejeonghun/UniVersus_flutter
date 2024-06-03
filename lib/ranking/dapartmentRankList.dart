import 'package:flutter/material.dart';
import 'package:universus/ranking/ranking_model.dart';

class DepartmentRanklistWidget extends StatefulWidget {
  const DepartmentRanklistWidget({Key? key}) : super(key: key);

  @override
  _DepartmentRanklistWidgetState createState() =>
      _DepartmentRanklistWidgetState();
}

class _DepartmentRanklistWidgetState extends State<DepartmentRanklistWidget> {
  Future<List<DepartmentRanking>>? _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = RankingModel().getDepartmentRankings();
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

  Widget buildRankItem(
      BuildContext context, DepartmentRanking ranking, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: rank == 1
              ? Color(0xFFFFD700)
              : rank == 2
                  ? Color(0xFFC0C0C0)
                  : rank == 3
                      ? Color(0xFFCD7F32)
                      : Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x35000000),
              offset: Offset(0.0, 1),
            ),
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
                        color: rank == 1 || rank == 2 || rank == 3
                            ? Colors.white
                            : Color(0xFFBEC5C7),
                        fontSize: 35,
                      ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _trimDeptName(ranking.deptName),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: rank == 1 || rank == 2 || rank == 3
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    Text(
                      '${ranking.rankPoint}P',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: rank == 1 || rank == 2 || rank == 3
                                ? Colors.white
                                : Colors.black,
                          ),
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

  String _trimDeptName(String deptName) {
    int index = deptName.indexOf('(');
    if (index != -1) {
      return deptName.substring(0, index);
    }
    return deptName;
  }
}
