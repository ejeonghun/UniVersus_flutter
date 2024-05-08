import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'versusElement_Widget.dart' show VersusElementWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class VersusElementModel extends FlutterFlowModel<VersusElementWidget> {
  @override
  void initState(BuildContext context) {}

  String getText(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return '진행중';
      case 'RECRUIT':
        return '모집중';
      case 'WAITING':
        return '대기중';
      case 'COMPLETED':
        return '종료';
      default:
        return '';
    }
  }

  Color getColor(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return Colors.yellow;
      case 'RECRUIT':
        return Colors.green;
      case 'WAITING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  void dispose() {}
}
