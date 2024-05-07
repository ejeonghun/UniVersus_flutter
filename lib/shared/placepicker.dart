import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Updated permission library import

class PlacePickerScreen extends StatefulWidget {
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  PickResult? selectedPlace;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    // getGeoData();
    // requestPermissions();
  }

  Future<void> checkPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("위치 권한이 필요합니다"),
            content: Text("위치 권한을 허용하지 않으면 서비스를 사용할 수 없습니다."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return Future.error('permissions are denied');
    }
  }
}

Future<void> getGeoData() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("위치 권한이 필요합니다"),
            content: Text("위치 권한을 허용하지 않으면 서비스를 사용할 수 없습니다."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return Future.error('permissions are denied');
    }
  }

  Position position = await Geolocator.getCurrentPosition();
  latitude = position.latitude;
  longitude = position.longitude;
}

  @override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: Future.wait([checkPermission(), getGeoData()]), // checkPermission으로 수정
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return PlacePicker(
          apiKey: 'AIzaSyD4-bLyOjZB1wZj7lnYXOd9fzJYOiaHoUI',
          autocompleteLanguage: 'ko', // 검색어 자동완성 언어 설정
          initialMapType: MapType.terrain, // 초기 맵 타입 설정
          initialPosition: LatLng(latitude ??= 37.5518911, longitude!), // 초기 위치 -> 서울
          useCurrentLocation: true, // 현재 위치 사용 여부
          onPlacePicked: (result) {
            selectedPlace = result; // 선택된 장소 정보의 배열 저장
            if (selectedPlace != null) {
              print('Selected place: ${selectedPlace?.formattedAddress}');
              print(
                  'Selected place lat: ${selectedPlace?.geometry?.location.lat}');
              print(
                  'Selected place lng: ${selectedPlace?.geometry?.location.lng}');
              print(selectedPlace?.name);
              String? placeName = '';
              if (selectedPlace?.name != null) {
                // 만약 장소명이 있으면
                placeName = selectedPlace!.name; // 장소명 저장
              } else {
                placeName = selectedPlace!.formattedAddress; // 장소 주소 저장
              }
              print(placeName);
            }
            // print('Selected place: ${selectedPlace?.placeId}');
            // print('Selected place lat: ${selectedPlace?.geometry?.location.lat}');
            // print('Selected place lng: ${selectedPlace?.geometry?.location.lng}');
            Navigator.of(context).pop(selectedPlace); // 이전 페이지로 선택된 장소 정보 전달
          },
        );
      } else {
        return FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      }
    },
  );
}
