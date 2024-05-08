import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/Community/Post_Widget.dart';
import 'package:universus/main/Components/recruitmentElement.dart';

import 'recruit_Model.dart';
export 'recruit_Model.dart';

class RecruitWidget extends StatefulWidget {
    final RecruitmentElement recruitmentElement;
  const RecruitWidget({super.key,required this.recruitmentElement});

  @override
  State<RecruitWidget> createState() => _RecruitWidgetState();
}

class _RecruitWidgetState extends State<RecruitWidget> {

  late RecruitModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecruitModel());

  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
    child: GestureDetector(
        onTap: () {
          Navigator.push(
            // 추후 수정 필요
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PostWidget(univBoardId: widget.recruitmentElement.univBoardId),
            ),
          );
        },
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://jhuniversus.s3.ap-northeast-2.amazonaws.com/logo.png', // Example placeholder image
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.recruitmentElement.eventName,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                child: Text(
                  widget.recruitmentElement.title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 15,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 15,
                  ),
                  Text(
                    widget.recruitmentElement.place,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 10,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
  );
}
}