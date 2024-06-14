import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universus/shared/CustomSnackbar.dart';
import 'package:universus/shared/placepicker.dart';

import 'Write_Model.dart';
export 'Write_Model.dart';

class WriteWidget extends StatefulWidget {
  const WriteWidget({super.key});

  @override
  State<WriteWidget> createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
  late WriteModel _model;
  bool showLocationButton = false;
  bool showSportDropdown = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WriteModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<bool> checkPermission() async {
    // location 권한 체크 부분
    var status = await Permission.location.status;
    var status2 = await Permission.locationWhenInUse.status;
    var status3 = await Permission.locationAlways.status;
    var statusIos = await Permission.locationWhenInUse.serviceStatus;
    var statusIos2 = await Permission.location.request();
    LocationPermission permission = await Geolocator.checkPermission();
    if (status.isGranted ||
        status2.isGranted ||
        status3.isGranted ||
        statusIos2.isGranted ||
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      debugPrint("권한 허용되어 있음 ");
      return true;
    } else {
      debugPrint("권한 허용 필요");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            '글쓰기',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22,
                  letterSpacing: 0,
                ),
          ),
          actions: [
            FFButtonWidget(
              onPressed: () async {
                if (await _model.writePost() == true) {
                  debugPrint("성공");
                  CustomSnackbar.success(
                      context, "글쓰기", "글이 성공적으로 작성되었습니다.", 2);
                  Navigator.of(context).pop();
                } else {
                  debugPrint("실패");
                  CustomSnackbar.error(context, "글쓰기", "글 작성에 실패하였습니다.", 2);
                }
              },
              text: '작성',
              options: FFButtonOptions(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: Color(0x004B39EF),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontSize: 20,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                elevation: 0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: DropdownButton<String>(
                        value: _model.dropDownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            _model.dropDownValue = newValue;
                            showLocationButton = newValue == '모집';
                            showSportDropdown = newValue == '모집';
                          });
                        },
                        items: ['자유', '모집', '정보']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('카테고리'),
                      ),
                    ),
                    if (showSportDropdown)
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            value: _model.sportDropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                _model.sportDropdownValue = newValue;
                              });
                            },
                            items: [
                              '축구',
                              '농구',
                              '야구',
                              '볼링',
                              '풋살',
                              '탁구',
                              '당구/포켓볼',
                              '배드민턴',
                              'E-sport'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text('종목 선택'),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              unselectedWidgetColor: Color(0xCCA5A5A5),
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue ??= false,
                              onChanged: (newValue) async {
                                setState(
                                    () => _model.checkboxValue = newValue!);
                              },
                              activeColor:
                                  FlutterFlowTheme.of(context).tertiary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Text(
                            '익명',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xCCA5A5A5),
                                  fontSize: 15,
                                  letterSpacing: 0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                    hintText: '제목',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xCCA5A5A5),
                              letterSpacing: 0,
                            ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                  minLines: null,
                  validator:
                      _model.textController1Validator.asValidator(context),
                ),
              ),
              Divider(
                thickness: 1,
                color: Color(0xCCA5A5A5),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                    hintText: '내용',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xCCA5A5A5),
                              letterSpacing: 0,
                            ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                  maxLines: 15,
                  minLines: null,
                  validator:
                      _model.textController2Validator.asValidator(context),
                ),
              ),
              if (_model.imageFile != null)
                kIsWeb
                    ? // 만약 웹이면
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              // 네트워크 이미지를 가져옵니다.
                              _model.imageFile!.path,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            )),
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                          child: Image.file(
                            // 웹이 아니면 파일 이미지를 가져옵니다.
                            File(_model.imageFile!.path),
                            fit: BoxFit.cover,
                            width: 110,
                            height: 110,
                          ),
                        ),
                      ),
              Align(
                //이미지 업로드
                alignment: AlignmentDirectional(-1, 1),
                child: FlutterFlowIconButton(
                  borderColor: Color(0x004B39EF),
                  borderRadius: 20,
                  borderWidth: 1,
                  buttonSize: 55,
                  fillColor: Color(0x004B39EF),
                  icon: Icon(
                    Icons.camera_alt,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 40,
                  ),
                  onPressed: () async {
                    if (await _model.pickImage() == true) {
                      debugPrint("이미지 선택 성공");
                      setState(() {}); // UI 재 랜더링
                    }
                  },
                ),
              ),
              Divider(
                thickness: 1,
                color: Color(0xCCA5A5A5),
              ),
              if (showLocationButton) // 위치 선택 버튼은 모집일 때만 표시
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (kIsWeb) {
                            // 웹일 때
                            CustomSnackbar.error(
                                context, "위치 허용", "웹에서는 지원하지 않습니다.", 2);
                            return;
                          }
                          if (await checkPermission() == true) {
                            // 권한이 허용되어 있을 때 실행됨
                            // PlacePickerScreen을 표시하고 결과를 기다립니다.
                            PickResult? selectedPlace = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacePickerScreen()),
                            );
                            // 결과를 출력합니다.
                            if (selectedPlace != null) {
                              print(
                                  'Selected place: ${selectedPlace.formattedAddress}');
                              print(
                                  'Selected place lat: ${selectedPlace.geometry?.location.lat}');
                              print(
                                  'Selected place lng: ${selectedPlace.geometry?.location.lng}');
                              print(selectedPlace.name);
                              String? placeName = '';
                              if (selectedPlace.name != null) {
                                // 만약 장소명이 있으면
                                placeName = selectedPlace.name; // 장소명 저장
                              } else {
                                placeName =
                                    selectedPlace.formattedAddress; // 장소 주소 저장
                              }
                              print(placeName);
                              _model.lat = selectedPlace.geometry?.location.lat;
                              _model.lng = selectedPlace.geometry?.location.lng;
                              _model.placeName = placeName;
                            }
                            setState(() {}); // UI 리랜더링
                          } else {
                            // 권한이 허용되어 있지 않을 때 실행됨
                            CustomSnackbar.error(
                                context, "위치 허용", "위치를 허용해 주세요", 2);
                            if (await Permission.location.request() ==
                                PermissionStatus.granted) {
                              CustomSnackbar.success(
                                  context, "위치 허용", "위치가 허용 되었습니다.", 2);
                            }
                          }
                        },
                        text: _model.placeName != null
                            ? '${_model.placeName}'
                            : '장소 선택',
                        icon: Icon(
                          Icons.place,
                          size: 20.0,
                        ),
                        options: FFButtonOptions(
                          width: 200.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).tertiary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_model.dropDownValue == '모집')
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await showModalBottomSheet<bool>(
                          context: context,
                          builder: (context) {
                            return ScrollConfiguration(
                              behavior: const MaterialScrollBehavior().copyWith(
                                dragDevices: {
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.stylus,
                                  PointerDeviceKind.unknown
                                },
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  minimumDate: DateTime(2024),
                                  initialDateTime: getCurrentTimestamp,
                                  use24hFormat: false,
                                  onDateTimeChanged: (newDateTime) =>
                                      safeSetState(() {
                                    _model.datePicked = newDateTime;
                                  }),
                                ),
                              ),
                            );
                          });
                    },
                    text: _model.datePicked != null
                        ? '${_model.datePicked!.year}/${_model.datePicked!.month}/${_model.datePicked!.day}'
                        : '날짜 선택',
                    icon: FaIcon(
                      FontAwesomeIcons.calendarAlt,
                      size: 18,
                    ),
                    options: FFButtonOptions(
                      width: 200,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).tertiary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
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
            ],
          ),
        ),
      ),
    );
  }
}
