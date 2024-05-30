import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universus/ranking/ranking_model.dart';

class TopRankWidget extends StatefulWidget {
  const TopRankWidget({Key? key}) : super(key: key);

  @override
  _TopRankWidgetState createState() => _TopRankWidgetState();
}

class _TopRankWidgetState extends State<TopRankWidget> {
  late Future<List<UniversityRanking>> _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = RankingModel().getUniversityRankings(
        [1, 2, 3, 4, 5, 6, 7, 8, 9]); // Pass all event IDs
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 270,
        decoration: BoxDecoration(
          color: Color(0xFF4B39EF),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Color(0x32171717),
              offset: Offset(0.0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Top Rank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<UniversityRanking>>(
              future: _rankingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return buildRankings(
                      snapshot.data!.sublist(0, 3)); // Assuming top 3
                } else {
                  return Text("No rankings available");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRankings(List<UniversityRanking> rankings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) {
        // Correct the order by adjusting the index for the 1st and 2nd places
        int adjustedIndex = index;
        if (index == 0)
          adjustedIndex = 1; // Show 2nd place as the first item
        else if (index == 1)
          adjustedIndex = 0; // Show 1st place as the second item

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0,
                    adjustedIndex == 0 ? -20 : 0), // Elevate only the 1st place
                child: buildRankItem(
                    rankings.length > adjustedIndex
                        ? rankings[adjustedIndex]
                        : null,
                    ["\u{1F947}", "\u{1F948}", "\u{1F949}"][adjustedIndex],
                    adjustedIndex == 0,
                    0),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildRankItem(UniversityRanking? ranking, String medal,
      bool isElevated, double verticalOffset) {
    if (ranking == null) {
      return Container(); // Return an empty container if there's no ranking data
    }
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        children: [
          Container(
            width: isElevated ? 90 : 70,
            height: isElevated ? 90 : 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(ranking.logoImg),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
          SizedBox(height: isElevated ? 5 : 10),
          Text(
            ranking.schoolName,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
          Text(
            ' $medal ${ranking.rankPoint} Points ',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
        ],
      ),
    );
  }
}
