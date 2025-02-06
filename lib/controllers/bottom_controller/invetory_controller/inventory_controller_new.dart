import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;

  TextEditingController searchController = TextEditingController();

  final suppliersSelect = "".obs;

  bool isCheck = false;

  @override
  void onInit() {
    // TODO: implement onInit
    controller = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
