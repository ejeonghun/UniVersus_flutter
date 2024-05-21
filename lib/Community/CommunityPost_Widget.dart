import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:universus/Community/PostElement.dart';
import 'package:universus/Community/Post_Widget.dart'; // 날짜 포맷을 위해 추가

// PostElement 클래스를 가져옵니다.

class CommunityPostWidget extends StatelessWidget {
  final PostElement post;

  const CommunityPostWidget({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostWidget(univBoardId: post.univBoardId)));
      },
      child: Padding( // 이 부분 수정
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '[${post.categoryName}] ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: getCategoryTextColor(post.categoryName),
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: post.title,
                    style: TextStyle(),
                  ),
                ],
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 0),
                child: Text(
                  post.content,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1, 0),
              child: Text(
                post.getFormattedDate(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: Color(0xCCA5A5A5),
                      letterSpacing: 0,
                    ),
              ),
            ),
            Divider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).error,
            ),
          ],
        ),
      ),
    );
  }
  
  Color getCategoryTextColor(String categoryName) {
    // 카테고리에 따라 다른 색상을 반환합니다.
    switch (categoryName) {
      case '자유':
        return Colors.red; // 자유 카테고리는 빨간색으로 지정
      case '모집':
        return const Color.fromARGB(255, 250, 227, 18); // 모집 카테고리는 노란색으로 지정
      case '정보':
        return const Color.fromARGB(255, 70, 249, 76); // 정보 카테고리는 초록색으로 지정
      default:
        return Colors.black; // 기본값은 검은색으로 지정
    }
  }
}
