import 'package:b2c/utils/string_extensions_new.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/network_retailer_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/network_retailer_list_screen.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart' as home;

class NotificationTyes {
  static const networkRetailerRequest = "networkRetailerRequest";
  static const networkRetailerLinked = "networkRetailerLinked";
  static const networkRetailerAll = "networkRetailerAll";
}

Future<Widget> manageInitialMessage() async {
  RemoteMessage? message;
  try {
    message = await FirebaseMessaging.instance.getInitialMessage();
  } catch (e) {
    print("error in gettingInitialMessage");
  }

  Widget startScreen = home.HomeScreen();

  //// Navigation During Termination.

  if (message != null) {
    Map<String, dynamic> payloadMap = message.data;
    logs("ready to navigate from termination");

    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    bool isUserpresent = userId.isNotEmpty;

    String currentRoute = Get.currentRoute;

    // Network Retailer Requests Tab Redirection - Only need type
    if (payloadMap.containsKey("type") &&
        payloadMap['type'] != null &&
        payloadMap['type'] == NotificationTyes.networkRetailerRequest) {
      print('current route -> ${Get.currentRoute}');
      print(
          'notification util ${NotificationTyes.networkRetailerRequest} click launched');

      if (isUserpresent) {
        StoreController storeController = Get.put(StoreController());
        await storeController.mainProfileStatus().then((value) {
          if (storeController.networkStatus.value) {
            startScreen = const NetworkRetailerListScreen(
              moveToTabIndex: 2,
            );
          } else {
            print('notification util network retailer not enabled');
          }
        });
      } else {
        // Get.to(() => AskLoginScreen());
      }
    }

    // Network Retailer All Tab Redirection - Only need type
    else if (payloadMap.containsKey("type") &&
        payloadMap['type'] != null &&
        payloadMap['type'] == NotificationTyes.networkRetailerAll) {
      print('current route -> ${Get.currentRoute}');
      print(
          'notification util ${NotificationTyes.networkRetailerAll} click launched');

      if (isUserpresent) {
        StoreController storeController = Get.put(StoreController());
        await storeController.mainProfileStatus().then((value) {
          if (storeController.networkStatus.value) {
            startScreen = const NetworkRetailerListScreen(
              moveToTabIndex: 0,
            );
          } else {
            print('notification util network retailer not enabled');
          }
        });
      } else {
        // Get.to(() => AskLoginScreen());
      }
    }

    // Network Retailer Linked Tab Redirection - Only need type
    else if (payloadMap.containsKey("type") &&
        payloadMap['type'] != null &&
        payloadMap['type'] == NotificationTyes.networkRetailerLinked) {
      print('current route -> ${Get.currentRoute}');
      print(
          'notification util ${NotificationTyes.networkRetailerLinked} click launched');

      if (isUserpresent) {
        StoreController storeController = Get.put(StoreController());
        await storeController.mainProfileStatus().then((value) {
          if (storeController.networkStatus.value) {
            startScreen = const NetworkRetailerListScreen(
              moveToTabIndex: 1,
            );
          } else {
            print('notification util network retailer not enabled');
          }
        });
      } else {
        // Get.to(() => AskLoginScreen());
      }
    }
  } else {
    logs('No initial message received.');
  }

  print('printing start screen before returning $startScreen');
  return startScreen;
}

void notificationNavigationUtil(Map<String, dynamic> payload) async {
  print('notification util click launched $payload');
  String userId =
      await SharPreferences.getString(SharPreferences.loginId) ?? '';
  bool isUserpresent = userId.isNotEmpty;

  String currentRoute = Get.currentRoute;

  // Network Retailer Requests Tab Redirection - Only need type
  if (payload.containsKey("type") &&
      payload['type'] != null &&
      payload['type'] == NotificationTyes.networkRetailerRequest) {
    print('current route -> ${Get.currentRoute}');
    print(
        'notification util ${NotificationTyes.networkRetailerRequest} click launched');

    if (isUserpresent) {
      StoreController storeController = Get.put(StoreController());
      await storeController.mainProfileStatus().then((value) {
        if (storeController.networkStatus.value) {
          if (currentRoute == "/NetworkRetailerListScreen") {
            NetworkRetailerController nrController =
                Get.put(NetworkRetailerController());

            if (nrController.selectedRetailerListTab.value != 2) {
              nrController.requestRetailerSearchController.clear();
              nrController.selectedRetailerListTab.value = 2;
              nrController.networkRetailerRequestList.value = [];
              nrController.networkRetailerRequestListCurrentPage.value = 0;
              nrController.networkRetailerRequestListTotalPages.value = 0;
              nrController.getRequestNetworkRetailerList();
            }
          } else {
            Get.to(() => const NetworkRetailerListScreen(
                  moveToTabIndex: 2,
                ));
          }
        } else {
          print('notification util network retailer not enabled');
        }
      });
    } else {
      // Get.to(() => AskLoginScreen());
    }
  }

  // Network Retailer Linked Tab Redirection - Only need type
  else if (payload.containsKey("type") &&
      payload['type'] != null &&
      payload['type'] == NotificationTyes.networkRetailerLinked) {
    print('current route -> ${Get.currentRoute}');
    print(
        'notification util ${NotificationTyes.networkRetailerLinked} click launched');

    if (isUserpresent) {
      StoreController storeController = Get.put(StoreController());
      await storeController.mainProfileStatus().then((value) {
        if (storeController.networkStatus.value) {
          if (currentRoute == "/NetworkRetailerListScreen") {
            NetworkRetailerController nrController =
                Get.put(NetworkRetailerController());

            if (nrController.selectedRetailerListTab.value != 1) {
              nrController.linkedRetailerSearchController.clear();
              nrController.selectedRetailerListTab.value = 1;
              nrController.networkRetailerLinkedList.value = [];
              nrController.networkRetailerLinkedListCurrentPage.value = 0;
              nrController.networkRetailerLinkedListTotalPages.value = 0;
              nrController.getLinkedNetworkRetailerList();
            }
          } else {
            Get.to(() => const NetworkRetailerListScreen(
                  moveToTabIndex: 1,
                ));
          }
        } else {
          print('notification util network retailer not enabled');
        }
      });
    } else {
      // Get.to(() => AskLoginScreen());
    }
  }

  // Network Retailer All Tab Redirection - Only need type
  else if (payload.containsKey("type") &&
      payload['type'] != null &&
      payload['type'] == NotificationTyes.networkRetailerAll) {
    print('current route -> ${Get.currentRoute}');
    print(
        'notification util ${NotificationTyes.networkRetailerAll} click launched');

    if (isUserpresent) {
      StoreController storeController = Get.put(StoreController());
      await storeController.mainProfileStatus().then((value) {
        if (storeController.networkStatus.value) {
          if (currentRoute == "/NetworkRetailerListScreen") {
            NetworkRetailerController nrController =
                Get.put(NetworkRetailerController());

            if (nrController.selectedRetailerListTab.value != 0) {
              nrController.retailerSearchController.clear();
              nrController.selectedRetailerListTab.value = 0;
              nrController.networkRetailerList.value = [];
              nrController.networkRetailerListCurrentPage.value = 0;
              nrController.networkRetailerListTotalPages.value = 0;
              nrController.getNetworkRetailerList();
            }
          } else {
            Get.to(() => const NetworkRetailerListScreen(
                  moveToTabIndex: 0,
                ));
          }
        } else {
          print('notification util network retailer not enabled');
        }
      });
    } else {
      // Get.to(() => AskLoginScreen());
    }
  }
}
