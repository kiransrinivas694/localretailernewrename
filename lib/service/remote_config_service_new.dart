import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:cron/cron.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart' as store_app_b2b;
import 'package:b2c/utils/shar_preferences_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:b2c/utils/shar_preferences_new.dart' as b2c_ref;

class RemoteConfigService {
  static final FirebaseRemoteConfig remoteConfig =
      FirebaseRemoteConfig.instance;

  //     remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

  // remoteConfig.addOnFetchListener((configUpdate, error) {
  //   if (error != null) {
  //     print("Error fetching config: $error");
  //     return;
  //   }

  //   print("Updated keys: ${configUpdate.updatedKeys}");

  //   remoteConfig.activate().then((bool changed) {
  //     if (changed) {
  //       displayWelcome();
  //     }
  //   }).catchError((error) {
  //     displayError(error);
  //   });
  // });

  static void addRemoteConfigListener() {
    remoteConfig.onConfigUpdated.listen(
      (event) async {
        await remoteConfig.activate();
        Set<String> aCheck = event.updatedKeys;

        List<String> aCheckList = aCheck.toList();
        String? firstElement = aCheckList.isNotEmpty ? aCheckList[0] : null;

        print("printing changed aCheck firebase -> ${aCheckList} ");
        print(
            "printing changed aCheck firebase contains ->${aCheckList.contains('retailer_dynamic_config')}");
        print(
            "printing changed aCheck firebase contains check2 ->${aCheck.contains('retailer_dynamic_config')}");
        if (aCheck.contains('retailer_dynamic_config')) {
          Map<String, dynamic> retailerDynamicConfig =
              jsonDecode(remoteConfig.getString('retailer_dynamic_config'));

          print("printing retailer dynamic config -> $retailerDynamicConfig");

          API.needMaxTimeStopFunctionality =
              retailerDynamicConfig["needMaxTimeStopFunctionality"];
          API.maxTimeToStopOrder = retailerDynamicConfig["maxTimeToStopOrder"];
          GlobalMainController gmc = Get.put(GlobalMainController());
          gmc.minimumOrderAmountValue =
              retailerDynamicConfig["minimumOrderAmountValue"];
          gmc.minimumOrderAmountConditionNeeded =
              retailerDynamicConfig["minimumOrderAmountConditionNeeded"];
          gmc.update();
          await gmc.cron.close();
          if (API.needMaxTimeStopFunctionality) {
            gmc.cronCallSchedule();
          }
          print(
              "printing retailer dynamic config after -> $retailerDynamicConfig");
          Get.off(() => DashboardScreen(
                gotoHomeScreen: true,
              ));
        }

        if (aCheck.contains('lockAllStores')) {
          GlobalMainController gmc = Get.put(GlobalMainController());

          gmc.isAllStoresLocked =
              jsonDecode(remoteConfig.getString('lockAllStores'));
          gmc.update();
        }
        if (aCheck.contains('isPartialPaymentAllowedB2B')) {
          GlobalMainController gmc = Get.put(GlobalMainController());
          gmc.isPartialPaymentAllowedB2B =
              jsonDecode(remoteConfig.getString('isPartialPaymentAllowedB2B'));
          gmc.update();

          print("update called inside isPartialPaymentAllowedB2B");
        }

        if (aCheck.contains('highMarginCategoryId')) {
          GlobalMainController gmc = Get.put(GlobalMainController());

          gmc.highMarginCategoryId =
              remoteConfig.getString('highMarginCategoryId');

          print("in listen called -> ${gmc.highMarginCategoryId}");
        }

        if (aCheck.contains('b2bconfigs')) {
          GlobalMainController gmc = Get.put(GlobalMainController());

          Map<String, dynamic> b2bConfigs =
              jsonDecode(remoteConfig.getString('b2bconfigs'));

          gmc.isPayNearOutstandingAmountNeeded =
              b2bConfigs["isPayNearOutstandingAmountNeeded"];
          gmc.showQuantity = b2bConfigs["showQuantityInRetailer"];
          gmc.maxOrderQuantityCheckProductLevel.value =
              b2bConfigs['maxOrderQuantityCheckProductLevel'];
          gmc.update();
        }
        //mysaa related Data//
        Set<String> keysSet = event.updatedKeys;

        List<String> keysList = keysSet.toList();
        if (keysList.contains('mysaa_config')) {
          GlobalMainController gc = Get.put(GlobalMainController());
          Map<String, dynamic> config =
              jsonDecode(remoteConfig.getString('mysaa_config'));
          if (config["nonProfessionalCharges"] !=
              gc.nonProfessionalCharges.value) {
            gc.nonProfessionalCharges.value = config["nonProfessionalCharges"];
          }
        }
      },
    );
  }

  static Future<void> setupRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 0),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      await remoteConfig.ensureInitialized();
      await remoteConfig.fetchAndActivate();
      addRemoteConfigListener();
    } on FirebaseException catch (e) {
      logs(
          'catch exception in setup remote config --> ${e.message.toString()}');
    }
  }

  static Future<void> getConfigValue() async {
    /// Mysaa Related
    Map<String, dynamic> mysaaConfig =
        jsonDecode(remoteConfig.getString('mysaa_config'));

    /// Mysaa Dev Base Url - devBaseUrl || Prod Base Url - prodBaseUrl || Qa Base Url - qaBaseUrl
    MysaaApi.baseUrl = mysaaConfig["devBaseUrl"];

    /// Todo : Base Url for B2B
    /// base url - prod -> b2bProdBaseUrl || dev -> b2bDevBaseUrl || qa -> b2bQaBaseUrl
    /// paymentk - prod -> razorPayProdKey || dev -> razorpayTestKey || qa -> razorpayTestKey

    API.baseUrl = (kDebugMode)
        ? remoteConfig.getString('b2bQaBaseUrl') // local
        : remoteConfig.getString('b2bQaBaseUrl'); // live

    API.baseUrl = "https://uat.thelocal.co.in/b2b/";

    API.razorpayKey = (kDebugMode)
        ? remoteConfig.getString('razorpayTestKey') // local
        : remoteConfig.getString('razorpayTestKey'); // live

    API.generalMedicineCategoryId = remoteConfig.getString('generalCategoryId');
    API.genericMedicineCategoryId = remoteConfig.getString('genericCategoryId');
    API.sppCategoryId = remoteConfig.getString('sppCategoryId');
    API.customerCareNumber = remoteConfig.getString("customerCareNumber");
    API.checkout1 = remoteConfig.getString("checkout1");
    API.checkout2 = remoteConfig.getString("checkout2");
    API.checkout3 = remoteConfig.getString("checkout3");

    Map<String, dynamic> campaignsMap =
        jsonDecode(remoteConfig.getString('local_retailer_campaigns'));

    Map<String, dynamic> retailerDynamicConfig =
        jsonDecode(remoteConfig.getString('retailer_dynamic_config'));

    Map<String, dynamic> b2bConfigs =
        jsonDecode(remoteConfig.getString('b2bconfigs'));

    Map<String, dynamic> config =
        jsonDecode(remoteConfig.getString('mysaa_config'));

    print(
        "printing campaging map -> ${campaignsMap["buyHomeBanners"]["isNeedToShow"]}");

    API.campaignsShowing = campaignsMap["buyHomeBanners"]["isNeedToShow"];
    API.campaignImg = campaignsMap["buyHomeBanners"]["imageUrls"];
    API.campaignContent = campaignsMap["content"];
    API.emergencyStop = campaignsMap["emergencyStop"];
    API.emergencyStopImg = campaignsMap["emergencyStopImage"];

    API.needMaxTimeStopFunctionality =
        retailerDynamicConfig["needMaxTimeStopFunctionality"];
    API.maxTimeToStopOrder = retailerDynamicConfig["maxTimeToStopOrder"];

    GlobalMainController gmc = Get.put(GlobalMainController());
    gmc.highMarginCategoryId = remoteConfig.getString('highMarginCategoryId');
    gmc.showQuantity = b2bConfigs["showQuantityInRetailer"];
    gmc.isAllStoresLocked = jsonDecode(remoteConfig.getString('lockAllStores'));
    gmc.isPartialPaymentAllowedB2B =
        jsonDecode(remoteConfig.getString('isPartialPaymentAllowedB2B'));
    // gmc.popup2ndOptionNeededB2B =
    //     jsonDecode(remoteConfig.getString('popup2ndOptionNeededB2B'));
    //related to payment awareness image popups
    gmc.isNeedToShowPaymentAwarenessPopups =
        b2bConfigs["paymentAwarenessImages"]["needToShow"];
    gmc.paymentAwarenessImgUrls =
        b2bConfigs["paymentAwarenessImages"]["imageUrls"];
    gmc.paymentAwarenessImagesUpdated =
        b2bConfigs["paymentAwarenessImagesUpdated"];
    gmc.maxOrderQuantityCheckProductLevel.value =
        b2bConfigs['maxOrderQuantityCheckProductLevel'];

    //related to payment awareness video popups
    gmc.isNeedToShowPaymentVideoPopup =
        b2bConfigs["paymentAwarenessVideos"]["needToShow"];
    gmc.paymentAwarenessVideosUpdated =
        b2bConfigs["paymentAwarenessVideosUpdated"];
    gmc.paymentAwarenessVideoUrl =
        b2bConfigs["paymentAwarenessVideos"]["videoUrl"];
    gmc.atleastOneSchemeNotApplicableText =
        b2bConfigs["atleastOneSchemeNotApplicableText"];
    gmc.atleastOneSchemeNotApplicableCartText =
        b2bConfigs['atleastOneSchemeNotApplicableCartText'];

    //related to minimum order amount
    gmc.minimumOrderAmountValue =
        retailerDynamicConfig["minimumOrderAmountValue"];
    gmc.minimumOrderAmountConditionNeeded =
        retailerDynamicConfig["minimumOrderAmountConditionNeeded"];

    //related to pay near outstanding amount
    gmc.isPayNearOutstandingAmountNeeded =
        b2bConfigs["isPayNearOutstandingAmountNeeded"];

    //mysaa related Data//
    gmc.nonProfessionalCharges.value = config['nonProfessionalCharges'];

    gmc.update();
    if (API.needMaxTimeStopFunctionality) {
      gmc.cronCallSchedule();
    }

    print(
        'remote checking popup popup2ndOptionNeededB2B - ${gmc.popup2ndOptionNeededB2B}');

    print(
        "remote checking highMarginCategoryId --> ${gmc.highMarginCategoryId}");

    print("remote checking isAllStoresLocked --> ${gmc.isAllStoresLocked}");
    print(
        "remote checking isPartialPaymentAllowedB2B --> ${gmc.isPartialPaymentAllowedB2B}");

    print(
        "remote checking isNeedToShowPaymentVideoPopup --> ${gmc.isNeedToShowPaymentVideoPopup}");

    print(
        "remote checking paymentAwarenessVideosUpdated --> ${gmc.paymentAwarenessVideosUpdated}");
    print(
        "remote checking paymentAwarenessVideoUrl --> ${gmc.paymentAwarenessVideoUrl}");

    print(
        "remote checking isNeedToShowPaymentAwarenessPopups --> ${gmc.isNeedToShowPaymentAwarenessPopups}");

    print(
        "remote checking paymentAwarenessImgUrls --> ${gmc.paymentAwarenessImgUrls}");

    print("remote checking campaignsShowing --> ${API.campaignsShowing}");
    print("remote checking campaignsShowing --> ${API.campaignImg}");
    print(
        "remote checking needMaxTimeStopFunctionality --> ${API.needMaxTimeStopFunctionality}");
    print("remote checking maxTimeToStopOrder --> ${API.maxTimeToStopOrder}");
    print("remote checking campaignsShowing --> ${campaignsMap["content"]}");
    print("remote checking emergency --> ${API.emergencyStop}");
    print("remote checking emergency stop img --> ${API.emergencyStopImg}");
    // print(
    //     "remote checking minimumOrderAmountConditionNeeded --> ${API.minimumOrderAmountConditionNeeded}");

    // Map<String, dynamic> appInfoMap =
    // jsonDecode(remoteConfig.getString('local_seller_update_info'));

    // API.appVersion =
    // appInfoMap[Platform.isAndroid ? 'android' : 'ios']['display_version'];

    /// Todo : Base Url for B2C
    /// base url - prod -> b2cProdBaseUrl || dev -> b2cDevBaseUrl || qa -> b2cQaBaseUrl
    /// paymentk - prod -> razorPayProdKey || dev -> razorpayTestKey || qa -> razorpayTestKey

    ApiConfig.baseUrl = (kDebugMode)
        ? remoteConfig.getString('b2cQaBaseUrl') // local
        : remoteConfig.getString('b2cQaBaseUrl'); //live

    ApiConfig.baseUrl = "https://uat.thelocal.co.in/";

    ApiConfig.razorpayKey = (kDebugMode)
        ? remoteConfig.getString('razorpayTestKey')
        : remoteConfig.getString('razorpayTestKey'); // local

    logs('remote b2c baseUrl ---> ${ApiConfig.baseUrl}');
    logs('remote b2b baseUrl ---> ${API.baseUrl}');
    logs('remote Razorpay key b2c ---> ${API.razorpayKey}');

    logs(
        'remote generalMedicineCategoryId ---> ${API.generalMedicineCategoryId}');
    logs(
        'remote genericMedicineCategoryId ---> ${API.genericMedicineCategoryId}');
    logs('remote sppCategoryId ---> ${API.sppCategoryId}');

    logs('remote checkout1 value ---> ${API.checkout1}');
    logs('remote checkout2 value ---> ${API.checkout2}');
    logs('remote checkout3 value ---> ${API.checkout3}');

    logs('remote Razorpay key b2b ---> ${ApiConfig.razorpayKey}');
    logs('remote Razorpay key b2b ---> ${ApiConfig.razorpayKey}');
    logs('remote Razorpay key b2b ---> ${ApiConfig.razorpayKey}');
  }

  static getUpdateConfigValue(bool mounted, BuildContext context) async {
    Map<String, dynamic> appInfoMap =
        jsonDecode(remoteConfig.getString('local_seller_update_info'));
    logs("appInfoMap ---> ${appInfoMap.toString()}");
    String updateType =
        appInfoMap[Platform.isAndroid ? 'android' : 'ios']['update_type'];
    if (updateType != 'none') {
      num remoteAppVersion =
          appInfoMap[Platform.isAndroid ? 'android' : 'ios']['app_version'];
      String whatsNew =
          appInfoMap[Platform.isAndroid ? 'android' : 'ios']['whats_new'];
      String updateLink = Platform.isAndroid
          ? appInfoMap['android']['android_path']
          : appInfoMap['ios']['ios_path'];
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String tmpAppVersion = packageInfo.version.replaceAll('.', '');

      API.appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      print(
          "printing storedUser aVersion --> ${packageInfo.version} ${packageInfo.buildNumber}");

      String storedUserVersion = await store_app_b2b.SharPreferences.getString(
              store_app_b2b.SharPreferences.versionNumber) ??
          "";

      print("printing storedUserVersion --> $storedUserVersion");

      if (storedUserVersion == "" ||
          num.parse(tmpAppVersion) > num.parse(storedUserVersion)) {
        print("printing storedUser update detected");

        await SharPreferences.clearSharPreference();
        await store_app_b2b.SharPreferences.clearSharPreference();
        await PreferencesHelper().clearPreferenceData();

        await store_app_b2b.SharPreferences.setString(
            store_app_b2b.SharPreferences.versionNumber, tmpAppVersion);

        Get.offAll(() => const HomeScreen());
      } else {
        print("printing storedUser no update detected");
      }

      await store_app_b2b.SharPreferences.setString(
          store_app_b2b.SharPreferences.versionNumber, tmpAppVersion);

      logs("tmpAppVersion --> $tmpAppVersion");
      logs("updateType --> $updateType");
      logs("updateLink --> $updateLink");

      if (num.parse(tmpAppVersion) < remoteAppVersion) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: (updateType == 'soft') ? true : false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return updateType == 'soft';
                },
                child: AlertDialog(
                  titlePadding: const EdgeInsets.symmetric(vertical: 3),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                  contentPadding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  // title: Container(
                  //   alignment: Alignment.centerLeft,
                  //   padding: const EdgeInsets.symmetric(horizontal: 5),
                  //   decoration: BoxDecoration(
                  //       color: AppColors.primaryColor,
                  //       borderRadius: const BorderRadius.only(
                  //           topLeft: Radius.circular(4),
                  //           topRight: Radius.circular(4))),
                  //   height: 50,
                  //   child: AppText(
                  //       fontSize: 16,
                  //       'New version available ${addDots(remoteAppVersion.toString())}'),
                  // ),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Image.asset(
                          'assets/image/subscription.png',
                          fit: BoxFit.contain,
                          height: 190.08,
                          width: 228.04,
                          package: 'store_app_b2b',
                        ),
                        const SizedBox(height: 10),
                        AppText(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          'New version available ${addDots(remoteAppVersion.toString())}',
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          whatsNew,
                          color: AppColors.appGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => launchUrlString(updateLink,
                                mode: LaunchMode.externalApplication),
                            child: Container(
                              height: 44,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(44),
                                  color: AppColors.primaryColor),
                              child: const AppText('Update',
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        if (updateType == 'soft')
                          Expanded(
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 44,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(44),
                                    border: Border.all(
                                        color: AppColors.primaryColor)),
                                child: AppText('Cancel',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    }

    print("printing at the end of the getupdate config value");
  }
}

String addDots(String text) {
  const int addDotEvery = 1;
  String out = '';
  for (int i = 0; i < text.length; i++) {
    if (i + 1 > addDotEvery && i % addDotEvery == 0) {
      out += '.';
    }
    out += text[i];
  }
  return out;
}
