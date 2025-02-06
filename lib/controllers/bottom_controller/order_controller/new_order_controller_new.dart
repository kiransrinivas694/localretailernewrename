import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final viewMoreNewOrder = "".obs;
  final viewMoreAcceptedOrder = "".obs;

  @override
  void onInit() {
    controller = TabController(
        vsync: this, length: 2, initialIndex: Get.arguments['selectTab']);

    super.onInit();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
