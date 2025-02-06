import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/network_retailer_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_buy_controller.dart';
import 'package:store_app_b2b/model/network_retailer/network_retailer_response.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_module/expiry_products_info_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/material_wrap_product_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_store_profile_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class NrRequestsTab extends StatelessWidget {
  NrRequestsTab({super.key});

  final NetworkRetailerController controller =
      Get.put(NetworkRetailerController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkRetailerController>(builder: (_) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Obx(
                () => CommonSearchField(
                  hintText: "Search for retailer store name",
                  showCloseIcon: controller
                      .showSuffixForRequestREtailerSearchController.value,
                  closeOnTap: () {
                    controller.requestRetailerSearchController.text = "";
                    controller.networkRetailerRequestListCurrentPage.value = 0;
                    controller.networkRetailerRequestListPageSize.value = 10;
                    controller.networkRetailerRequestListTotalPages.value = 0;
                    controller.getRequestNetworkRetailerList(searchText: "");

                    controller.showSuffixForRequestREtailerSearchController
                        .value = false;
                  },
                  controller: controller.requestRetailerSearchController,
                  onChanged: (String value) {
                    controller.networkRetailerRequestListCurrentPage.value = 0;
                    controller.networkRetailerRequestListPageSize.value = 10;
                    controller.networkRetailerRequestListTotalPages.value = 0;
                    controller.getRequestNetworkRetailerList(searchText: value);
                    controller.showSuffixForRequestREtailerSearchController
                        .value = value.isNotEmpty;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Obx(
                  () => controller.isNetworkRetailerRequestListLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.networkRetailerRequestList.isEmpty
                          ? Center(
                              child: CommonText(
                                content: "No Requests Found",
                                textColor: Colors.black,
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification &&
                                    notification.metrics.extentAfter == 0) {
                                  if (controller
                                          .isNetworkRetailerRequestListLoading
                                          .value ||
                                      controller
                                          .isNetworkRetailerMoreRequestListLoading
                                          .value) {
                                    return false;
                                  }

                                  controller.getRequestNetworkRetailerList(
                                    loadMore: true,
                                    searchText: controller
                                        .requestRetailerSearchController.text,
                                  );
                                }
                                return false;
                              },
                              child: ListView.separated(
                                itemCount: controller
                                    .networkRetailerRequestList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 3),
                                itemBuilder: (context, index) {
                                  NetworkRetailerSingleItem supplier =
                                      controller
                                          .networkRetailerRequestList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => NrStoreProfileScreen(
                                            retailerId: supplier.id ?? "",
                                          ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0,
                                                  0.25), // RGBA color for shadow
                                              offset: Offset(0,
                                                  1), // Horizontal and vertical offset
                                              blurRadius: 4, // Blur radius
                                              spreadRadius: 0, // Spread radius
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (supplier.imageUrl != null &&
                                                    supplier.imageUrl!
                                                            .profileImageId !=
                                                        null)
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: AppImageAsset(
                                                        image: supplier
                                                                .imageUrl!
                                                                .profileImageId ??
                                                            '',
                                                        // height: 60,
                                                        // width: 60,
                                                        width: 20.w,
                                                        height: 20.w,
                                                      ),
                                                    ),
                                                  ),
                                                Gap(10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        supplier.storeName ??
                                                            '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts
                                                            .poppins(
                                                                fontSize: 14.sp,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      if (supplier
                                                              .storeNumber !=
                                                          null)
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                      if (supplier
                                                              .storeNumber !=
                                                          null)
                                                        Text(
                                                          supplier.storeNumber ==
                                                                  null
                                                              ? ""
                                                              : "Mobile : ${supplier.storeNumber}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          84,
                                                                          84,
                                                                          84,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      if (supplier.storeAddressDetailRequest !=
                                                              null &&
                                                          supplier
                                                              .storeAddressDetailRequest!
                                                              .isNotEmpty &&
                                                          supplier
                                                                  .storeAddressDetailRequest![
                                                                      0]
                                                                  .addressLine1 !=
                                                              null) ...[
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          supplier
                                                                  .storeAddressDetailRequest![
                                                                      0]
                                                                  .addressLine1 ??
                                                              '',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          84,
                                                                          84,
                                                                          84,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                                Gap(20),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: supplier
                                                                .distance ==
                                                            null
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (supplier.distance !=
                                                          null) ...[
                                                        Image.asset(
                                                          "assets/image/map_address_path.png",
                                                          width: 20,
                                                          height: 20,
                                                          package:
                                                              'store_app_b2b',
                                                          fit: BoxFit.cover,
                                                        ),
                                                        // CommonText(
                                                        //   content: "Distance",
                                                        //   boldNess:
                                                        //       FontWeight.w500,
                                                        //   textSize: 14,
                                                        //   textColor: AppColors
                                                        //       .appblack,
                                                        // ),
                                                        CommonText(
                                                          content:
                                                              "${supplier.distance != null ? supplier.distance!.toStringAsFixed(2) : ""} KM",
                                                          boldNess:
                                                              FontWeight.w400,
                                                          textSize: 14.sp,
                                                          textColor: AppColors
                                                              .appblack,
                                                        ),
                                                      ],
                                                      // GestureDetector(
                                                      //   onTap: () {
                                                      //     showDialog(
                                                      //       context: context,
                                                      //       barrierDismissible:
                                                      //           true,
                                                      //       useRootNavigator: false,
                                                      //       builder: (context) {
                                                      //         return retailerLinkConfirmPopup(
                                                      //             context,
                                                      //             linkRetailerId:
                                                      //                 supplier.id ??
                                                      //                     '');
                                                      //       },
                                                      //     );
                                                      //   },
                                                      //   child: Container(
                                                      //     padding:
                                                      //         EdgeInsets.symmetric(
                                                      //             vertical: 4,
                                                      //             horizontal: 10),
                                                      //     decoration: BoxDecoration(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(4),
                                                      //       gradient:
                                                      //           LinearGradient(
                                                      //         begin: Alignment
                                                      //             .topCenter,
                                                      //         end: Alignment
                                                      //             .bottomCenter,
                                                      //         colors: [
                                                      //           Color(0xff2F394B),
                                                      //           Color(0xff090F1A),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     child: Center(
                                                      //       child: CommonText(
                                                      //           textSize: 14,
                                                      //           content:
                                                      //               "Disconnect"),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Gap(10),
                                          Row(
                                            children: [
                                              Expanded(child: SizedBox()),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .linkNetworkRetailer(
                                                            linkRetailerId:
                                                                supplier.id ??
                                                                    '',
                                                            isPostMethod: false,
                                                            status: "Y");

                                                    // showDialog(
                                                    //   context: context,
                                                    //   barrierDismissible: true,
                                                    //   useRootNavigator: false,
                                                    //   builder: (context) {
                                                    //     return retailerLinkConfirmPopup(
                                                    //         context,
                                                    //         linkRetailerId:
                                                    //             supplier.id ?? '');
                                                    //   },
                                                    // );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        // gradient: LinearGradient(
                                                        //   begin: Alignment.topCenter,
                                                        //   end: Alignment.bottomCenter,
                                                        //   colors: [
                                                        //     Color(0xff2F394B),
                                                        //     Color(0xff090F1A),
                                                        //   ],
                                                        // ),
                                                        color: Colors.green),
                                                    child: Center(
                                                      child: CommonText(
                                                          textSize: 13,
                                                          content: "Accept"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Gap(10),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      useRootNavigator: false,
                                                      builder: (context) {
                                                        return retailerLinkConfirmPopup(
                                                            context,
                                                            linkRetailerId:
                                                                supplier.id ??
                                                                    '',
                                                            status: "N");
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        // gradient: LinearGradient(
                                                        //   begin: Alignment.topCenter,
                                                        //   end: Alignment.bottomCenter,
                                                        //   colors: [
                                                        //     Color(0xff2F394B),
                                                        //     Color(0xff090F1A),
                                                        //   ],
                                                        // ),
                                                        color: Colors.red),
                                                    child: Center(
                                                      child: CommonText(
                                                          textSize: 13,
                                                          content: "Reject"),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                // shrinkWrap: true,
                              ),
                            ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  Widget retailerLinkConfirmPopup(BuildContext,
      {required String linkRetailerId, String? status}) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 90.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Gap(40),
            // Image.asset(
            //   "assets/image/grb_pop.png",
            //   package: 'store_app_b2b',
            // ),
            const Gap(20),
            const CommonText(
              content: "Are you sure ?",
              textColor: Color.fromRGBO(255, 139, 3, 1),
              textAlign: TextAlign.center,
              boldNess: FontWeight.w700,
              textSize: 16,
            ),
            const Gap(15),
            const CommonText(
              content: "Are you sure you want to reject this store?",
              textColor: Colors.black,
              textAlign: TextAlign.center,
              textSize: 14,
              boldNess: FontWeight.w400,
            ),
            const Gap(23),
            Obx(
              () => controller.isLinkRetailerLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 35.w,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: CommonText(
                                content: "Cancel",
                                textColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.linkNetworkRetailer(
                                linkRetailerId: linkRetailerId,
                                isUnlink: true,
                                isPostMethod: true,
                                status: "N");
                          },
                          child: Container(
                            width: 35.w,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: const CommonText(content: "Confirm")),
                          ),
                        ),
                      ],
                    ),
            ),
            // if (showContinue)

            // if (showContinue)
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
