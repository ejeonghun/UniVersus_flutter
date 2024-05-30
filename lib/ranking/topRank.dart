import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopRankWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5), // 전체 여백을 5로 설정합니다.
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // 모서리를 라운드 형식으로 만듭니다.
          color: Color(0xFF4B39EF),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Top Rank',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  alignment: AlignmentDirectional(0, -1),
                  children: [
                    _buildRankItem(
                      context,
                      'assets/images/chgf1_.jpg',
                      '🥈경북대',
                      '145P',
                      AlignmentDirectional(-1, 0),
                      EdgeInsetsDirectional.fromSTEB(7, 40, 0, 0),
                      EdgeInsetsDirectional.fromSTEB(28, 150, 0, 0),
                    ),
                    _buildRankItem(
                      context,
                      'assets/images/t7lxm_.svg',
                      '🥇영진대',
                      '582P',
                      AlignmentDirectional(0, 0),
                      EdgeInsetsDirectional.zero,
                      EdgeInsetsDirectional.fromSTEB(0, 130, 0, 0),
                    ),
                    _buildRankItem(
                      context,
                      'assets/images/d3ifr_.svg',
                      '🥉계명대',
                      '115P',
                      AlignmentDirectional(1, 0),
                      EdgeInsetsDirectional.fromSTEB(0, 60, 7, 0),
                      EdgeInsetsDirectional.fromSTEB(0, 170, 26, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankItem(
    BuildContext context,
    String imagePath,
    String rankText,
    String scoreText,
    AlignmentDirectional alignment,
    EdgeInsetsDirectional outerPadding,
    EdgeInsetsDirectional innerPadding,
  ) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: outerPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rankText,
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              scoreText,
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
