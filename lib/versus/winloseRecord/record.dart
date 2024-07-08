import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universus/shared/Template.dart';
import 'package:universus/versus/winloseRecord/record_model.dart';

class UnivBattleRecordPage extends StatefulWidget {
  final int univId;

  const UnivBattleRecordPage({Key? key, required this.univId})
      : super(key: key);

  @override
  _UnivBattleRecordPageState createState() => _UnivBattleRecordPageState();
}

class _UnivBattleRecordPageState extends State<UnivBattleRecordPage> {
  late Future<List<UnivBattleRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
  }

  String formatTimeAgo(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('승패 기록'),
      ),
      body: FutureBuilder<List<UnivBattleRecord>>(
        future: UnivBattleRecordModel().getUnivBattleRecords(widget.univId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var records = snapshot.data!;
            if (records.isEmpty) {
              return Center(child: Text("No records available"));
            }
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                var record = records[index];
                return buildRecordItem(context, record);
              },
            );
          } else {
            return Center(child: Text("No records available"));
          }
        },
      ),
    );
  }

  Widget buildRecordItem(BuildContext context, UnivBattleRecord record) {
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
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
                child: Container(
                  width: 10,
                  height: 100,
                  decoration: BoxDecoration(
                    color: record.result == 'win'
                        ? Color(0xFF230bfd)
                        : Color(0xFFFF0044),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                                child: Text(
                                  Template.getEventIdToText(record.eventId),
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF14181B),
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 1),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 80, 40), // 여기서 간격을 조정합니다.
                                child: Text(
                                  '${record.result == 'win' ? '승리' : '패배'}\n${formatTimeAgo(record.matchStartDt)}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {},
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Color(0x4D9489F5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: record.result == 'win'
                                        ? Color(0xFF230bfd)
                                        : Color(0xFFFF0044),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      record.hostUnivLogo,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 1),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                child: Container(
                                  width: 70,
                                  child: Stack(
                                    alignment: AlignmentDirectional(0, 0),
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Container(
                                          width: 110,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: record.result == 'win'
                                                ? Color(0xFF230bfd)
                                                : Color(0xFFFF0044),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 27,
                                        height: 27,
                                        decoration: BoxDecoration(
                                          color: record.result == 'win'
                                              ? Color(0xFF230bfd)
                                              : Color(
                                                  0xFFFF0044), // 패배시 빨간색으로 변경
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          'VS',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                fontSize: 15,
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {},
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Color(0x4D9489F5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: record.result == 'win'
                                        ? Color(0xFF230bfd)
                                        : Color(0xFFFF0044),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      record.guestUnivLogo,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
