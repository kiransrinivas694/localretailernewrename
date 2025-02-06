import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/delivery_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/delivery_screen/delivery_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryRiderScreen extends StatelessWidget {
  const DeliveryRiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonText(
          content: "Deliver Partners",
          boldNess: FontWeight.w600,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.appGradientColor,
            ),
          ),
        ),
      ),
      body: GetBuilder<DeliveryController>(
        init: DeliveryController(),
        initState: (state) {
          Future.delayed(const Duration(microseconds: 300),
              () => Get.find<DeliveryController>().getRiders());
        },
        builder: (logic) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.semiGreyColor.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CommonText(
                            content: 'Id ',
                            boldNess: FontWeight.w600,
                            textColor: AppColors.textColor,
                            textSize: 14,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            content: ':  ',
                            boldNess: FontWeight.w600,
                            textColor: AppColors.textColor,
                            textSize: 14,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CommonText(
                              content:
                                  '${logic.content[index].employeeProfileId} ',
                              textColor: AppColors.textColor,
                              textSize: 13),
                        ),
                        const SizedBox(height: 25, width: 25),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CommonText(
                            content: 'Name',
                            textColor: AppColors.textColor,
                            textSize: 14,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            content: ':',
                            boldNess: FontWeight.w600,
                            textColor: AppColors.textColor,
                            textSize: 14,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CommonText(
                            content: '${logic.content[index].empName}',
                            textColor: AppColors.textColor,
                            textSize: 13,
                          ),
                        ),
                        const SizedBox(height: 25, width: 25),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CommonText(
                            content: 'Mob. number ',
                            textColor: AppColors.textColor,
                            textSize: 14,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            content: ':',
                            boldNess: FontWeight.w600,
                            textColor: AppColors.textColor,
                            textSize: 14,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CommonText(
                            content: '${logic.content[index].phoneNumber}',
                            textColor: AppColors.textColor,
                            textSize: 13,
                            maxLines: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              makePhoneCall(logic.content[index].phoneNumber!),
                          child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: AppColors.appblack,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call,
                                size: 15,
                                color: AppColors.appWhite,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: logic.content.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const DeliveryScreen()),
        backgroundColor: AppColors.textColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
