import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/notification_controller_new.dart';
import 'package:store_app_b2b/model/get_notification_response_model_new.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      initState: (state) {
        Future.delayed(
          Duration(milliseconds: 200),
          () {
            NotificationController controller =
                Get.find<NotificationController>();
            controller.getNotificationListApi(
                page: controller.page, size: controller.size);
            controller.scrollController.addListener(controller.scrollListener);
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: "Notification",
              boldNess: FontWeight.w600,
              textSize: width * 0.047,
            ),
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2F394B),
                    Color(0xff090F1A),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: ColorsConst.greyBgColor,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (controller.notificationResponseModel.content.isEmpty)
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image/no_notification.png',
                                package: 'store_app_b2b',
                                fit: BoxFit.cover,
                                scale: 4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: CommonText(
                                    content: 'You have no Notifications',
                                    textColor: ColorsConst.greyByTextColor,
                                    boldNess: FontWeight.w400,
                                    textSize: 24,
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller
                                .notificationResponseModel.content.length,
                            itemBuilder: (context, index) {
                              Content notificationModel = controller
                                  .notificationResponseModel.content[index];
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
                                      content:
                                          "${notificationModel.title}. ${notificationModel.message}",
                                      textColor:
                                          ColorsConst.notificationTextColor,
                                      textSize: width * 0.037,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText(
                                          content:
                                              '${DateFormat('dd MMM yy, hh:mm a').format(DateTime.parse('${notificationModel.createdAt}'))}',
                                          //content: "20 July 22, 10:24 AM",
                                          textColor:
                                              ColorsConst.notificationTextColor,
                                          textSize: width * 0.03,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              controller.deleteNotificationApi(
                                                  notificationModel.id ?? ''),
                                          child: Image.asset(
                                            'assets/icons/delete_icon.png',
                                            scale: 4,
                                            package: 'store_app_b2b',
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  (controller.isLoadingMore)
                      ? CupertinoActivityIndicator(
                          color: ColorsConst.primaryColor,
                        )
                      : SizedBox()
                ],
              ),
              (controller.isLoading) ? AppLoader() : SizedBox()
            ],
          ),
        );
      },
    );
  }
}
