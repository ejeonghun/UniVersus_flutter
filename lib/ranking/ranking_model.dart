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

class RankingModel {
  DioApiCall api = DioApiCall();

  Future<List<UniversityRanking>> getUniversityRankings(List<int> eventIds) async {
    try {
      Map<int, UniversityRanking> rankingMap = {};

      for (int eventId in eventIds) {
        final response = await api.get('/rank/univ/list?eventId=$eventId');
        if (response['success'] == true && response['data'] != null) {
          List<UniversityRanking> rankings = (response['data'] as List)
              .map((data) => UniversityRanking.fromJson(data))
              .toList();
          for (var ranking in rankings) {
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
}

/*

// 학과
class DepartmentRanking {
  final int deptId;
  final int eventId;
  final int rankPoint;
  final String deptName;
  final int winCount;
  final int loseCount;
  final int totalCount;
  final String logoImg;

  DepartmentRanking({
    required this.deptId,
    required this.eventId,
    required this.rankPoint,
    required this.deptName,
    required this.winCount,
    required this.loseCount,
    required this.totalCount,
    required this.logoImg,
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
      logoImg: json['logoImg'],
    );
  }
}

class DepartmentRankingModel {
  DioApiCall api = DioApiCall();

  Future<List<DepartmentRanking>> getDepartmentRankings(int eventId) async {
    try {
      String? univId = await UserData.getUnivId();
      if (univId == null) {
        throw Exception('No university ID found');
      }

      final response = await api.get('/rank/dept/list?eventId=$eventId&univId=$univId');
      if (response['success'] == true && response['data'] != null) {
        List<DepartmentRanking> rankings = (response['data'] as List)
            .map((data) => DepartmentRanking.fromJson(data))
            .toList();
        return rankings;
      }
      return [];
    } catch (e) {
      print('Error fetching department rankings: $e');
      return [];
    }
  }
}

*/
