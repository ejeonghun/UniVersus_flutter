import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universus/ranking/ranking_model.dart';
import 'package:universus/versus/winloseRecord/record.dart';

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
                  return buildRankings(snapshot.data!);
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
    rankings.sort((a, b) =>
        b.rankPoint.compareTo(a.rankPoint)); // Sort by rankPoint descending
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) {
        int adjustedIndex = index;
        if (index == 0 && rankings.length > 1) {
          adjustedIndex = 1; // Show 2nd place as the first item
        } else if (index == 1 && rankings.isNotEmpty) {
          adjustedIndex = 0; // Show 1st place as the second item
        }

        if (rankings.length <= adjustedIndex) {
          // Add default values for missing rankings
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: adjustedIndex == 1 ? 90 : 70,
                  height: adjustedIndex == 1 ? 90 : 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.school,
                    size: adjustedIndex == 1 ? 70 : 50,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: adjustedIndex == 1 ? 5 : 10),
                Text(
                  '데이터없음',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ["\u{1F948}", "\u{1F947}", "\u{1F949}"][index] + ' 0 Points',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0,
                    adjustedIndex == 0 ? -20 : 0), // Elevate only the 1st place
                child: buildRankItem(
                    rankings[adjustedIndex],
                    ["\u{1F948}", "\u{1F947}", "\u{1F949}"][index],
                    adjustedIndex == 0,
                    0),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildRankItem(UniversityRanking ranking, String medal, bool isElevated,
      double verticalOffset) {
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: GestureDetector(
        onTap: () {
          // Define the action to perform on tap.
          // For example, navigate to a detailed page:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  UnivBattleRecordPage(univId: ranking.univId),
            ),
          );
        },
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
      ),
    );
  }
}
