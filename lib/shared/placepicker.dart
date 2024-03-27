import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Updated permission library import

class PlacePickerScreen extends StatefulWidget {
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  PickResult? selectedPlace;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request location permission
    final locationPermissionStatus =
        await Permission.location.request(); // Updated permission request
    if (!locationPermissionStatus.isGranted) {
      debugPrint("위치 권한이 없습니다.");
      // Show a nice alert dialog for location permission
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("위치 권한이 필요합니다"),
            content: Text("위치 권한을 허용하지 않으면 서비스를 사용할 수 없습니다."),
            actions: [
              TextButton(
                // Updated button type
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: 'AIzaSyD4-bLyOjZB1wZj7lnYXOd9fzJYOiaHoUI',
      autocompleteLanguage: 'ko', // 검색어 자동완성 언어 설정
      initialMapType: MapType.terrain, // 초기 맵 타입 설정
      initialPosition: LatLng(37.5518911, 126.9917937), // 초기 위치 -> 서울
      useCurrentLocation: true, // 현재 위치 사용 여부
      onPlacePicked: (result) {
        selectedPlace = result; // 선택된 장소 정보의 배열 저장
        if (selectedPlace != null) {
          print('Selected place: ${selectedPlace?.formattedAddress}');
          print('Selected place lat: ${selectedPlace?.geometry?.location.lat}');
          print('Selected place lng: ${selectedPlace?.geometry?.location.lng}');
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
  }
}
