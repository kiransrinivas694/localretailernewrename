// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:b2c/screens/splash_screen.dart';
// import 'package:b2c/utils/font_utils.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: FontsUtils.poppinsRegular),
//       home: SplashScreen(),
//     );
//   }
// }

import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/dependency_injection_new.dart';
import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/helper/firebase_gettoken_backup_new.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:b2c/screens/no_internet_screen_new.dart';
import 'package:b2c/screens/splash_screen_new.dart';
import 'package:b2c/service/notification_service_new.dart';
import 'package:b2c/service/remote_config_service_new.dart';
import 'package:b2c/service/sse_service_controller_new.dart';
import 'package:b2c/utils/firebase_messaging_service_new.dart';
import 'package:b2c/utils/font_utils_new.dart';
import 'package:b2c/utils/notification_navigation_utils_new.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;
// ----------- vaishnav ---------------
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// ----------- vaishnav ---------------
// import 'controllers/GetHelperController.dart';

bool volumeMute = true;

final GetStorage getPreference = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterBranchSdk.init(
    disableTracking: true,
    // useTestKey: false,
  );
  // await FlutterBranchSdk.init();
  // FlutterBranchSdk.validateSDKIntegration();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Set status bar color to black
      statusBarIconBrightness:
          Brightness.light, // Set icons to white on Android
      statusBarBrightness: Brightness.dark, // Set icons to white on iOS
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Get.put<GlobalMainController>(GlobalMainController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(CartLabtestController(), permanent: true);
  Get.put(SampleCollectionController(), permanent: true);

  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService.instance.initializeNotification();
  await RemoteConfigService.setupRemoteConfig();
  RemoteConfigService.getConfigValue();

  if (!isNotEmptyString(getFcmToken())) {
    // FirebaseNotificationService.firebaseMessaging.getToken().then(
    getFirebaseToken().then(
      (String? token) {
        assert(token != null);
        print("FCM-TOKEN $token");
        setFcmToken(token!);
      },
    );
  }

  /// 1/5: define a navigator key
  final navigatorKey = GlobalKey<NavigatorState>();

  /// 2/5: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  /// // ----------- vaishnav ---------------
  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService()
  //       .useSystemCallingUI([ZegoUIKitSignalingPlugin()]);
  //   // runApp(const MyApp());
  // });
  // ----------- vaishnav ---------------

  Widget startScreen = home.HomeScreen();

  startScreen = await manageInitialMessage();

  Get.put(SSEService());

  runApp(MyApp(
    navigatorKey: navigatorKey,
    inititalScreen: startScreen,
    isRedirectNeed: startScreen.runtimeType != home.HomeScreen,
  ));
  DependencyInjection.init();
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: FontsUtils.poppinsRegular),
//       home: SplashScreen(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget inititalScreen;
  final bool isRedirectNeed;

  const MyApp({
    required this.navigatorKey,
    required this.inititalScreen,
    required this.isRedirectNeed,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final cltController = Get.put(CartLabtestController());
    // cltController.getLucidCartData();
    cltController.getDiagnosticCartData(homeCollection: "0");
    cltController.getDiagnosticCartData(homeCollection: "1");

    // listenToSSE();

    // if (currentUser.id.isNotEmpty) {
    //   onUserLogin();
    // }
  }

  void listenToSSE() {
    print('listen to sse called');
    SSEClient.subscribeToSSE(
      url: 'http://45.127.101.159:9090/sse/stream',
      header: {}, // Add headers if required
    ).listen((SSEModel event) {
      print(
          "print incoming messages event -> ${event}  , event -> data ${event.data} , event -> ${event.id}");
      if (event.data != null) {
        setState(() {
          // messages.add(event.data!);
        });

        // Show local notification when message arrives
        NotificationService.instance.showNotification(event.data!);
      }
    }, onError: (error) {
      print("SSE Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (BuildContext context, Orientation orientation, screenType) {
      return GetMaterialApp(
        // routes: routes,
        // initialRoute: currentUser.id.isEmpty ? PageRouteNames.login : PageRouteNames.home,
        // theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),

        /// 3/5: register the navigator key to MaterialApp
        navigatorKey: widget.navigatorKey,
        debugShowCheckedModeBanner: false,

        navigatorObservers: [BotToastNavigatorObserver()],
        getPages: [
          GetPage(name: '/nointernet', page: () => NoInternetScreen()),
        ],
        theme: ThemeData(fontFamily: FontsUtils.poppinsRegular),
        // home: SplashScreen(),
        home: home.HomeScreen(
          inititalScreen:
              widget.isRedirectNeed ? widget.inititalScreen : SizedBox(),
          isRedirectNeed: widget.isRedirectNeed,
        ),
        //home: DashboardScreen(
        //   isNeedToPlayVideo: true,
        // ),

        builder: (BuildContext context, Widget? child) {
          child = BotToastInit()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
              boldText: false,
            ),
            child: Stack(
              children: [
                child!,

                /// support minimizing
                /// // ----------- vaishnav ---------------
                // ZegoUIKitPrebuiltCallMiniOverlayPage(
                //   contextQuery: () {
                //     return widget.navigatorKey.currentState!.context;
                //   },
                // ),
                // ----------- vaishnav ---------------
              ],
            ),
          );
        },
      );
    });
  }
}
