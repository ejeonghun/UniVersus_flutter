import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/versus/versusList_Model.dart';
import 'package:universus/versus/versusList_Widget.dart';

import 'versusSearch_Model.dart';
export 'versusSearch_Model.dart';

class VersusSearchWidget extends StatefulWidget {
  const VersusSearchWidget({Key? key, required this.setStatusCode, required this.selectedIndex}) : super(key: key);
  final Function setStatusCode;
  final int selectedIndex; // Receive the selected index from the parent

  @override
  State<VersusSearchWidget> createState() => _VersusSearchWidgetState();
}

class _VersusSearchWidgetState extends State<VersusSearchWidget> {
  late VersusSearchModel _model;
  List<String> options = ['전체', '모집 중', '시작 전', '진행 중', '종료'];
  
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersusSearchModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
          child: TextFormField(
            controller: _model.textController,
            focusNode: _model.textFieldFocusNode,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              labelText: '대항전 검색',
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF606A85),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF606A85),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF6F61EF),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF5963),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF5963),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding:
                  EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
              suffixIcon: Icon(
                Icons.search_rounded,
                color: Color(0xFF606A85),
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
            minLines: null,
            cursorColor: Color(0xFF6F61EF),
            validator: _model.textControllerValidator.asValidator(context),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 12.0,
                  children: List<Widget>.generate(options.length, (index) {
                    return ChoiceChip(
                  label: Text(options[index]),
                  selected: widget.selectedIndex == index, // Set the selected state based on the received index
                  onSelected: (selected) {
                    if (selected) {
                      widget.setStatusCode(index);
                    }
                  },
                );
                  }),
                ),
              ),
            ].addToStart(SizedBox(width: 16.0)).addToEnd(SizedBox(width: 16.0)),
          ),
        ),
      ],
    );
  }
}
