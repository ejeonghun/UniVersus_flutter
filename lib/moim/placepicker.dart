import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_place_picker_mb/providers/place_provider.dart';
import 'package:google_maps_place_picker_mb/providers/search_provider.dart';

class PlacePickerScreen extends StatefulWidget {
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

// 해당 파일은 위치를 선택하는 위젯을 구현한 파일

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  PickResult? selectedPlace;

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
        // print('Selected place: ${selectedPlace?.placeId}');
        // print('Selected place lat: ${selectedPlace?.geometry?.location.lat}');
        // print('Selected place lng: ${selectedPlace?.geometry?.location.lng}');
        Navigator.of(context).pop(selectedPlace); // 이전 페이지로 선택된 장소 정보 전달
      },
    );
  }
}
