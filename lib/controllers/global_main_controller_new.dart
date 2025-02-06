import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:cron/cron.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/service/api_service.dart';

class GlobalMainController extends GetxController {
  Cron cron = Cron();
  bool isAllStoresLocked = false;
  bool isPartialPaymentAllowedB2B = false;

  //related to payment awareness image popups
  bool isNeedToShowPaymentAwarenessPopups = false;
  bool paymentAwarenessImagesUpdated = false;
  List paymentAwarenessImgUrls = [];

  //related to payment awareness video popups
  bool isNeedToShowPaymentVideoPopup = false;
  bool paymentAwarenessVideosUpdated = false;
  String paymentAwarenessVideoUrl = "";

  //related to minimum order value
  num minimumOrderAmountValue = 500;
  bool minimumOrderAmountConditionNeeded = true;

  //related to pay near outstanding amount
  bool isPayNearOutstandingAmountNeeded = false;

  //related to showing quantity in products
  bool showQuantity = false;

  //related to category id - high margin
  String highMarginCategoryId = "";

  //related to popup
  bool popup2ndOptionNeededB2B = false;
  String atleastOneSchemeNotApplicableText =
      "Product not available right now. Please try again later";
  String atleastOneSchemeNotApplicableCartText =
      "Product not available right now. Please try again later";

  //max order quantity check
  var maxOrderQuantityCheckProductLevel = true.obs;

  void cronCallSchedule() {
    print("printing cronCallSchedule ");

    cron = Cron();

    cron.schedule(
        Schedule.parse('00 ${API.maxTimeToStopOrder.toString()} * * *'),
        () async {
      print(
          "This code runs at ${API.maxTimeToStopOrder.toString()} time every day");
      Get.offAll(() => DashboardScreen(
            gotoHomeScreen: true,
          ));
    });
  }

  //Mysaa Related Data///

  var nonProfessionalCharges = 0.obs;
}
