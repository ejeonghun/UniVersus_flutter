import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../class/auth/kakaoauth.dart';
import 'AdditionalInfo_Model.dart';
export 'AdditionalInfo_Model.dart';

class AdditionalInfoWidget extends StatefulWidget {
  final KakaoAuthDto dto;
  final Map<String, dynamic>? emailData;

  const AdditionalInfoWidget({Key? key, required this.dto, this.emailData}) : super(key: key); // 카카오 회원가입 생성자

  @override
  State<AdditionalInfoWidget> createState() => _AdditionalInfoWidgetState();
}

class _AdditionalInfoWidgetState extends State<AdditionalInfoWidget> {
  late AdditionalInfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdditionalInfoModel());

    _model.fullNameController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();
    _model.fullNameFocusNode!.addListener(() => setState(() {}));
    _model.nickNameController ??= TextEditingController();
    _model.nickNameFocusNode ??= FocusNode();
    _model.nickNameFocusNode!.addListener(() => setState(() {}));
    _model.phoneNumberController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();
    _model.phoneNumberFocusNode!.addListener(() => setState(() {}));
    _model.descriptionController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();
    _model.descriptionFocusNode!.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    if (widget.dto != null) { // 초기값 설정 부분
      _model.email = widget.dto?.email; // 카카오 이메일
      _model.password = widget.dto?.kakaoIdx.toString(); // 카카오 IDx

      _model.fullNameController!.text = widget.dto?.name ?? '';
      _model.phoneNumberController!.text = widget.dto?.phoneNumber ?? '';
      _model.descriptionController!.text = widget.dto?.email ?? '';
    } else {
      _model.email = widget.emailData?['email']; // 이메일
      _model.password = widget.emailData?['password']; // 비밀번호
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '추가 정보',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Color(0xFF15161E),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '추가 정보를 입력하여주세요.',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Outfit',
                  color: Color(0xFF606A85),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ].divide(SizedBox(height: 4)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, -1),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 770,
                            ),
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _model.fullNameController,
                                    focusNode: _model.fullNameFocusNode,
                                    autofocus: true,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: '이름',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor:
                                      (_model.fullNameFocusNode?.hasFocus ??
                                          false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16, 20, 16, 20),
                                    ),
                                    style:
                                    FlutterFlowTheme.of(context).bodyLarge,
                                    cursorColor: Color(0xFF6F61EF),
                                    validator: _model
                                        .fullNameControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model.nickNameController,
                                    focusNode: _model.nickNameFocusNode,
                                    autofocus: true,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: '닉네임',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor:
                                      (_model.nickNameFocusNode?.hasFocus ??
                                          false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16, 20, 16, 20),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorColor: Color(0xFF6F61EF),
                                    validator: _model.nickNameControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model.phoneNumberController,
                                    focusNode: _model.phoneNumberFocusNode,
                                    autofocus: true,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: '휴대폰 번호 ',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: (_model.phoneNumberFocusNode
                                          ?.hasFocus ??
                                          false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16, 20, 16, 20),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorColor: Color(0xFF6F61EF),
                                    validator: _model
                                        .phoneNumberControllerValidator
                                        .asValidator(context),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        await showModalBottomSheet<bool>(
                                            context: context,
                                            builder: (context) {
                                              return ScrollConfiguration(
                                                behavior:
                                                const MaterialScrollBehavior()
                                                    .copyWith(
                                                  dragDevices: {
                                                    PointerDeviceKind.mouse,
                                                    PointerDeviceKind.touch,
                                                    PointerDeviceKind.stylus,
                                                    PointerDeviceKind.unknown
                                                  },
                                                ),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      3,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                    CupertinoDatePickerMode
                                                        .date,
                                                    minimumDate: DateTime(1900),
                                                    initialDateTime:
                                                    getCurrentTimestamp,
                                                    maximumDate:
                                                    getCurrentTimestamp,
                                                    use24hFormat: false,
                                                    onDateTimeChanged:
                                                        (newDateTime) =>
                                                        safeSetState(() {
                                                          _model.datePicked =
                                                              newDateTime;
                                                        }),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      text: '생년월일 선택',
                                      icon: FaIcon(
                                        FontAwesomeIcons.birthdayCake,
                                        size: 18,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 44,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '관심 지역 ',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF606A85),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  FlutterFlowDropDown( // 추후 관심지역 변경 예정
                                    // 컨트롤러 
                                    options: [
                                      'Insurance Provider 1',
                                      'Insurance Provider 2',
                                      'Insurance Provider 3'
                                    ],
                                    onChanged: (val) => setState(() => _model.dropDownValue = val),
                                    width: double.infinity,
                                    height: 52,
                                    textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF606A85),
                                      size: 24,
                                    ),
                                    fillColor: Colors.white,
                                    elevation: 2,
                                    borderColor: Color(0xFFE5E7EB),
                                    borderWidth: 2,
                                    borderRadius: 12,
                                    margin: EdgeInsetsDirectional.fromSTEB(12, 4, 8, 4),
                                    hidesUnderline: true,
                                  ),
                                  Text(
                                    '성별',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF606A85),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  FlutterFlowChoiceChips(
                                    options: [
                                      ChipData('여성', Icons.woman),
                                      ChipData('남성', Icons.man)
                                    ],
                                    onChanged: (val) => setState(() => _model
                                        .choiceChipsValue = val?.firstOrNull),
                                    selectedChipStyle: ChipStyle(
                                      backgroundColor: Color(0x4C39D2C0),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF15161E),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      iconColor: Color(0xFF15161E),
                                      iconSize: 18,
                                      elevation: 0,
                                      borderColor: Color(0xFF39D2C0),
                                      borderWidth: 2,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    unselectedChipStyle: ChipStyle(
                                      backgroundColor: Color(0xFFF1F4F8),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF606A85),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      iconColor: Color(0xFF606A85),
                                      iconSize: 18,
                                      elevation: 0,
                                      borderColor: Color(0xFFE5E7EB),
                                      borderWidth: 2,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    chipSpacing: 12,
                                    rowSpacing: 12,
                                    multiselect: false,
                                    alignment: WrapAlignment.start,
                                    controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                          [],
                                        ),
                                    // wrapped: true,
                                  ),
                                  TextFormField(
                                    controller: _model.descriptionController,
                                    focusNode: _model.descriptionFocusNode,
                                    autofocus: true,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText:
                                      'Please describe your symptoms...',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      alignLabelWithHint: true,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: (_model.descriptionFocusNode
                                          ?.hasFocus ??
                                          false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 9,
                                    minLines: 5,
                                    cursorColor: Color(0xFF6F61EF),
                                    validator: _model
                                        .descriptionControllerValidator
                                        .asValidator(context),
                                  ),
                                ]
                                    .divide(SizedBox(height: 12))
                                    .addToEnd(SizedBox(height: 32)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 770,
                  ),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_model.formKey.currentState == null ||
                            !_model.formKey.currentState!.validate()) {
                          return;
                        }
                        _model.inputTest();
                      },
                      text: '가입 완료',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFF6F61EF),
                        textStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Figtree',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
