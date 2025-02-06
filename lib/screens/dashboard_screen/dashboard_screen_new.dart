import 'dart:developer';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/components/video_dialog_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/dashboard_controller_new.dart';
import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/helper/firebase_gettoken_backup_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/bottom_tap_bar_screen_new.dart';
import 'package:b2c/service/remote_config_service_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:b2c/service/sse_service_controller_new.dart';
import 'package:b2c/utils/shar_preferences_new.dart' as b2c_ref;
import 'package:ntp/ntp.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart' as store_app_b2b;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller.dart';
import 'package:store_app_b2b/controllers/confirm_order_controller.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_screen.dart';
import 'package:store_app_b2b/screens/confirm_orders/confirm_orders_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:store_app_b2b/widget/app_html_text.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart' as home;
import 'package:store_app_b2b/widget/dotted_seperator.dart';
import 'package:dotted_line/dotted_line.dart';

class DashboardScreen extends StatefulWidget {
  final bool gotoHomeScreen;
  final bool gotoQuickDeliveryScreen;
  final bool isNeedToPlayVideo;

  const DashboardScreen(
      {super.key,
      this.gotoHomeScreen = false,
      this.isNeedToPlayVideo = false,
      this.gotoQuickDeliveryScreen = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String storeName = '';
  String drugExpiryDate = "";
  String drugExpiringDays = "";

  // ConfirmOrderController? confirmOrderController;
  // PaymentController? paymentController;

  @override
  void initState() {
    _initializeData();
    // RemoteConfigService.getUpdateConfigValue(mounted, context);
    // print(
    //     "this is called withpout waiting for the finish of getupdateconfig value function");
    // getStoreName();
    // getLogin();
    // getLogins(); //this function is previously called in splash screen...since we are getting two splashes one is by us and other is by default...so i moved this into dashboard file (here) and not calling our splash screen
    // if (widget.gotoHomeScreen) {
    //   Future.delayed(
    //     const Duration(milliseconds: 400),
    //     () {
    //       Get.to(() => const home.HomeScreen());
    //       if (widget.gotoQuickDeliveryScreen) {
    //         Get.to(const QuickDeliveryScreen(tabIndex: 1));
    //       }
    //     },
    //   );
    // }

    super.initState();
  }

  Future<void> _initializeData() async {
    await RemoteConfigService.getUpdateConfigValue(mounted, context);
    print(
        "this is called withpout waiting for the finish of getupdateconfig value function");
    getStoreName();
    getLogin();
    getLogins();

    if (!widget.gotoHomeScreen) _initPreferences();

    // setState(() {
    //   confirmOrderController = Get.put(ConfirmOrderController());

    //   paymentController = Get.put(PaymentController());
    // });

    //this function is previously called in splash screen...since we are getting two splashes one is by us and other is by default...so i moved this into dashboard file (here) and not calling our splash screen
    if (widget.gotoHomeScreen) {
      Future.delayed(
        const Duration(milliseconds: 400),
        () {
          Get.to(() => const home.HomeScreen());
          if (widget.gotoQuickDeliveryScreen) {
            Get.to(const QuickDeliveryScreen(tabIndex: 1));
          }
        },
      );
    }
  }

  Future<void> _initPreferences() async {
    String videoWatchedDate =
        await SharPreferences.getString(SharPreferences.videoWatchedDate) ?? "";
    int videoWatchedCount =
        await SharPreferences.getInt(SharPreferences.videoWatchedCount) ?? 0;

    DateTime today = DateTime.now();
    String formattedTodayDate = DateFormat('dd/MM/yyyy').format(today);

    print("printing video rel videoWatchedDate -> $videoWatchedDate");
    print("printing video rel videoWatchedCount - $videoWatchedCount");
    print("printing video rel formattedTodayDate - $formattedTodayDate");

    bool isSkippable = false;

    GlobalMainController gmController = Get.find<GlobalMainController>();

    if (formattedTodayDate != videoWatchedDate &&
        isLogin &&
        widget.isNeedToPlayVideo &&
        gmController.isNeedToShowPaymentVideoPopup) {
      DateTime today = await NTP.now();
      String formattedTodayDate = DateFormat('dd/MM/yyyy').format(today);

      await SharPreferences.setString(
          SharPreferences.videoWatchedDate, formattedTodayDate);
      await SharPreferences.setInt(SharPreferences.videoWatchedCount, 0);
      isSkippable = true;
    } else {
      if (videoWatchedCount > 0) {
        isSkippable = false;
      }
    }

    if (isLogin &&
        widget.isNeedToPlayVideo &&
        gmController.isNeedToShowPaymentVideoPopup) {
      await SharPreferences.setInt(SharPreferences.videoWatchedCount, 1);
      await SharPreferences.setString(
          SharPreferences.videoWatchedDate, formattedTodayDate);
      Get.dialog(
        VideoDialog(
          isSkippable: !isSkippable,
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  void dispose() {
    print("dispose in dashbaord screen is called");
    Get.delete<ConfirmOrderController>();
    Get.delete<PaymentController>();
    super.dispose();
  }

  ConfirmOrderController confirmOrderController =
      Get.put(ConfirmOrderController());

  PaymentController paymentController = Get.put(PaymentController());

  var isLogin = false;

  Future<dynamic> getLogins() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    print(isLogin);

    GetHelperController.token.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.token) ??
        '';
    GetHelperController.storeID.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        '';
    // await FirebaseMessaging.instance.getToken().then((token) {
    //   PreferencesHelper()
    //       .setPreferencesStringData(PreferencesHelper.deviceToken, token ?? "");
    //   print("device-token $token");
    // });

    await getFirebaseToken().then((token) {
      PreferencesHelper()
          .setPreferencesStringData(PreferencesHelper.deviceToken, token ?? "");
      print("device-token $token");
    });

    // Future.delayed(
    //   const Duration(seconds: 3),
    //   () {
    //     if (GetHelperController.token.value.isNotEmpty) {
    //       // ----------- vaishnav ---------------
    //       // Future.delayed(const Duration(milliseconds: 500)).then((value) => onUserLogin());
    //       // ----------- vaishnav ---------------
    //     }
    //     print(">>>>>>>>>>>>>>>>>>>>$isLogin");
    //     Get.offAll(() => const DashboardScreen());
    //     // Get.offAll(
    //     //   () => isLogin
    //     //       ? const DashboardScreen()
    //     //       : /*kDebugMode
    //     //           ? LoginScreen()
    //     //           : */
    //     //       LoginScreen(),
    //     // );
    //   },
    // );
  }

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
  }

  Future<void> getStoreName() async {
    storeName =
        await SharPreferences.getString(SharPreferences.storeName) ?? '';
    drugExpiryDate =
        await SharPreferences.getString(SharPreferences.drugLicenseExpiry) ??
            "";

    if (drugExpiryDate != "") {
      drugExpiryDate = parseDateString(drugExpiryDate);
      DateTime date = parseDateStringToDateTime(drugExpiryDate);
      print("daysBetween printing date -> ${date}");
      DateTime currentDate = DateTime.now();
      drugExpiringDays = daysBetween(date, currentDate).toString();
    }
    setState(() {});
  }

  String parseDateString(String dateString) {
    String cleanedDateString = dateString.replaceAll(RegExp(r'[-\/]'), ' ');

    List<String> dateParts = cleanedDateString.split(' ');

    return "${dateParts[2]}-${int.parse(dateParts[1])}-${int.parse(dateParts[0])}";
  }

  DateTime parseDateStringToDateTime(String dateString) {
    String cleanedDateString = dateString.replaceAll(RegExp(r'[-\/]'), ' ');

    List<String> dateParts = cleanedDateString.split(' ');
    print("daysBetween printing dateParts -> ${dateParts}");
    print(
        "daysBetween printing return date -> ${DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]))}");

    return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  int calculateDifferenceInDays(DateTime date) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in days
    Duration difference = date.difference(currentDate);

    // Return the difference in days
    return difference.inDays;
  }

  int daysBetween(DateTime to, DateTime from) {
    print("daysBetween is called");
    print(
        "daysBetween from year , month , day -> ${from.year} , ${from.month} ${from.day}");
    print(
        "daysBetween to year , month , day -> ${to.year} , ${to.month} ${to.day}");
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    log('Current screen --> $runtimeType');
    print(
        "printing isbuyclick loading ---> ${confirmOrderController.isDashboardBuyClickLoading}");

    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorsConst.bgColor,
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2F394B),
                    Color(0xff090F1A),
                  ],
                ),
              ),
            ),
            title: !isLogin
                ? const SizedBox()
                : AppText(
                    'Hello...! $storeName',
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
            actions: [
              !isLogin
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        String storedUserVersion =
                            await store_app_b2b.SharPreferences.getString(
                                    store_app_b2b
                                        .SharPreferences.versionNumber) ??
                                "";

                        String videoWatchedDate =
                            await SharPreferences.getString(
                                    SharPreferences.videoWatchedDate) ??
                                "";
                        int videoWatchedCount = await SharPreferences.getInt(
                                SharPreferences.videoWatchedCount) ??
                            0;

                        await SharPreferences.clearSharPreference();
                        await b2c_ref.SharPreferences.clearSharPreference();
                        await PreferencesHelper().clearPreferenceData();

                        await SharPreferences.setString(
                            SharPreferences.videoWatchedDate, videoWatchedDate);
                        await SharPreferences.setInt(
                            SharPreferences.videoWatchedCount,
                            videoWatchedCount);

                        await store_app_b2b.SharPreferences.setString(
                            store_app_b2b.SharPreferences.versionNumber,
                            storedUserVersion);

                        SSEService sseController = Get.put(SSEService());
                        sseController.disconnectSSE();
                        Get.offAll(() => const LoginScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 7),
                            SvgPicture.asset('assets/icons/logout.svg',
                                fit: BoxFit.cover),
                            const AppText(
                              'Logout',
                              fontSize: 12,
                            )
                          ],
                        ),
                      ),
                    ),
            ]),
        body: GetBuilder<DashboardController>(
            init: DashboardController(),
            initState: (state) {
              Future.delayed(
                Duration(microseconds: 250),
                () async {
                  if (API.emergencyStop) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      useRootNavigator: false,
                      builder: (context) {
                        return campaignEmergencyDialog(context);
                      },
                    );
                  }

                  DashboardController dashboardController =
                      Get.find<DashboardController>();
                  dashboardController.getTopBuyingProducts();
                  dashboardController.getLtdSalesInfo();

                  await paymentController.getPaymentRequestDataApi(
                      callingFromDashboard: true);
                  paymentController.update();
                },
              );
            },
            builder: (dashboardController) {
              DateTime now = DateTime.now();
              String currentMonth = DateFormat('MMMM yyyy').format(now);

              return Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // color: Colors.red,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// Purchases and profits container + table starts here

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                  color: const Color.fromRGBO(203, 203, 203, 1),
                                  width: 1)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  CommonText(
                                    content: "Purchases & Profit",
                                    textSize: 14,
                                    textColor: Color.fromRGBO(255, 139, 3, 1),
                                    boldNess: FontWeight.w500,
                                  ),
                                  SizedBox(width: 10),
                                  // Icon(
                                  //   Icons.payments,
                                  //   color: Color.fromRGBO(255, 139, 3, 1),
                                  // )
                                  AppImageAsset(
                                    image:
                                        'assets/icons/purchase_profit_icon.png',
                                    height: 18,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              dashboardController.isLtdSalesInfoLoading
                                  ? const AppShimmerEffectView(
                                      height: 130, width: double.infinity)
                                  : Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Expanded(
                                              child: CommonText(
                                                content: "",
                                                textSize: 14,
                                                textColor: Color.fromRGBO(
                                                    255, 139, 3, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: "Purchase",
                                                // textAlign: isLogin
                                                //     ? TextAlign.start
                                                //     : TextAlign.center,
                                                textAlign: TextAlign.center,
                                                textSize: 14,
                                                textColor: Color.fromRGBO(
                                                    139, 136, 136, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: "Profit",
                                                textSize: 14,
                                                textAlign: TextAlign.center,
                                                textColor: Color.fromRGBO(
                                                    139, 136, 136, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const DottedLine(
                                          dashColor:
                                              Color.fromRGBO(224, 224, 224, 1),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: CommonText(
                                                content: "Till Date",
                                                textSize: 14,
                                                textColor: Color.fromRGBO(
                                                    77, 77, 77, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: isLogin &&
                                                        dashboardController
                                                            .ltdSalesInfo
                                                            .isNotEmpty
                                                    ? "₹ ${dashboardController.ltdSalesInfo["ltdSalesAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["ltdSalesAmount"].toStringAsFixed(2)}"
                                                    : "-",
                                                textSize: 14,
                                                // textAlign: isLogin
                                                //     ? TextAlign.start
                                                //     : TextAlign.center,
                                                textAlign: TextAlign.center,
                                                textColor: Color.fromRGBO(
                                                    30, 170, 36, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: isLogin &&
                                                        dashboardController
                                                            .ltdSalesInfo
                                                            .isNotEmpty
                                                    ? "₹ ${dashboardController.ltdSalesInfo["ltdDiscountAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["ltdDiscountAmount"].toStringAsFixed(2)}"
                                                    : "-",
                                                textSize: 14,
                                                textAlign: TextAlign.center,
                                                textColor: const Color.fromRGBO(
                                                    30, 170, 36, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const DottedLine(
                                          dashColor:
                                              Color.fromRGBO(224, 224, 224, 1),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CommonText(
                                                content: currentMonth,
                                                textSize: 14,
                                                textColor: const Color.fromRGBO(
                                                    77, 77, 77, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: isLogin &&
                                                        dashboardController
                                                            .ltdSalesInfo
                                                            .isNotEmpty
                                                    ? "₹ ${dashboardController.ltdSalesInfo["currentMonthSalesAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["currentMonthSalesAmount"].toStringAsFixed(2)}"
                                                    : "-",
                                                textSize: 14,
                                                // textAlign: isLogin
                                                //     ? TextAlign.start
                                                //     : TextAlign.center,
                                                textAlign: TextAlign.center,
                                                textColor: const Color.fromRGBO(
                                                    30, 170, 36, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: CommonText(
                                                content: isLogin &&
                                                        dashboardController
                                                            .ltdSalesInfo
                                                            .isNotEmpty
                                                    ? "₹ ${dashboardController.ltdSalesInfo["currentMonthDiscountAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["currentMonthDiscountAmount"].toStringAsFixed(2)}"
                                                    : "-",
                                                textSize: 14,
                                                textAlign: TextAlign.center,
                                                textColor: Color.fromRGBO(
                                                    30, 170, 36, 1),
                                                boldNess: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),

                        /// Purchases and profits container + table ends here

                        SizedBox(height: 12),

                        /// Top Buying Products Table Starts Here

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 0),
                                blurRadius: 3,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  CommonText(
                                    content: "Top Selling Products",
                                    textSize: 14,
                                    textColor: Color.fromRGBO(255, 139, 3, 1),
                                    boldNess: FontWeight.w500,
                                  ),
                                  SizedBox(width: 10),
                                  // Icon(
                                  //   Icons.payments,
                                  //   color: Color.fromRGBO(255, 139, 3, 1),
                                  // )
                                  AppImageAsset(
                                    image:
                                        'assets/icons/top_selling_product_icon.png',
                                    height: 18,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Table(
                                border: const TableBorder(
                                    verticalInside: BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                        style: BorderStyle.solid),
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                        style: BorderStyle.solid)),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(1),
                                  // 1: FixedColumnWidth(75),
                                  // 2: FixedColumnWidth(65),
                                  // 3: FixedColumnWidth(65)
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 4,
                                            top: 4,
                                            bottom: 4),
                                        child: CommonText(
                                          content: "Products",
                                          textSize: width * 0.035,
                                          textColor:
                                              Color.fromRGBO(45, 54, 72, 1),
                                          boldNess: FontWeight.w500,
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 4,
                                              top: 4,
                                              bottom: 4),
                                          child: CommonText(
                                            content: "Quantity",
                                            textSize: width * 0.035,
                                            textAlign: TextAlign.center,
                                            textColor:
                                                Color.fromRGBO(45, 54, 72, 1),
                                            boldNess: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              dashboardController.isTopBuyingProductsLoading
                                  ? const Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AppShimmerEffectView(
                                            height: 150,
                                            width: double.infinity),
                                      ],
                                    )
                                  : Container(
                                      height: 140,
                                      child: SingleChildScrollView(
                                        child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(2),
                                            1: FlexColumnWidth(1),
                                            // 1: FixedColumnWidth(75),
                                            // 2: FixedColumnWidth(65),
                                            // 3: FixedColumnWidth(65),
                                          },
                                          // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                                          border: const TableBorder(
                                              // horizontalInside: BorderSide(
                                              //     width: 1,
                                              //     color: Color.fromRGBO(224, 224, 224, 1),
                                              //     style: BorderStyle.solid),
                                              verticalInside: BorderSide(
                                                  width: 1,
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, 1),
                                                  style: BorderStyle.solid)),
                                          children: List.generate(
                                            !isLogin ||
                                                    dashboardController
                                                        .topBuyingProductsList
                                                        .isEmpty
                                                ? 5
                                                : dashboardController
                                                    .topBuyingProductsList
                                                    .length,
                                            (index) => TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 4,
                                                          top: 4,
                                                          bottom: 4),
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .topBuyingProductsList
                                                                .isNotEmpty
                                                        ? dashboardController
                                                                .topBuyingProductsList[
                                                                    index]
                                                                .productName ??
                                                            ""
                                                        : " -",
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            77, 77, 77, 1),
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 4,
                                                          top: 4,
                                                          bottom: 4),
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .topBuyingProductsList
                                                                .isNotEmpty
                                                        ? dashboardController
                                                                    .topBuyingProductsList[
                                                                        index]
                                                                    .finalQuantity !=
                                                                null
                                                            ? (dashboardController
                                                                    .topBuyingProductsList[
                                                                        index]
                                                                    .finalQuantity!)
                                                                .toStringAsFixed(
                                                                    0)
                                                            : ""
                                                        : " -",
                                                    textSize: width * 0.03,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            77, 77, 77, 1),
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        /// Top Buying Products Table Ends Here

                        SizedBox(height: 12),
                        GetBuilder<ConfirmOrderController>(
                          builder: (controller) {
                            return confirmOrderController
                                    .isDashboardBuyClickLoading
                                ? AppShimmerEffectView(
                                    height: width * 0.5,
                                    width: double.infinity,
                                  )
                                : Container(
                                    // color: Colors.red,
                                    height: width * 0.45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (confirmOrderController
                                                  .isDashboardBuyClickLoading) {
                                                return;
                                              }

                                              await confirmOrderController
                                                  .getInternalPopup();

                                              if (confirmOrderController
                                                  .internalPopUpResponseModel1
                                                  .isNotEmpty) {
                                                Get.to(() =>
                                                    const ConfirmOrdersScreen());
                                                print(
                                                    "to the screen of confirm orders screen");
                                              } else {
                                                Get.to(() =>
                                                    const home.HomeScreen());
                                                print(
                                                    "to the screen of home screen");
                                              }
                                            },
                                            child: Container(
                                                // color: Colors.blue,
                                                height: double.infinity,
                                                child: AppImageAsset(
                                                  image:
                                                      'assets/image/buy_product.png',
                                                  // height: 80,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Get.to(
                                                () => const HomeScreen()),
                                            child: Container(
                                                // color: Colors.blue,
                                                height: double.infinity,
                                                child: AppImageAsset(
                                                  image:
                                                      'assets/image/sell_product.png',
                                                  // height: 80,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ),
                                        // InkWell(
                                        //   // onTap: () => Get.to(() => const home.HomeScreen()),
                                        //   onTap: () async {
                                        //     if (confirmOrderController.isDashboardBuyClickLoading) {
                                        //       return;
                                        //     }

                                        //     await confirmOrderController.getInternalPopup();

                                        //     if (confirmOrderController
                                        //         .internalPopUpResponseModel1.isNotEmpty) {
                                        //       Get.to(() => const ConfirmOrdersScreen());
                                        //     } else {
                                        //       Get.to(() => const home.HomeScreen());
                                        //     }
                                        //   },
                                        //   child: const AppImageAsset(
                                        //     image: 'assets/image/buy_product.png',
                                        //     height: 80,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 30),
                                        // InkWell(
                                        //   onTap: () => Get.to(() => const HomeScreen()),
                                        //   child: const AppImageAsset(
                                        //     image: 'assets/image/sell_product.png',
                                        //     height: 80,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                        // confirmOrderController.isDashboardBuyClickLoading
                        //     ? AppShimmerEffectView(
                        //         height: width * 0.5,
                        //         width: double.infinity,
                        //       )
                        // : Container(
                        //     // color: Colors.red,
                        //     height: width * 0.5,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Expanded(
                        //           child: GestureDetector(
                        //             onTap: () async {
                        //               if (confirmOrderController
                        //                   .isDashboardBuyClickLoading) {
                        //                 return;
                        //               }

                        //               await confirmOrderController
                        //                   .getInternalPopup();

                        //               if (confirmOrderController
                        //                   .internalPopUpResponseModel1
                        //                   .isNotEmpty) {
                        //                 // Get.to(() => const ConfirmOrdersScreen());
                        //                 print(
                        //                     "to the screen of confirm orders screen");
                        //               } else {
                        //                 // Get.to(() => const home.HomeScreen());
                        //                 print("to the screen of home screen");
                        //               }
                        //             },
                        //             child: Container(
                        //                 child: AppImageAsset(
                        //               image: 'assets/image/buy_product.png',
                        //               // height: 80,
                        //               fit: BoxFit.fill,
                        //             )),
                        //           ),
                        //         ),
                        //         Expanded(
                        //           child: GestureDetector(
                        //             onTap: () =>
                        //                 Get.to(() => const home.HomeScreen()),
                        //             child: Container(
                        //                 child: AppImageAsset(
                        //               image: 'assets/image/sell_product.png',
                        //               // height: 80,
                        //               fit: BoxFit.fill,
                        //             )),
                        //           ),
                        //         ),
                        //         // InkWell(
                        //         //   // onTap: () => Get.to(() => const home.HomeScreen()),
                        //         //   onTap: () async {
                        //         //     if (confirmOrderController.isDashboardBuyClickLoading) {
                        //         //       return;
                        //         //     }

                        //         //     await confirmOrderController.getInternalPopup();

                        //         //     if (confirmOrderController
                        //         //         .internalPopUpResponseModel1.isNotEmpty) {
                        //         //       Get.to(() => const ConfirmOrdersScreen());
                        //         //     } else {
                        //         //       Get.to(() => const home.HomeScreen());
                        //         //     }
                        //         //   },
                        //         //   child: const AppImageAsset(
                        //         //     image: 'assets/image/buy_product.png',
                        //         //     height: 80,
                        //         //     fit: BoxFit.cover,
                        //         //   ),
                        //         // ),
                        //         // const SizedBox(height: 30),
                        //         // InkWell(
                        //         //   onTap: () => Get.to(() => const HomeScreen()),
                        //         //   child: const AppImageAsset(
                        //         //     image: 'assets/image/sell_product.png',
                        //         //     height: 80,
                        //         //     fit: BoxFit.cover,
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),
                        SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //             color: Color.fromRGBO(255, 122, 0, 1),
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: Center(
                        //           child: CommonText(
                        //             content: "Buy Products",
                        //             textSize: width * 0.035,
                        //             textColor: AppColors.appWhite,
                        //             boldNess: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     Expanded(
                        //       child: Container(
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //             color: Color.fromRGBO(255, 122, 0, 1),
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: Center(
                        //           child: CommonText(
                        //             content: "Sell Products",
                        //             textSize: width * 0.035,
                        //             textColor: AppColors.appWhite,
                        //             boldNess: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 12),

                        //Drug Licese Expiry Starts Here

                        isLogin && drugExpiryDate != ""
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        offset: Offset(0, 0),
                                        blurRadius: 3,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(4)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      content:
                                          "Drug License Expiry : $drugExpiryDate",
                                      textSize: 14,
                                      textColor: Colors.black,
                                      boldNess: FontWeight.w500,
                                    ),
                                    // SizedBox(height: 3),
                                    // CommonText(
                                    //   content:
                                    //       "Expiring in $drugExpiringDays days",
                                    //   textSize: 14,
                                    //   textColor: AppColors.greenColor,
                                    //   boldNess: FontWeight.w500,
                                    // ),
                                  ],
                                ),
                              )
                            : SizedBox(),

                        isLogin ? SizedBox(height: 10) : SizedBox(),

                        //Drug Lciense Exdpiry Ends Here

                        // Payment Dues Table Starts Here

                        GetBuilder<PaymentController>(
                            builder: (paymentController) {
                          return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 0),
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              margin: EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      CommonText(
                                        content: "Payment Dues",
                                        textSize: 14,
                                        textColor:
                                            Color.fromRGBO(255, 139, 3, 1),
                                        boldNess: FontWeight.w500,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.payments,
                                        color: Color.fromRGBO(255, 139, 3, 1),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Obx(
                                    () => paymentController.isLoading.value
                                        ? AppShimmerEffectView(
                                            width: double.infinity,
                                            height: 180,
                                          )
                                        : Column(
                                            children: [
                                              isLogin &&
                                                      paymentController
                                                          .paymentRequestList
                                                          .isEmpty
                                                  ? SizedBox()
                                                  : Table(
                                                      border: const TableBorder(
                                                          verticalInside: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      224,
                                                                      224,
                                                                      224,
                                                                      1),
                                                              style: BorderStyle
                                                                  .solid),
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      224,
                                                                      224,
                                                                      224,
                                                                      1),
                                                              style: BorderStyle
                                                                  .solid)),
                                                      defaultVerticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      columnWidths: const <int,
                                                          TableColumnWidth>{
                                                        // 0: FlexColumnWidth(),
                                                        // 1: FixedColumnWidth(75),
                                                        0: FixedColumnWidth(80),
                                                        // 1: FixedColumnWidth(75),
                                                        1: FlexColumnWidth(),
                                                        2: FixedColumnWidth(65),
                                                        3: FixedColumnWidth(65)
                                                      },
                                                      children: [
                                                        TableRow(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: CommonText(
                                                                content:
                                                                    "Invoice Date",
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                                textColor: Color
                                                                    .fromRGBO(
                                                                        45,
                                                                        54,
                                                                        72,
                                                                        1),
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child:
                                                                    CommonText(
                                                                  content:
                                                                      "Invoice No",
                                                                  textSize:
                                                                      width *
                                                                          0.035,
                                                                  textColor: Color
                                                                      .fromRGBO(
                                                                          45,
                                                                          54,
                                                                          72,
                                                                          1),
                                                                  boldNess:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: CommonText(
                                                                content:
                                                                    "Amount (₹)",
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                                textColor: Color
                                                                    .fromRGBO(
                                                                        45,
                                                                        54,
                                                                        72,
                                                                        1),
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: CommonText(
                                                                content:
                                                                    "Due Days",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                                textColor: Color
                                                                    .fromRGBO(
                                                                        45,
                                                                        54,
                                                                        72,
                                                                        1),
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                              Container(
                                                height: 130,
                                                child: isLogin &&
                                                        paymentController
                                                            .paymentRequestList
                                                            .isEmpty
                                                    ? const Center(
                                                        child: CommonText(
                                                            content:
                                                                "No Payment Dues",
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor:
                                                                Color.fromRGBO(
                                                                    157,
                                                                    157,
                                                                    157,
                                                                    1)),
                                                      )
                                                    : SingleChildScrollView(
                                                        child: Table(
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          columnWidths: const <int,
                                                              TableColumnWidth>{
                                                            0: FixedColumnWidth(
                                                                80),
                                                            // 1: FixedColumnWidth(75),
                                                            1: FlexColumnWidth(),
                                                            2: FixedColumnWidth(
                                                                65),
                                                            3: FixedColumnWidth(
                                                                65),
                                                          },
                                                          // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                                                          border:
                                                              const TableBorder(
                                                                  // horizontalInside: BorderSide(
                                                                  //     width: 1,
                                                                  //     color: Color.fromRGBO(224, 224, 224, 1),
                                                                  //     style: BorderStyle.solid),
                                                                  verticalInside: BorderSide(
                                                                      width: 1,
                                                                      color: Color.fromRGBO(
                                                                          224,
                                                                          224,
                                                                          224,
                                                                          1),
                                                                      style: BorderStyle
                                                                          .solid)),
                                                          children:
                                                              List.generate(
                                                            paymentController
                                                                    .paymentRequestList
                                                                    .isNotEmpty
                                                                ? paymentController
                                                                            .paymentRequestList
                                                                            .length *
                                                                        2 +
                                                                    1
                                                                : isLogin
                                                                    ? 0
                                                                    : 7,
                                                            // (index) => index ==
                                                            //         paymentController
                                                            //                 .paymentRequestList
                                                            //                 .length *
                                                            //             2
                                                            (index) => index ==
                                                                    (isLogin &&
                                                                            paymentController
                                                                                .paymentRequestList.isNotEmpty
                                                                        ? paymentController.paymentRequestList.length *
                                                                            2
                                                                        : 6)
                                                                ? TableRow(
                                                                    children: [
                                                                      CommonText(
                                                                        content:
                                                                            "",
                                                                        textSize:
                                                                            width *
                                                                                0.035,
                                                                        textColor: const Color.fromRGBO(
                                                                            45,
                                                                            54,
                                                                            72,
                                                                            1),
                                                                        boldNess:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      TableCell(
                                                                        child:
                                                                            CommonText(
                                                                          content:
                                                                              "",
                                                                          textSize:
                                                                              width * 0.035,
                                                                          textColor: Color.fromRGBO(
                                                                              45,
                                                                              54,
                                                                              72,
                                                                              1),
                                                                          boldNess:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      CommonText(
                                                                        content:
                                                                            "",
                                                                        textSize:
                                                                            width *
                                                                                0.035,
                                                                        textColor: const Color.fromRGBO(
                                                                            45,
                                                                            54,
                                                                            72,
                                                                            1),
                                                                        boldNess:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      CommonText(
                                                                        content:
                                                                            "",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        textSize:
                                                                            width *
                                                                                0.035,
                                                                        textColor: Color.fromRGBO(
                                                                            45,
                                                                            54,
                                                                            72,
                                                                            1),
                                                                        boldNess:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : index % 2 == 0
                                                                    ? TableRow(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                CommonText(
                                                                              content: isLogin && paymentController.paymentRequestList.isNotEmpty
                                                                                  ? paymentController.paymentRequestList[index ~/ 2].billDate == null
                                                                                      ? ""
                                                                                      : DateFormat('dd-MM-yy').format(paymentController.paymentRequestList[index ~/ 2].billDate ?? DateTime.now())
                                                                                  : " -",
                                                                              textSize: width * 0.035,
                                                                              textColor: const Color.fromRGBO(77, 77, 77, 1),
                                                                              boldNess: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                Tooltip(
                                                                              textStyle: GoogleFonts.poppins(color: Colors.white),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              verticalOffset: 10,
                                                                              triggerMode: TooltipTriggerMode.tap,
                                                                              preferBelow: false,
                                                                              showDuration: const Duration(seconds: 3),
                                                                              message: "Order No: ${isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].orderId ?? "" : " -"} \nAmount : ₹${isLogin && paymentController.paymentRequestList.isNotEmpty ? (paymentController.paymentRequestList[index ~/ 2].billedAmount == null) ? '' : paymentController.paymentRequestList[index ~/ 2].billedAmount!.toStringAsFixed(0) : " -"}\nOrder On : ${isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].billDate == null ? "" : DateFormat('dd-MM-yy').format(paymentController.paymentRequestList[index ~/ 2].billDate ?? DateTime.now()) : " -"}",
                                                                              child: CommonText(
                                                                                content: isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].orderId ?? "" : " -",
                                                                                textSize: width * 0.03,
                                                                                textColor: const Color.fromRGBO(77, 77, 77, 1),
                                                                                boldNess: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                CommonText(
                                                                                  content: isLogin && paymentController.paymentRequestList.isNotEmpty
                                                                                      ? (paymentController.paymentRequestList[index ~/ 2].balanceToBePaid == null)
                                                                                          ? ''
                                                                                          : paymentController.paymentRequestList[index ~/ 2].balanceToBePaid!.toStringAsFixed(0)
                                                                                      : " -",
                                                                                  textSize: width * 0.035,
                                                                                  textColor: const Color.fromRGBO(77, 77, 77, 1),
                                                                                  boldNess: FontWeight.w400,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                isLogin && paymentController.paymentRequestList.isNotEmpty
                                                                                    ? AppHtmlText(
                                                                                        '${paymentController.paymentRequestList[index ~/ 2].dueSince ?? ''}',
                                                                                        fontSize: 14,
                                                                                      )
                                                                                    : CommonText(
                                                                                        content: "-",
                                                                                        textSize: width * 0.035,
                                                                                        textColor: const Color.fromRGBO(77, 77, 77, 1),
                                                                                        boldNess: FontWeight.w400,
                                                                                      ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    if (isLogin && paymentController.paymentRequestList.isNotEmpty) {
                                                                                      Get.to(() => const home.HomeScreen(
                                                                                            moveToBottomIndex: 3,
                                                                                          ));
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 40,
                                                                                    decoration: BoxDecoration(color: isLogin && paymentController.paymentRequestList.isNotEmpty ? Color.fromRGBO(255, 122, 0, 1) : Color.fromRGBO(139, 136, 136, 1), borderRadius: BorderRadius.circular(6)),
                                                                                    child: Center(
                                                                                      child: CommonText(
                                                                                        content: "Pay",
                                                                                        textSize: width * 0.035,
                                                                                        textColor: AppColors.appWhite,
                                                                                        boldNess: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const TableRow(
                                                                        children: [
                                                                          DottedLine(
                                                                            dashColor: Color.fromRGBO(
                                                                                224,
                                                                                224,
                                                                                224,
                                                                                1),
                                                                          ),
                                                                          DottedLine(
                                                                            dashColor: Color.fromRGBO(
                                                                                224,
                                                                                224,
                                                                                224,
                                                                                1),
                                                                          ),
                                                                          DottedLine(
                                                                            dashColor: Color.fromRGBO(
                                                                                224,
                                                                                224,
                                                                                224,
                                                                                1),
                                                                          ),
                                                                          DottedLine(
                                                                            dashColor: Color.fromRGBO(
                                                                                224,
                                                                                224,
                                                                                224,
                                                                                1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ));
                        }),

                        // Payment Dues Table Ends Here

                        SizedBox(height: 10),

                        /// Version Info

                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CommonText(
                            textAlign: TextAlign.center,
                            content: "Version : ${API.appVersion}",
                            textSize: 8,
                            textColor: Colors.black,
                            boldNess: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
        // body: GetBuilder<ConfirmOrderController>(builder: (_) {
        //   return Center(
        //     child: SingleChildScrollView(
        //       child: confirmOrderController.isDashboardBuyClickLoading
        //           ? CircularProgressIndicator()
        //           : Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 InkWell(
        //                   // onTap: () => Get.to(() => const home.HomeScreen()),
        //                   onTap: () async {
        //                     if (confirmOrderController
        //                         .isDashboardBuyClickLoading) {
        //                       return;
        //                     }

        //                     await confirmOrderController.getInternalPopup();

        //                     if (confirmOrderController
        //                         .internalPopUpResponseModel1.isNotEmpty) {
        //                       Get.to(() => const ConfirmOrdersScreen());
        //                     } else {
        //                       Get.to(() => const home.HomeScreen());
        //                     }
        //                   },
        //                   child: const AppImageAsset(
        //                     image: 'assets/image/buy_product.png',
        //                     height: 280,
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //                 const SizedBox(height: 30),
        //                 InkWell(
        //                   onTap: () => Get.to(() => const HomeScreen()),
        //                   child: const AppImageAsset(
        //                     image: 'assets/image/sell_product.png',
        //                     height: 280,
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //     ),
        //   );
        // }),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.only(bottom: 10),
        //   child: CommonText(
        //     textAlign: TextAlign.center,
        //     content: "Version : ${API.appVersion}",
        //     textColor: Colors.black,
        //     boldNess: FontWeight.w500,
        //   ),
        // ),
      ),
    );
  }

  Widget campaignEmergencyDialog(BuildContext) {
    print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.network(
            API.emergencyStopImg, // Image loaded from a network URL
            width: MediaQuery.of(context).size.width *
                0.9, // Image width is 90% of screen width
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image is fully loaded
                return child;
              } else {
                // Image is still loading, show CircularProgressIndicator
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
