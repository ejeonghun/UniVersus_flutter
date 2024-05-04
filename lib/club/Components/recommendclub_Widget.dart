import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'recommendclub_Model.dart';
export 'recommendclub_Model.dart';

class RecommendclubWidget extends StatefulWidget {
  const RecommendclubWidget({super.key});

  @override
  State<RecommendclubWidget> createState() => _RecommendclubWidgetState();
}

class _RecommendclubWidgetState extends State<RecommendclubWidget> {
  late RecommendclubModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecommendclubModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional(0, -1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/Rectangle_8_(1).png',
                width: 130,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.83, 0.44),
                child: Icon(
                  Icons.sports_soccer,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.7, 0.44),
                child: Text(
                  '축구',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF00F627),
                        fontSize: 15,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(-0.79, 0.49),
            child: Text(
              '영진 일레븐',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.83, 0.54),
                  child: Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 15,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.74, 0.54),
                  child: Text(
                    '20',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 10,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
