import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'package:universus/shared/IOSAlertDialog.dart';
import 'package:universus/shared/memberDetails.dart';

/// 대결 상세 페이지에서 사용되는 대항전 참가인원 드롭다운 위젯
/// 생성자 : 이정훈
class TeamMemberDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> teamMembers;
  final int hostLeader;
  final int? guestLeader;

  const TeamMemberDropdown(
      {Key? key,
      required this.teamMembers,
      required this.hostLeader,
      required this.guestLeader})
      : super(key: key);

  @override
  _TeamMemberDropdownState createState() => _TeamMemberDropdownState();
}

class _TeamMemberDropdownState extends State<TeamMemberDropdown> {
  String? selectedMemberId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButton<String>(
        hint: Text.rich(
          TextSpan(
            text: '참가 멤버', // 텍스트
            style: TextStyle(fontSize: 16), // 텍스트 스타일
            children: [
              WidgetSpan(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 3, top: 5), // 아이콘과 텍스트 사이에 간격 추가
                  child: Icon(Icons.arrow_drop_down), // 화살표 아이콘
                ),
              ),
            ],
          ),
        ),
        value: selectedMemberId,
        onChanged: (String? newValue) {
          setState(() {
            selectedMemberId = newValue;
            if (selectedMemberId != null) {
              MemberDetails(int.parse(selectedMemberId!))
                  .showMemberDetailsModal(context);
              Timer(Duration(seconds: 1), () {
                // 1초 후 선택 해제
                setState(() {
                  selectedMemberId = null;
                });
              });
            }
          });
        },
        items: widget.teamMembers
            .map<DropdownMenuItem<String>>((Map<String, dynamic> member) {
              return DropdownMenuItem<String>(
                value: member['memberIdx'].toString(),
                child: Container(
                  width: 100,
                  child: Row(
                    children: [
                      member['memberIdx'] == widget.hostLeader ||
                              member['memberIdx'] == widget.guestLeader
                          ? Icon(Icons.star, color: Colors.yellow)
                          : Icon(Icons.person),
                      SizedBox(width: 5),
                      Text('${member['nickName']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            })
            .toSet()
            .toList(),
        style: TextStyle(
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        underline: Container(
          width: 100,
          height: 1,
          color: Colors.blueAccent,
        ),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 0,
      ),
    );
  }
}
