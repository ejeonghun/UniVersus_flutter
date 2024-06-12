import 'package:flutter/material.dart';
import 'package:universus/ranking/ranking_model.dart';
import 'package:universus/winloseRecord/record.dart';

class RanklistWidget extends StatefulWidget {
  const RanklistWidget({Key? key}) : super(key: key);

  @override
  _RanklistWidgetState createState() => _RanklistWidgetState();
}

class _RanklistWidgetState extends State<RanklistWidget> {
  Future<List<UniversityRanking>>? _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture =
        RankingModel().getUniversityRankings([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UniversityRanking>>(
      future: _rankingsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
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
          // Display an empty container or a static layout if there's no data
          return Center(child: Text("Loading rankings..."));
        }
      },
    );
  }

  Widget buildRankItem(
      BuildContext context, UniversityRanking ranking, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  UnivBattleRecordPage(univId: ranking.univId),
            ),
          );
        },
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
                        ranking.schoolName,
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
      ),
    );
  }
}
