import 'package:dio/dio.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';

class UniversityRanking {
  final int univId;
  final int eventId;
  int rankPoint;
  final String schoolName;
  int winCount;
  int loseCount;
  int totalCount;
  final String logoImg;

  UniversityRanking({
    required this.univId,
    required this.eventId,
    required this.rankPoint,
    required this.schoolName,
    required this.winCount,
    required this.loseCount,
    required this.totalCount,
    required this.logoImg,
  });

  factory UniversityRanking.fromJson(Map<String, dynamic> json) {
    return UniversityRanking(
      univId: json['univId'],
      eventId: json['eventId'],
      rankPoint: json['rankPoint'],
      schoolName: json['schoolName'],
      winCount: json['winCount'],
      loseCount: json['loseCount'],
      totalCount: json['totalCount'],
      logoImg: json['logoImg'],
    );
  }

  void updateValues(UniversityRanking newRanking) {
    rankPoint += newRanking.rankPoint;
    winCount += newRanking.winCount;
    loseCount += newRanking.loseCount;
    totalCount += newRanking.totalCount;
  }
}

class DepartmentRanking {
  final int deptId;
  final int eventId;
  int rankPoint;
  final String deptName;
  int winCount;
  int loseCount;
  int totalCount;

  DepartmentRanking({
    required this.deptId,
    required this.eventId,
    required this.rankPoint,
    required this.deptName,
    required this.winCount,
    required this.loseCount,
    required this.totalCount,
  });

  factory DepartmentRanking.fromJson(Map<String, dynamic> json) {
    return DepartmentRanking(
      deptId: json['deptId'],
      eventId: json['eventId'],
      rankPoint: json['rankPoint'],
      deptName: json['deptName'],
      winCount: json['winCount'],
      loseCount: json['loseCount'],
      totalCount: json['totalCount'],
    );
  }

  void updateValues(DepartmentRanking newRanking) {
    rankPoint += newRanking.rankPoint;
    winCount += newRanking.winCount;
    loseCount += newRanking.loseCount;
    totalCount += newRanking.totalCount;
  }
}

class RankingModel {
  DioApiCall api = DioApiCall();

  Future<List<UniversityRanking>> getUniversityRankings(
      List<int> eventIds) async {
    try {
      Map<int, UniversityRanking> rankingMap = {};

      for (int eventId in eventIds) {
        final response = await api.get('/rank/univ/list?eventId=$eventId');
        if (response['success'] == true && response['data'] != null) {
          print(response['data']);
          List<UniversityRanking> rankings = (response['data'] as List)
              .map((data) => UniversityRanking.fromJson(data))
              .toList();
          for (var ranking in rankings) {
            print(ranking.toString());
            if (rankingMap.containsKey(ranking.univId)) {
              rankingMap[ranking.univId]!.updateValues(ranking);
            } else {
              rankingMap[ranking.univId] = ranking;
            }
          }
        }
      }
      return rankingMap.values.toList();
    } catch (e) {
      print('Error fetching university rankings: $e');
      return [];
    }
  }

  Future<List<DepartmentRanking>> getDepartmentRankings() async {
    String? univId = await UserData.getUnivId();
    if (univId == null) {
      throw Exception('No university ID found');
    }

    try {
      Map<int, DepartmentRanking> rankingMap = {};

      for (int eventId = 1; eventId <= 9; eventId++) {
        final response =
            await api.get('/rank/dept/list?eventId=$eventId&univId=$univId');
        if (response['success'] == true && response['data'] != null) {
          List<DepartmentRanking> rankings = (response['data'] as List)
              .map((data) => DepartmentRanking.fromJson(data))
              .toList();
          for (var ranking in rankings) {
            if (rankingMap.containsKey(ranking.deptId)) {
              rankingMap[ranking.deptId]!.updateValues(ranking);
            } else {
              rankingMap[ranking.deptId] = ranking;
            }
          }
        }
      }

      List<DepartmentRanking> finalRankings = rankingMap.values.toList();
      finalRankings.sort((a, b) =>
          b.rankPoint.compareTo(a.rankPoint)); // Sort by rankPoint descending
      return finalRankings;
    } catch (e) {
      print('Error fetching department rankings: $e');
      return [];
    }
  }
}
