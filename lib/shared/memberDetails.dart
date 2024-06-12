import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/IOSAlertDialog.dart';

class MemberDetails {
  final int? memberId;

  MemberDetails(this.memberId);

  Future<void> showMemberDetailsModal(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                fetchMemberDetails(memberId.toString()),
                UserData.getMemberIdx()
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 150, // Adjusted height
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: Text('오류가 발생했습니다: ${snapshot.error}',
                          style: TextStyle(color: Colors.red)),
                    ),
                  );
                } else if (snapshot.hasData) {
                  var memberDetails = snapshot.data![0] as Map<String, dynamic>;
                  var senderIdx = snapshot.data![1] as String?;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          memberDetails['logoImgUrl'],
                          width: 80, // Adjusted size
                          height: 80, // Adjusted size
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('닉네임: ${memberDetails['name']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('학과: ${memberDetails['deptName']}',
                          style: TextStyle(
                              fontSize: 13, overflow: TextOverflow.ellipsis)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4), // Adjusted padding
                        child: Text('한 줄 소개: ${memberDetails['oneLineIntro']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await DirectChat(
                              memberId, int.parse(senderIdx!), context);
                        },
                        child: Text('1대 1 채팅'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold), // Adjusted text size
                        ),
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 150,
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
          'logoImgUrl': response['imageUrl'],
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

  /* 
  * 1대1 채팅방 생성
  * @param senderIdx: 채팅 요청자의 회원번호
  * @param receiverIdx: 채팅 상대방의 회원번호
  * @param context: 현재 화면의 BuildContext
  * 생성자 : 이정훈
  */
  Future<void> DirectChat(
      int? senderIdx, int? receiverIdx, BuildContext context) async {
    DioApiCall api = DioApiCall();
    if (senderIdx == receiverIdx) {
      IOSAlertDialog.show(
          context: context, title: '실패', content: '자신과의 채팅은 불가능합니다.');
      return;
    }
    try {
      final response = await api.post(
          '/chat/direct', {'senderIdx': senderIdx, 'receiverIdx': receiverIdx});
      if (response != null && response.isNotEmpty) {
        if (response['success'] == true) {
          Navigator.of(context).pushNamed('/chat/main');
        } else {
          IOSAlertDialog.show(
              context: context, title: '실패', content: '채팅방 생성에 실패했습니다.');
        }
      }
    } catch (e) {
      print('Error initiating chat: $e');
    }
  }
}
