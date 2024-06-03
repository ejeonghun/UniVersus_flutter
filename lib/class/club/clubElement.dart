import 'package:flutterflow_ui/flutterflow_ui.dart';

class ClubElement {
  int clubId;
  String eventName;
  String clubName;
  String? introduction;
  int currentMembers;
  String imageUrl;
  String? joinedDt;

  ClubElement({
    required this.clubId,
    required this.eventName,
    required this.clubName,
    this.introduction,
    required this.currentMembers,
    required this.imageUrl,
    this.joinedDt,
  });
  String getFormattedDate() {
    // Assuming regDt is in ISO 8601 format, for example "2023-05-21T10:30:00"
    DateTime dateTime = DateTime.parse(joinedDt!);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
