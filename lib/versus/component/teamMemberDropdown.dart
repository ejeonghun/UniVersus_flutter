import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';

class TeamMemberDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> teamMembers;
  final int hostLeader;
  final int? guestLeader;

  const TeamMemberDropdown({Key? key, required this.teamMembers, required this.hostLeader, required this.guestLeader})
      : super(key: key);

  @override
  _TeamMemberDropdownState createState() => _TeamMemberDropdownState();
}

class _TeamMemberDropdownState extends State<TeamMemberDropdown> {
  String? selectedMemberId;

  void showMemberDetailsModal(BuildContext context, String memberId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)), // Rounded corners
          child: Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchMemberDetails(memberId),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height:
                        200, // Fixed height to maintain dialog size even while loading
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                        child: Text('오류가 발생했습니다: ${snapshot.error}',
                            style: TextStyle(color: Colors.red))),
                  );
                } else if (snapshot.hasData) {
                  var memberDetails = snapshot.data!;
                  return Column(
                    mainAxisSize: MainAxisSize.min, // Use minimum space
                    children: <Widget>[
                      ClipOval(
                        child: Image.network(
                          memberDetails['logoImgUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('닉네임: ${memberDetails['name']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('학과: ${memberDetails['deptName']}',
                          style: TextStyle(
                              fontSize: 13, overflow: TextOverflow.ellipsis)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('한 줄 소개: ${memberDetails['oneLineIntro']}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700])),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('닫기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurple, // Button background color
                          foregroundColor: Colors.white, // Text color
                          elevation: 5, // Shadow elevation
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8)), // Rounded corners
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15), // Button padding
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold), // Text style
                        ),
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text('데이터가 없습니다.')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchMemberDetails(String memberId) async {
    DioApiCall api = DioApiCall();
    try {
      final response = await api.get('/member/profile/?memberIdx=$memberId');
      if (response != null && response.isNotEmpty) {
        return {
          'name': response['nickname'] ?? '알 수 없음',
          'deptName': response['deptName'] ?? '학과 정보 없음',
          'logoImgUrl': (response['profileImage'] != null &&
                  response['profileImage'].isNotEmpty)
              ? response['profileImage'][0]['imageUrl']
              : 'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/default/df_profile.jpg',
          'oneLineIntro': response['oneLineIntro'] ?? "한 줄 소개가 없습니다."
        };
      } else {
        print('Server Error: Empty or Invalid Response');
        return _defaultMemberDetails();
      }
    } catch (e) {
      print('Error fetching member details: $e');
      return _defaultMemberDetails();
    }
  }

  Map<String, dynamic> _defaultMemberDetails() {
    return {
      'name': '알 수 없음',
      'deptName': '학과 정보 없음',
      'logoImgUrl':
          'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/default/df_profile.jpg',
      'oneLineIntro': "한 줄 소개가 없습니다."
    };
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('멤버 목록'),
      value: selectedMemberId,
      onChanged: (String? newValue) {
        setState(() {
          selectedMemberId = newValue;
          if (selectedMemberId != null) {
            showMemberDetailsModal(context, selectedMemberId!);
            Timer(Duration(seconds: 1), () { // 1초 후 선택 해제
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
              child: Row(
                children: [
                  member['memberIdx'] == widget.hostLeader || member['memberIdx'] == widget.guestLeader
                      ? Icon(Icons.star, color: Colors.yellow)
                      :
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('${member['nickName']}'),
                ],
              ),
            );
          })
          .toSet()
          .toList(),
      style: TextStyle(
        fontSize: 16,
        color: FlutterFlowTheme.of(context).primaryText,
      ),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 36,
    );
  }
}
