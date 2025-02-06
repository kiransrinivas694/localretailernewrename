import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/controllers/auth_controller/login_controller.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller.dart';
import 'package:b2c/screens/auth/app_rejected_screen.dart';
import 'package:b2c/screens/auth/login_screen.dart';
import 'package:b2c/screens/auth/mobile_no_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/assign_delivery_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/partial_order_screen.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_drawer_tile.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/home_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/account_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/home_screens/inventory_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/home_screens/notification_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/all_order_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/cancelled_orders_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/delivered_order_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/delivery_in_process_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/rejected_orders_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/store_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'auth/app_pending_screen.dart';
import 'bottom_nav_bar/home_screens/controller/inventory_controller.dart';
import 'bottom_nav_bar/store_screen/order_screens/new_order_screen.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart' as home;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*final LoginController loginController = Get.put(LoginController());
  getProfile() async {
    await loginController
        .profileStatus(GetHelperController.storeID.value)
        .then((value) async {
      if (value != null) {
        print("bodyMap <<<<<<<==>>$value");

        print(">>>>>>>>>>>>>>>>${GetHelperController.token.value}");
        await SharPreferences.setString(SharPreferences.accessToken,
            "Bearer ${GetHelperController.token.value}");
        print(value['applicationStatus']);
        if (value['applicationStatus'] == "Onboarded") {
          await SharPreferences.setString(
              SharPreferences.storeCategoryId, value['storeCategoryId'] ?? "");
          await SharPreferences.setString(
              SharPreferences.storeName, value['storeName'] ?? "");
          await SharPreferences.setBoolean(SharPreferences.isLogin, true);
          Get.offAll(() => const HomeScreen(), transition: Transition.size);
        } else if (value['applicationStatus'] == "Pending") {
          Get.to(() => AppPendingScreen(), transition: Transition.size);
        } else if (value['applicationStatus'] == "Rejected") {
          Get.to(
              () => AppRejectedScreen(
                  email: value['email'],
                  password: value['password'],
                  reasonReject: value["reason"] ?? {}),
              transition: Transition.size);
        }
      }
    });
  }*/

  final EditProfileController _editProfileController =
      Get.put(EditProfileController());

  /*Future getdata() async {
    await _editProfileController.getUserId();
    _editProfileController.getCategory();
    await _editProfileController.getProfileDataApi();
  }*/

  @override
  void initState() {
    // getdata();
    _editProfileController.getProfileDataApi();
    AssignDeliveryController.to.getRiderApi();
    InventoryListController.to.getCategoriesApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GetBuilder<HomeB2CController>(
        init: HomeB2CController(),
        builder: (controller) => Scaffold(
          key: controller.key,
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Obx(() {
              return CommonText(
                content: appBarTitle.value,
                boldNess: FontWeight.w600,
                textSize: 14,
              );
            }),
            elevation: 0,
            actions: [
              Switch(
                value: false,
                onChanged: (value) => Get.offAll(() => const DashboardScreen()),
                inactiveThumbColor: ColorsConst.greenColor,
                inactiveTrackColor: ColorsConst.greenColor.withOpacity(0.6),
              ),
              // controller.currentIndex == 4
              //         ? Padding(
              //             padding: const EdgeInsets.only(right: 10),
              //             child: InkWell(
              //               onTap: () async {
              //                 await SharPreferences.clearSharPreference();
              //                 await PreferencesHelper().clearPreferenceData();
              //                 Get.offAll(() => const LoginScreen());
              //               },
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   const Icon(Icons.logout),
              //                   CommonText(
              //                     content: "Logout",
              //                     textSize: width * 0.03,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           )
              //         : const SizedBox()
            ],
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
          ),
          drawer: Drawer(
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                CommonDrawerTile(
                  onTap: () {
                    var argument = {"selectTab": 0};
                    Get.to(() => NewOrderScreen(), arguments: argument);
                  },
                  title: "New Order",
                ),
                CommonDrawerTile(
                  onTap: () {
                    var argument = {"selectTab": 1};
                    Get.to(() => NewOrderScreen(), arguments: argument);
                  },
                  title: "Accepted",
                ),
                CommonDrawerTile(
                  onTap: () {
                    Get.to(() => PartialOrderScreen());
                  },
                  title: "Partially Accepted",
                ),
                CommonDrawerTile(
                  onTap: () {
                    Get.to(() => DeliveryInProcessScreen());
                  },
                  title: "Delivery in process",
                ),
                CommonDrawerTile(
                  onTap: () {
                    Get.to(() => DeliveredOrderScreen());
                  },
                  title: "Delivered",
                ),
                CommonDrawerTile(
                  onTap: () {
                    Get.to(() => CancelledOrdersScreen());
                  },
                  title: "Cancelled",
                ),
                CommonDrawerTile(
                  onTap: () {
                    Get.to(() => RejectedOrderScreen());
                  },
                  title: "Rejected",
                ),
                /*  CommonDrawerTile(
                  onTap: () {
                    Get.to(() => AllOrderScreen());
                  },
                  title: "All Orders",
                ),*/
              ],
            ),
          ),
          body: controller.currentWidget,
          bottomNavigationBar: Stack(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.semiGreyColor.withOpacity(0.2),
                      offset: const Offset(0, -5),
                      blurRadius: 5,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appBarTitle.value =
                                GetHelperController.storeName.value;
                            controller.currentIndex = 0;
                            controller.currentWidget = StoreScreen();
                            controller.update();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                controller.currentIndex == 0
                                    ? "assets/icons/bottom_icons/home_select_icon.png"
                                    : "assets/icons/bottom_icons/home_unselect_icon.png",
                                scale: 4,
                              ),
                              CommonText(
                                content: "Home",
                                textSize: width * 0.03,
                                textColor: controller.currentIndex == 0
                                    ? AppColors.primaryColor
                                    : AppColors.semiGreyColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appBarTitle.value = "Inventory";
                            controller.currentIndex = 1;
                            controller.currentWidget = InventoryScreen();
                            controller.update();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                controller.currentIndex == 1
                                    ? "assets/icons/bottom_icons/inventory_select_icon.png"
                                    : "assets/icons/bottom_icons/inventory_unselect_icon.png",
                                scale: 4,
                              ),
                              CommonText(
                                content: "Inventory",
                                textSize: width * 0.03,
                                textColor: controller.currentIndex == 1
                                    ? AppColors.primaryColor
                                    : AppColors.semiGreyColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const SizedBox(
                              height: 60,
                              width: 60,
                            ),
                            Positioned(
                              top: -20,
                              right: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // controller.appBarTitle = "Store";
                                  controller.currentIndex = 2;
                                  controller.key.currentState!.openDrawer();
                                  // controller.currentWidget = OrderScreen();
                                  controller.update();
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.semiGreyColor
                                                .withOpacity(
                                                    0.3), // darker color
                                          ),
                                          const BoxShadow(
                                            color: Colors
                                                .white, // background color
                                            spreadRadius: -3.0,
                                            offset: Offset(2, 1),
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            controller.currentIndex == 2
                                                ? "assets/icons/bottom_icons/order_select_icon.png"
                                                : "assets/icons/bottom_icons/order_unselect_icon.png",
                                            scale: 4.5,
                                          ),
                                          CommonText(
                                            content: "Orders",
                                            textSize: width * 0.025,
                                            textColor:
                                                controller.currentIndex == 2
                                                    ? AppColors.primaryColor
                                                    : AppColors.semiGreyColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appBarTitle.value = "Notifications";
                            controller.currentIndex = 3;
                            controller.currentWidget = NotificationScreen();
                            controller.update();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                controller.currentIndex == 3
                                    ? "assets/icons/bottom_icons/notification_select_icon.png"
                                    : "assets/icons/bottom_icons/notification_unselect_icon.png",
                                scale: 4,
                              ),
                              CommonText(
                                content: "Notifications",
                                textSize: 11,
                                textColor: controller.currentIndex == 3
                                    ? AppColors.primaryColor
                                    : AppColors.semiGreyColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appBarTitle.value =
                                GetHelperController.storeName.value;
                            controller.currentIndex = 4;
                            controller.currentWidget = ProfileScreen();
                            controller.update();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                controller.currentIndex == 4
                                    ? "assets/icons/bottom_icons/account_select_icon.png"
                                    : "assets/icons/bottom_icons/account_unselect_icon.png",
                                scale: 4,
                              ),
                              CommonText(
                                content: "Account",
                                textSize: width * 0.03,
                                textColor: controller.currentIndex == 4
                                    ? AppColors.primaryColor
                                    : AppColors.semiGreyColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
