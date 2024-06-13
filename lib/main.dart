import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universus/chat/chats.dart';
import 'package:universus/club/ClubList_Model.dart';
import 'package:universus/club/ClubList_Widget.dart';
import 'package:universus/club/ClubPostList_Widget.dart';
import 'package:universus/handleNotificationClick.dart';
import 'package:universus/main/Components/clubElement_Widget.dart';
import 'package:universus/main/Components/clubelement_widget.dart';
import 'package:universus/notice/notice.dart';
import 'package:universus/permissonManage.dart';
import 'package:universus/permissonManage.dart';
import 'package:universus/shared/paymentResult.dart';
import 'package:universus/versus/versusDetail_Widget.dart';
import 'package:universus/winloseRecord/record.dart';
import 'package:universus/winloseRecord/record_model.dart';
import 'package:universus/versus/versusCheck_Widget.dart';

import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:universus/Community/Community_Widget.dart';
import 'package:universus/Community/Post_Widget.dart';
import 'package:universus/Community/Write_Widget.dart';
import 'package:universus/Search/SearchResult_Widget.dart';
import 'package:universus/Search/Search_Widget.dart';
import 'package:universus/auth/AdditionalInfo_Widget.dart';
import 'package:universus/ranking/ranking.dart';
import 'package:universus/notice/notice.dart';

import 'package:universus/class/user/user.dart';

// Widget Import
import 'package:universus/auth/Login_Widget.dart';
import 'package:universus/club/ClubMain_Widget.dart';
import 'package:universus/club/CreateClub_Widget.dart';
import 'package:universus/club/MyClub_Widget.dart';
import 'package:universus/club/UpdateClub_Widget.dart';
import 'package:universus/auth/CreateAccount_Widget.dart';
import 'package:universus/auth/PasswordForget_Widget.dart';
import 'package:universus/main/main_Widget.dart';
import 'package:universus/member/profile_Widget.dart';
import 'package:universus/member/updateProfile_Widget.dart';
import 'package:universus/test/testscreen_Widget.dart';
import 'package:universus/auth/tmp/KakaoLogin.dart';
import 'package:universus/shared/placepicker.dart';
import 'package:universus/versus/versusCreate_Widget.dart';
import 'package:universus/versus/versusList_Widget.dart';
import 'package:universus/main/Components/clubElement_Widget.dart';
import 'package:universus/Community/Post_Widget.dart';

import 'package:intl/date_symbol_data_local.dart';

// 백그라운드 FCM 메세지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
  print("target 메세지 처리 ${message.data['target'] ?? '없음'}");
  print("data 메세지 처리 ${message.data['data'] ?? '없음'}");
}

// 알림 init
void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        handleNotificationClick(notificationResponse.payload!);
      }
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'high_importance_channel',
          'high_importance_notification',
          importance: Importance.max,
        ),
      );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); // 네비게이션 키 상태관리

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
      nativeAppKey: 'c42d4f7154f511f29ae715dc77565878',
      javaScriptAppKey: '240cc5ab531ff61f42c8e0a1723a4f96');
  await dotenv.load(fileName: "dotenv"); // .env 파일을 불러옴
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    // 에러 핸들링

    print(details);
    FlutterError.dumpErrorToConsole(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // 에러 핸들링
    print(error);
    print(stack);
    return true;
  };

  // initializeDateFormatting().then((_) => runApp(MyApp()));
  final message = await FirebaseMessaging.instance.getInitialMessage();
  runApp(MyApp(initialMessage: message));
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;

  const MyApp({Key? key, this.initialMessage}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Firebase FCM, Flutter Local Notification 관련 변수
  var messageTitle = "";
  var messageBody = "";
  var messageTarget = "";
  var messageData = "";

  void getMyDeviceToken() async {
    Future<void> requestNotificationPermission(BuildContext context) async {
      if (kIsWeb) {
        // 웹은 권한 요청을 실행하지 않음
      } else {
        // 알림 권한 요청
        PermissionStatus status = await Permission.notification.request();
        if (status.isGranted) {
          final token = await FirebaseMessaging.instance.getToken();
          print("내 디바이스 토큰: $token"); // FCM 토큰
        } else {
          print("알림 권한이 거부되었습니다.");
        }
      }
    }
  }

  late Future<bool> _loginInfo;

  @override
  void initState() {
    super.initState();
    getMyDeviceToken();
    initializeNotification();

    if (widget.initialMessage != null) {
      handleNotificationClick(jsonEncode(widget.initialMessage!.data));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
          payload: jsonEncode(message.data),
        );

        setState(() {
          messageBody = message.notification!.body!;
          messageTitle = message.notification!.title!;
          messageTarget = message.data['target'] ?? '';
          messageData = message.data['data'] ?? '';
          print(
              "Foreground 메시지 수신: $messageBody, $messageTitle, $messageData, $messageTarget");
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(jsonEncode(message.data));
    });

    _loginInfo = checkLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MyApp.themeNotifier,
        builder: (context, ThemeMode value, child) {
          return MaterialApp(
            navigatorKey: navigatorKey, // 네비게이터 상태 관리
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Ownglyph', // 다크모드에 대한 글꼴
            ),
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Ownglyph', // 라이트모드에 대한 글꼴
            ),
            themeMode: value,
            initialRoute: '/',
            routes: {
              '/': (context) => FutureBuilder(
                    future: _loginInfo,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      } else {
                        if (snapshot.data == true) {
                          return TestscreenWidget();
                        } else {
                          return LoginWidget();
                        }
                      }
                    },
                  ),
              '/main': (context) => TestscreenWidget(),
              '/login': (context) => LoginWidget(),
              '/register': (context) => CreateAccountWidget(),
              '/passwordforgot': (context) => PasswordForgetWidget(),
              '/testscreen': (context) => TestscreenWidget(),
              '/testplacepicker': (context) => new PlacePickerScreen(),
              '/createClub': (context) => CreateClubWidget(),
              '/club/update': (context) => UpdateClubWidget(
                  clubId: "9"), // 테스트용 나중에 clubId 파라미터도 같이 전달해야함
              '/profile': (context) => ProfileWidget(),
              '/chat/main': (context) => ChatsPage(),
              '/main1': (context) => MainWidget(),
              '/versusList': (context) => VersusListWidget(),
              '/versusCreate': (context) => versusCreateWidget(),
              '/Search': (context) => SearchWidget(),
              '/SearchResult': (context) => SearchResultWidget(
                    searchQuery: '',
                  ),
              '/Community': (context) => CommunityWidget(),
              '/Post': (context) => PostWidget(univBoardId: 1),
              '/Write': (context) => WriteWidget(),
              '/ClubMain': (context) => ClubMainWidget(clubId: 1),
              '/MyClub': (context) => MyClubWidget(),
              '/clubList': (context) => ClubListWidget(),
              '/result': (context) => PaymentResult(),
              '/ranking': (context) => RankingPage(),
              '/notice': (context) => NoticePage(),
              '/checkversus': (context) => VersusCheckWidget(
                    battleId: 1,
                  ),
              '/morePost': (context) => ClubPostListWidget(
                    clubId: 1,
                    clubName: "테스트",
                  ), // 테스트 용도
            },
          );
        });
  }

  Future<bool> checkLoginInfo() async {
    // 유저 정보 확인 메서드
    await Future.delayed(Duration(seconds: 3)); // Show logo for 3 seconds
    UserData? user = await UserData.getUser();
    return user != null;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoSize = 0.0;
  PermissionManage _permissionManage = PermissionManage();

  @override
  void initState() {
    super.initState();
    _animateLogo();
    _permissionManage.requestPermissions(context); // 권한 요청

    // _requestAllPermissions();
  }

  // void _requestAllPermissions() async {
  //   bool cameraPermission =
  //       await _permissionManage.requestCameraPermission(context);
  //   bool storagePermission =
  //       await _permissionManage.requestStoragePermission(context);
  //   bool locationPermission =
  //       await _permissionManage.requestLocationPermission(context);
  //   bool notificationPermission =
  //       await _permissionManage.requestNotificationPermission(context);

  //   if (!cameraPermission ||
  //       !storagePermission ||
  //       !locationPermission ||
  //       !notificationPermission) {
  //     // 하나 이상의 권한이 허용되지 않았을 경우, 추가적인 처리를 할 수 있습니다.
  //   }
  // }

  void _animateLogo() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _logoSize = 250;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              width: _logoSize,
              height: _logoSize,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(height: 20),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text('대학교끼리 경쟁을 해보세요!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
