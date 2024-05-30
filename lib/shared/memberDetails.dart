import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'package:universus/shared/IOSAlertDialog.dart';

/// 회원 정보 조회 클래스
/// 1대1 채팅 기능, 간단 프로필 조회 가능
/// 생성자 : 이정훈
class MemberDetails {
  final int? memberId;

  MemberDetails(this.memberId);

  Future<void> showMemberDetailsModal(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                fetchMemberDetails(memberId.toString()),
                UserData.getMemberIdx(),
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        '오류가 발생했습니다: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          memberDetails['logoImgUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '닉네임: ${memberDetails['name']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '학과: ${memberDetails['deptName']}',
                        style: TextStyle(
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '한 줄 소개: ${memberDetails['oneLineIntro']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await DirectChat(
                            memberId,
                            int.parse(senderIdx!),
                            context,
                          );
                        },
                        child: Text('1대 1 채팅'),
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

  /**
   * 1대 1 채팅방 생성API
   * @param senderIdx: 보내는 사람의 memberIdx
   * @param receiverIdx: 받는 사람의 memberIdx
   * @param context: BuildContext
   * @return Navigator or Alert
   * 생성자 : 이정훈
   */
  Future<void> DirectChat(
      int? senderIdx, int? receiverIdx, BuildContext context) async {
    DioApiCall api = DioApiCall();
    debugPrint(senderIdx.toString());
    debugPrint(receiverIdx.toString());
    if (senderIdx == receiverIdx) {
      IOSAlertDialog.show(
        context: context,
        title: '실패',
        content: '자신과의 채팅은 불가능합니다.',
      );
      return;
    }
    try {
      final response = await api.post('/chat/direct', {
        'senderIdx': senderIdx,
        'receiverIdx': receiverIdx,
      });
      if (response != null && response.isNotEmpty) {
        if (response['success'] == true) {
          // 성공 시 채팅 화면으로 이동
          Navigator.of(context).pushNamed('/chat/main');
        } else {
          // 실패 시 알림 띄움
          IOSAlertDialog.show(
              content: '채팅방 생성에 실패했습니다.', context: context, title: '실패');
        }
      } else {
        // Handle error
      }
    } catch (e) {
      print('Error initiating chat: $e');
      // Handle exception
    }
  }
}
