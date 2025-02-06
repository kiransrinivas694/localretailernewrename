import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/controllers/confirm_order_controller_new.dart';
import 'package:store_app_b2b/widget/dotted_seperator_new.dart';

class ConfirmOrdersScreen extends StatelessWidget {
  const ConfirmOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmOrderController>(
      init: ConfirmOrderController(),
      initState: (state) {
        ConfirmOrderController confirmOrderController =
            Get.put(ConfirmOrderController());
        confirmOrderController.getInternalPopupInside();
      },
      builder: (controller) {
        print(
            "printing confirm orders length ---> ${controller.internalPopUpResponseModel.length}");
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: CommonText(
                  content: 'Confirm Pending Orders',
                  boldNess: FontWeight.w600,
                  textSize: 14,
                ),

                elevation: 0,
                // leading: IconButton(
                //   onPressed: () {
                //     Get.back();
                //   },
                //   icon: const Icon(Icons.arrow_back_rounded),
                // ),
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
              backgroundColor: Colors.grey[300],
              body: controller.isConfirmationScreenLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 20,
                          color: AppColors.appblack),
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      // color: Colors.red,
                      child: ListView.builder(
                        itemCount: controller.internalPopUpResponseModel.length,
                        itemBuilder: (context, index) {
                          String formattedDatetime = "";
                          if (controller.internalPopUpResponseModel[index]
                                      .orderDate !=
                                  null &&
                              controller.internalPopUpResponseModel[index]
                                  .orderDate!.isNotEmpty) {
                            DateTime inputDatetime = DateTime.parse(controller
                                .internalPopUpResponseModel[index].orderDate!);

                            formattedDatetime =
                                DateFormat("hh:mm a - dd-MM-yyyy")
                                    .format(inputDatetime);
                          }

                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 18),
                            // height: 20,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.semiGreyColor.withOpacity(0.8),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // CommonText(
                                //     content: controller
                                //             .internalPopUpResponseModel[index]
                                //             .orderId ??
                                //         ""),
                                Row(
                                  children: [
                                    CommonText(
                                      content: "Order ID: ",
                                      textColor: Color.fromRGBO(85, 85, 85, 1),
                                      boldNess: FontWeight.w600,
                                      textSize: 15,
                                    ),
                                    CommonText(
                                      content: controller
                                              .internalPopUpResponseModel[index]
                                              .orderId ??
                                          "",
                                      boldNess: FontWeight.w600,
                                      textSize: 15,
                                      textColor: Color.fromRGBO(255, 122, 0, 1),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      content: formattedDatetime,
                                      textColor: Color.fromRGBO(85, 85, 85, 1),
                                      boldNess: FontWeight.w500,
                                      textSize: 12,
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        content:
                                            "₹${controller.internalPopUpResponseModel[index].orderAmount.toString()}",
                                        boldNess: FontWeight.w600,
                                        textSize: 15,
                                        textAlign: TextAlign.right,
                                        textColor:
                                            Color.fromRGBO(255, 122, 0, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                // CommonText(
                                //   content: "Have you received the order?",
                                //   textColor: Colors.black,
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                DottedSeperator(),
                                SizedBox(
                                  height: 10,
                                ),
                                CommonText(
                                  content: "Received Order ? ",
                                  textColor: Color.fromRGBO(85, 85, 85, 1),
                                  boldNess: FontWeight.w600,
                                  textSize: 15,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                controller.isYesOrNoLoading
                                    ? Container(
                                        width: double.infinity,
                                        height: 20,
                                        child: Center(
                                          child: CupertinoActivityIndicator(
                                              animating: true,
                                              radius: 10,
                                              color: Colors.black),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          // Container(
                                          //   child: Center(
                                          //     child: CommonText(
                                          //       content: "Yes",
                                          //       textColor: Colors.black,
                                          //     ),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   child: Center(
                                          //     child: CommonText(
                                          //       content: "No",
                                          //       textColor: Colors.black,
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  controller.updateInternalPopup(
                                                      orderId: controller
                                                              .internalPopUpResponseModel[
                                                                  index]
                                                              .orderId ??
                                                          '',
                                                      id: controller
                                                              .internalPopUpResponseModel[
                                                                  index]
                                                              .id ??
                                                          '',
                                                      value: 'Y');
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color.fromRGBO(
                                                            30, 170, 36, 1),
                                                        Color.fromRGBO(
                                                            21, 116, 25, 1),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: CommonText(
                                                      content: "Yes",
                                                      textColor: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  controller.updateInternalPopup(
                                                      orderId: controller
                                                              .internalPopUpResponseModel[
                                                                  index]
                                                              .orderId ??
                                                          "",
                                                      id: controller
                                                              .internalPopUpResponseModel[
                                                                  index]
                                                              .id ??
                                                          '',
                                                      value: 'N');
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Color.fromRGBO(
                                                            255, 0, 0, 1),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: CommonText(
                                                      content: "No",
                                                      boldNess: FontWeight.w600,
                                                      textSize: 15,
                                                      textColor: Color.fromRGBO(
                                                          255, 0, 0, 1),
                                                    ),
                                                  ),
                                                )),
                                          )
                                        ],
                                      )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
