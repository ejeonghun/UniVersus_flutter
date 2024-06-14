import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:universus/class/api/DioApiCall.dart';
import 'package:universus/class/user/user.dart';

class WithdrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: UserData.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // 데이터 로딩 중일 때 로딩 인디케이터 표시
        }
        if (snapshot.hasData) {
          final userData = snapshot.data!;
          return Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text(
                          '${userData.id}',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 20,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text(
                          '님 탈퇴하시겠습니까?',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 20,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.11),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                        size: 24,
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          ' 회원 탈퇴 유의사항을 확인하였으며 동의합니다.',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.red,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.66),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 18),
                        child: Icon(
                          Icons.warning_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '지금 탈퇴하시면 진행 예정이거나 \n현재 진행중인 대항전을 더 이상 이용하실 수 없게 됩니다 !',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.32),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 18),
                        child: Icon(
                          Icons.warning_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '탈퇴 후에는 작성하신 게시글을 수정 혹은 삭제 하실 수 없어요. \n탈퇴 신청 전에 꼭 확인 바랍니다 !',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.49),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 18),
                        child: Icon(
                          Icons.warning_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '지금 탈퇴하시면 \n대항전 기록 및 개인정보가 영구삭제 됩니다 !',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () {
                        _showPasswordDialog(context, userData.id);
                      },
                      text: '회원 탈퇴',
                      options: FFButtonOptions(
                        width: 300,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // 데이터가 없을 때 표시할 UI 작성
          return Center(child: Text('No data found!'));
        }
      },
    );
  }

  Future<void> _withdraw(BuildContext context, String password) async {
    WithdrawRepository repository = WithdrawRepository();
    String memberIdx = await UserData.getMemberIdx() ?? '';
    bool success = false;
    try {
      // Perform withdrawal operation
      if (await repository.withdraw(memberIdx, password) == true) {
        success = true; // Mark the operation as successful
      } else {
        success = false; // Mark the operation as successful
      }
    } catch (e) {
      // Show error message if withdrawal fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('회원 탈퇴에 실패했습니다.'),
      ));

      // Log the error for debugging
      print('Error during withdrawal: $e');
    }

    // Check if withdrawal was successful
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('회원 탈퇴가 완료되었습니다.'),
      ));

      // Additional processing such as logging out or navigating to another screen
    }

    // Close the dialog
    Navigator.of(context).pop();
  }

  void _showPasswordDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();

        return AlertDialog(
          title: Text('비밀번호 확인'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: '비밀번호를 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                String password = passwordController.text;
                _withdraw(context, password);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

class WithdrawModel {
  final bool success;
  final String resultCode;
  final String message;

  WithdrawModel({
    required this.success,
    required this.resultCode,
    required this.message,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      success: json['success'] ?? false,
      resultCode: json['resultCode'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class WithdrawRepository {
  Future<bool> withdraw(String memberIdx, String password) async {
    DioApiCall api = DioApiCall();

    final response = await api.delete(
      '/member/withDraw?memberIdx=$memberIdx&password=$password',
    );
    print("API Response:  $response");

    // Assuming the response is already a Map
    return response['success'];
  }
}
