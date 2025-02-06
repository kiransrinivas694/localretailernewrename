import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StoreB2CController extends GetxController {
  List<Map<String, dynamic>> storeList = [
    {"icon": "assets/icons/new_order.png", "title": "New orders"},
    {"icon": "assets/icons/analytics.png", "title": "Analytics"},
    {"icon": "assets/icons/users.png", "title": "Users"},
    {"icon": "assets/icons/video_call.png", "title": "Video calls"},
    {"icon": "assets/icons/delivery.png", "title": "Rider"},
    {"icon": "assets/image/subscription.png", "title": "Product Subscription"},
    {"icon": "assets/image/bank.png", "title": "Bank details"},
  ];

  final isLoading = false.obs;
  List bannerTopList = [].obs;
  final bannerBottomImageList = [].obs;
  RxInt bannerBottomIndex = 0.obs;
  final videoControllerList = [].obs;
  final bannerVideoControllerList = [].obs;
  final controller = PageController().obs;

  @override
  void onInit() {
    getVideoBannerTopDataApi();
    getBannerBottomImageDataApi();
    super.onInit();
  }

  Future<dynamic> getVideoBannerTopDataApi() async {
    try {
      bannerTopList.clear();
      isLoading.value = true;
      print(Uri.parse(ApiConfig.bannerTopApi + "/1"));
      final response = await http.get(Uri.parse(ApiConfig.bannerTopApi + "/1"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization':
            //     await SharPreferences.getString(SharPreferences.accessToken) ??
            //         ""
          });
      isLoading.value = false;

      if (response.statusCode == 200) {
        bannerTopList = jsonDecode(response.body);
        print("bannerTopList>>>>>>>>>>$bannerTopList");
        for (int i = 0; i < jsonDecode(response.body).length; i++) {
          // videoControllerList.add(await VideoPlayerController.network(
          //     jsonDecode(response.body)[i]['imageId'])
          //   ..initialize().then((play) {
          //     bannerVideoControllerList.value = jsonDecode(response.body);
          //     print(
          //         ">>>>>>>>>>>>>>Yes${videoControllerList[0].value.duration.inSeconds}");
          //     videoControllerList[0].play();
          //     Future.delayed(
          //         Duration(
          //             seconds: bannerVideoControllerList[0]['mediaDuratoin']),
          //         () {
          //       print(">>>>>>>>>>>>>>Yes>>>>>>>Change");
          //       controller.value.animateToPage(1,
          //           duration: Duration(milliseconds: 300),
          //           curve: Curves.easeIn);
          //     });
          //   }));
          videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
          videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
          videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
        }

        print(
            "printing videos list length -> ${videoControllerList.length} $videoControllerList");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getBannerBottomImageDataApi() async {
    try {
      bannerTopList.clear();
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiConfig.bannerTopApi + "/2"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization':
            //     await SharPreferences.getString(SharPreferences.accessToken) ??
            //         ""
          });
      isLoading.value = false;
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        bannerBottomImageList.value = jsonDecode(response.body);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }
}
