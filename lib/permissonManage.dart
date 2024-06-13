import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart' as universal_io;
import 'package:flutter/foundation.dart' show kIsWeb;

class PermissionManage {
  Future<void> requestPermissions(BuildContext context) async {
    if (kIsWeb) {
      // Handle permissions for the web, if necessary.
      // Typically, browser permissions are handled differently.
      return;
    }

    bool cameraPermission = await requestCameraPermission(context);
    bool storagePermission = await requestStoragePermission(context);
    bool locationPermission = await requestLocationPermission(context);
    // bool notificationPermission = await requestNotificationPermission(context);

    if (!cameraPermission || !storagePermission || !locationPermission) {
      // !notificationPermission
      // 하나 이상의 권한이 허용되지 않았을 경우, 추가적인 처리를 할 수 있습니다.
    }
  }

  Future<bool> requestCameraPermission(BuildContext context) async {
    if (kIsWeb) {
      // 웹은 기본적으로 권한이 허용되어있다고 가정
      return true;
    } else {
      // 카메라 권한 요청
      PermissionStatus status = await Permission.camera.request();
      return status.isGranted;
    }
  }

  Future<bool> requestStoragePermission(BuildContext context) async {
    if (kIsWeb) {
      return true; // 웹은 기본적으로 권한이 허용되어있다고 가정
    } else {
      // 파일 권한 요청
      PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<bool> requestLocationPermission(BuildContext context) async {
    if (kIsWeb) {
      // 웹은 기본적으로 권한이 허용되어있다고 가정
      return true;
    } else {
      // 위치 권한 요청
      PermissionStatus status = await Permission.location.request();
      return status.isGranted;
    }
  }

  // Future<bool> requestNotificationPermission(BuildContext context) async {
  //   if (kIsWeb) {
  //     // Handle web or other platforms
  //     return true; // Assume granted for the web or handle differently
  //   } else {
  //     // 알림 권한 요청
  //     PermissionStatus status = await Permission.notification.request();
  //     return status.isGranted;
  //   }
  // }
}
