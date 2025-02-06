import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:get/get.dart';

import 'controller/get_notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    NotificationController.to.notificationList.clear();
    NotificationController.to.getNotificationListApi(
      queryParameters: {"page": page.value, "size": 10},
    );
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      page.value = page.value + 1;
      log(
        page.value.toString(),
        name: "PAGE CHANGE",
      );
      await NotificationController.to.getNotificationListApi(
        queryParameters: {"page": page.value, "size": 10},
      );
      ;

      isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            return NotificationController.to.notificationRes.isEmpty
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        NotificationController.to.notificationList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            right: 15,
                            left: 15,
                            bottom: 10,
                            top: index == 0 ? 10 : 0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              content: NotificationController
                                      .to.notificationList[index]?['title'] ??
                                  '',
                              textColor: AppColors.textColor,
                              textSize: width * 0.038,
                            ),
                            const SizedBox(height: 5),
                            CommonText(
                              content: NotificationController
                                      .to.notificationList[index]?['message'] ??
                                  '',
                              textColor: AppColors.textColor,
                              textSize: width * 0.037,
                            ),
                            const SizedBox(height: 5),
                            CommonText(
                              content: (NotificationController
                                                  .to.notificationList[index]
                                              ?['createdAt'] ??
                                          '') !=
                                      ''
                                  ? '${NotificationController.to.notificationList[index]?['createdAt'] ?? ''}'
                                  : '',
                              textColor: AppColors.textColor,
                              textSize: width * 0.03,
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }),
        ),
        Obx(() {
          return isLoadingMore.value
              ? CupertinoActivityIndicator(
                  color: AppColors.primaryColor,
                )
              : SizedBox();
        }),
        Obx(() {
          return isLoadingMore.value
              ? SizedBox(
                  height: 20,
                )
              : SizedBox();
        })
      ],
    );
  }
}
