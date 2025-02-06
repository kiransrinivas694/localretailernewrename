import 'package:b2c/screens/no_internet_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  late ConnectivityResult previousResult;

  void onInit() async {
    super.onInit();
    previousResult = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    print("prtinting current route -> ${Get.currentRoute}");
    String currentRoute = Get.currentRoute;
    // return;
    if (connectivityResult == ConnectivityResult.none) {
      Get.toNamed('/nointernet');
    } else {
      if (previousResult == ConnectivityResult.none) {
        if (currentRoute == "/nointernet") {
          Get.back();
        }
      }
    }
    previousResult = connectivityResult;
  }
}
