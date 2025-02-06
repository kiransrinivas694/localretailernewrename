import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_history_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_history_screens/order_details_screen.dart';
import 'package:store_app_b2b/widget/app_html_text.dart';

class UnlistedOrderTab extends StatelessWidget {
  const UnlistedOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(
      init: OrderHistoryController(),
      initState: (state) {
        Future.delayed(
          Duration(milliseconds: 150),
          () {
            OrderHistoryController controller =
                Get.find<OrderHistoryController>();
            controller.getUnlistedProduct();
          },
        );
      },
      builder: (controller) {
        return Stack(
          children: [
            (controller.unlistedProductResponseModel.content.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      color: ColorsConst.appWhite,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Divider(),
                          );
                        },
                        itemCount: controller
                            .unlistedProductResponseModel.content.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: CommonText(
                                    content:
                                        '${controller.unlistedProductResponseModel.content[index].storeName ?? ''}',
                                    textColor: ColorsConst.textColor,
                                    boldNess: FontWeight.w600,
                                    maxLines: 2,
                                    textSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  // Flexible(
                                  //     child: CommonText(
                                  //   content:
                                  //       '#${controller.unlistedProductResponseModel.content[index].orderId ?? ''}',
                                  //   textColor: ColorsConst.primaryColor,
                                  //   boldNess: FontWeight.w600,
                                  //   maxLines: 1,
                                  //   textSize: 15,
                                  //   overflow: TextOverflow.ellipsis,
                                  // )),
                                  Flexible(
                                      child: CommonText(
                                    content:
                                        '₹${num.parse('${controller.unlistedProductResponseModel.content[index].orderValue ?? '0'}').toStringAsFixed(2)}',
                                    textColor: ColorsConst.textColor,
                                    boldNess: FontWeight.w600,
                                    textAlign: TextAlign.end,
                                    maxLines: 1,
                                    textSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ],
                              ),
                              // CommonText(
                              //   content:
                              //       '${controller.unlistedProductResponseModel.content[index].orderTime ?? ''} | ${controller.unlistedProductResponseModel.content[index].supplierAddr ?? ''}',
                              //   boldNess: FontWeight.w500,
                              //   textColor: ColorsConst.greyTextColor,
                              //   textSize: 12,
                              // ),
                              CommonText(
                                content:
                                    '#${controller.unlistedProductResponseModel.content[index].orderId ?? ''}',
                                textColor: ColorsConst.primaryColor,
                                boldNess: FontWeight.w600,
                                maxLines: 1,
                                textSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CommonText(
                                content:
                                    // '${controller.unlistedProductResponseModel.content[index].orderTime ?? ''} | ${controller.unlistedProductResponseModel.content[index].supplierAddr ?? ''}',
                                    '${controller.unlistedProductResponseModel.content[index].orderTime ?? ""}',
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.greyTextColor,
                                textSize: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // RichText(
                                        //     text: TextSpan(
                                        //         text: 'Items-',
                                        //         style: GoogleFonts.poppins(
                                        //             color:
                                        //                 ColorsConst.hintColor,
                                        //             fontSize: 10,
                                        //             fontWeight:
                                        //                 FontWeight.w400),
                                        //         children: [
                                        //       TextSpan(
                                        //           text:
                                        //               '${controller.unlistedProductResponseModel.content[index].totalItems ?? ''}',
                                        //           style: GoogleFonts.poppins(
                                        //               color:
                                        //                   ColorsConst.textColor,
                                        //               fontSize: 12,
                                        //               fontWeight:
                                        //                   FontWeight.w600))
                                        //     ])),
                                        //SizedBox(width: 10),
                                        CommonText(
                                          content: 'Status: ',
                                          textColor: ColorsConst.hintColor,
                                          textSize: 10,
                                          boldNess: FontWeight.w400,
                                        ),
                                        AppHtmlText(
                                            '${controller.unlistedProductResponseModel.content[index].orderStatus ?? ''}',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.to(
                                        () => OrderDetailsScreen(),
                                        arguments: {
                                          'orderId': controller
                                                  .unlistedProductResponseModel
                                                  .content[index]
                                                  .orderId ??
                                              ''
                                        }),
                                    child: Container(
                                      height: 24,
                                      width: 71,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ColorsConst.textColor),
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: CommonText(
                                        content: 'Details',
                                        boldNess: FontWeight.w400,
                                        textSize: 12,
                                        textColor: ColorsConst.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/empty_order_history.png',
                          package: 'store_app_b2b',
                          fit: BoxFit.cover,
                          height: 258,
                        ),
                        SizedBox(height: 5),
                        CommonText(
                            content: 'Place Your First Order Now!',
                            textColor: ColorsConst.textColor,
                            textSize: 16,
                            boldNess: FontWeight.w500),
                      ],
                    ),
                  ),
            Obx(() => (controller.isLoading.value) ? AppLoader() : SizedBox())
          ],
        );
      },
    );
  }
}
