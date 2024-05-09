import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universus/chat/test.dart';
import 'package:universus/club/ClubList_Model.dart';
import 'package:universus/club/ClubList_Widget.dart';
import 'package:universus/main/Components/clubElement_Widget.dart';
import 'package:universus/main/Components/clubelement_widget.dart';
import 'package:universus/permissonManage.dart';
import 'package:universus/permissonManage.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:universus/Community/Community_Widget.dart';
import 'package:universus/Community/Post_Widget.dart';
import 'package:universus/Community/Write_Widget.dart';
import 'package:universus/Search/SearchResult_Widget.dart';
import 'package:universus/Search/Search_Widget.dart';
import 'package:universus/auth/AdditionalInfo_Widget.dart';
import 'package:universus/chat/ChatListWidget.dart';

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: null); // ios 설정은 안함
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Universus',
    '알림',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 1번코드
  KakaoSdk.init(
      nativeAppKey: 'c42d4f7154f511f29ae715dc77565878',
      javaScriptAppKey: '240cc5ab531ff61f42c8e0a1723a4f96');
  await dotenv.load(fileName: ".env"); // 2번코드
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var messageTitle = "";
  var messageBody = "";

  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
  }

  late Future<bool> _loginInfo;

  @override
  void initState() {
    getMyDeviceToken();
    initializeNotification();
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
        );

        setState(() {
          messageBody = message.notification!.body!;
          messageTitle = message.notification!.title!;
          print("Foreground 메시지 수신: $messageBody, $messageTitle");
        });
      }
    });
    super.initState();
    _loginInfo = checkLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MyApp.themeNotifier,
        builder: (context, ThemeMode value, child) {
          return MaterialApp(
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
              '/chat/main': (context) => ChatScreen(),
              '/main1': (context) => MainWidget(),
              '/versusList': (context) => VersusListWidget(),
              '/versusCreate': (context) => versusCreateWidget(),
              '/Search': (context) => SearchWidget(),
              '/SearchResult': (context) => SearchResultWidget(),
              '/Community': (context) => CommunityWidget(),
              '/Post': (context) => PostWidget(univBoardId: 1),
              '/Write': (context) => WriteWidget(),
              '/ClubMain': (context) => ClubMainWidget(clubId: 1),
              '/MyClub': (context) => MyClubWidget(),
              '/clubList': (context) => ClubListWidget(),
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
