import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/controllers/network_controller_new.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    // Get.put<GlobalMainController>(GlobalMainController(), permanent: true);
  }
}
