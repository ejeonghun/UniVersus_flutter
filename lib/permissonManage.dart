import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManage {
  Future<void> requestPermissions(BuildContext context) async {
    bool cameraPermission = await requestCameraPermission(context);
    bool storagePermission = await requestStoragePermission(context);
    bool locationPermission = await requestLocationPermission(context);
    bool notificationPermission = await requestNotificationPermission(context);

    if (!cameraPermission ||
        !storagePermission ||
        !locationPermission ||
        !notificationPermission) {
      // 하나 이상의 권한이 허용되지 않았을 경우, 추가적인 처리를 할 수 있습니다.
    }
  }

  Future<bool> requestCameraPermission(BuildContext context) async {
    // 카메라 권한 요청
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission(BuildContext context) async {
    // 파일 권한 요청
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> requestLocationPermission(BuildContext context) async {
    // 위치 권한 요청
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission(BuildContext context) async {
    // 알림 권한 요청
    PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }
}
