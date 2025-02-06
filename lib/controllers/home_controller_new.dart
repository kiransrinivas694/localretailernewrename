import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/store_screen_new.dart';

RxString appBarTitle = "".obs;

class HomeB2CController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  Widget currentWidget = StoreScreen();

  bool isOnNotification = false;

  int currentIndex = 0;
}
