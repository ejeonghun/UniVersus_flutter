import 'package:dio/dio.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';

class UnivBattleRecord {
  final int univBattleId;
  final int eventId;
  final String hostUnivName;
  final String guestUnivName;
  final String hostUnivLogo;
  final String guestUnivLogo;
  final String battleDate;
  final String? matchEndDt;
  final String matchStartDt;
  final int hostScore;
  final int guestScore;
  final String result;

  UnivBattleRecord({
    required this.univBattleId,
    required this.eventId,
    required this.hostUnivName,
    required this.guestUnivName,
    required this.hostUnivLogo,
    required this.guestUnivLogo,
    required this.battleDate,
    required this.matchEndDt,
    required this.matchStartDt,
    required this.hostScore,
    required this.guestScore,
    required this.result,
  });

  factory UnivBattleRecord.fromJson(Map<String, dynamic> json) {
    return UnivBattleRecord(
      univBattleId: json['univBattleId'],
      eventId: json['eventId'],
      hostUnivName: json['hostUnivName'],
      guestUnivName: json['guestUnivName'],
      hostUnivLogo: json['hostUnivLogo'],
      guestUnivLogo: json['guestUnivLogo'],
      battleDate: json['battleDate'],
      matchEndDt: json['matchEndDt'],
      matchStartDt: json['matchStartDt'],
      hostScore: json['hostScore'],
      guestScore: json['guestScore'],
      result: json['result'],
    );
  }
}

class UnivBattleRecordModel {
  DioApiCall api = DioApiCall();

  Future<List<UnivBattleRecord>> getUnivBattleRecords(int univId) async {
    // String? univId = await UserData.getUnivId();
    try {
      final response = await api.get('/univBattle/ulist?univId=$univId');
      if (response['success'] == true && response['data'] != null) {
        List<UnivBattleRecord> records = (response['data'] as List)
            .map((data) => UnivBattleRecord.fromJson(data))
            .toList();
        return records;
      }
      return [];
    } catch (e) {
      print('Error fetching university battle records: $e');
      return [];
    }
  }
}
