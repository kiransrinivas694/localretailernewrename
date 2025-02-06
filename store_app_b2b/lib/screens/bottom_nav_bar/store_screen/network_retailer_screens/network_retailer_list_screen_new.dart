import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/network_retailer_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_buy_controller_new.dart';
import 'package:store_app_b2b/model/network_retailer/network_retailer_response_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/material_wrap_product_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_all_retailer_tab_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_linked_retailer_tab_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_requests_tab_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/by_product_tab_new.dart';
import 'package:store_app_b2b/widget/verify_product_tab.dart';

class NetworkRetailerListScreen extends StatefulWidget {
  final int moveToTabIndex;

  const NetworkRetailerListScreen({
    Key? key,
    this.moveToTabIndex = 0,
  }) : super(key: key);

  @override
  State<NetworkRetailerListScreen> createState() =>
      _NetworkRetailerListScreenState();
}

class _NetworkRetailerListScreenState extends State<NetworkRetailerListScreen> {
  final NetworkRetailerController controller =
      Get.put(NetworkRetailerController());

  String storeName = '';

  @override
  void initState() {
    _initializeData();

    super.initState();
  }

  Future<void> _initializeData() async {
    getStoreName();
  }

  Future<void> getStoreName() async {
    storeName =
        await SharPreferences.getString(SharPreferences.storeName) ?? '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkRetailerController>(initState: (state) {
      controller.selectedRetailerListTab.value = widget.moveToTabIndex;

      if (widget.moveToTabIndex == 2) {
        controller.getRequestNetworkRetailerList();
      } else if (widget.moveToTabIndex == 1) {
        controller.getLinkedNetworkRetailerList();
      } else {
        controller.getNetworkRetailerList();
      }
    }, builder: (_) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: storeName,
                boldNess: FontWeight.w600,
                textSize: 14,
              ),
              automaticallyImplyLeading: true,
              leading: null,
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
            body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller.selectedRetailerListTab.value ==
                                    0) {
                                  return;
                                }

                                controller.retailerSearchController.clear();
                                controller.selectedRetailerListTab.value = 0;
                                controller.networkRetailerList.value = [];
                                controller
                                    .networkRetailerListCurrentPage.value = 0;
                                controller.networkRetailerListTotalPages.value =
                                    0;
                                controller.getNetworkRetailerList();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: controller
                                              .selectedRetailerListTab.value ==
                                          0
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: controller.selectedRetailerListTab
                                                .value !=
                                            0
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: CommonText(
                                    content: "All Retailers",
                                    textSize: 15.sp,
                                    textColor: controller
                                                .selectedRetailerListTab
                                                .value !=
                                            0
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller.selectedRetailerListTab.value ==
                                    1) {
                                  return;
                                }

                                controller.linkedRetailerSearchController
                                    .clear();
                                controller.selectedRetailerListTab.value = 1;
                                controller.networkRetailerLinkedList.value = [];
                                controller.networkRetailerLinkedListCurrentPage
                                    .value = 0;
                                controller.networkRetailerLinkedListTotalPages
                                    .value = 0;
                                controller.getLinkedNetworkRetailerList();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: controller
                                              .selectedRetailerListTab.value ==
                                          1
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: controller.selectedRetailerListTab
                                                .value !=
                                            1
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: CommonText(
                                    content: "Linked Retailers",
                                    textSize: 15.sp,
                                    textColor: controller
                                                .selectedRetailerListTab
                                                .value !=
                                            1
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller.selectedRetailerListTab.value ==
                                    2) {
                                  return;
                                }
                                controller.requestRetailerSearchController
                                    .clear();
                                controller.selectedRetailerListTab.value = 2;
                                controller.networkRetailerRequestList.value =
                                    [];
                                controller.networkRetailerRequestListCurrentPage
                                    .value = 0;
                                controller.networkRetailerRequestListTotalPages
                                    .value = 0;
                                controller.getRequestNetworkRetailerList();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: controller
                                              .selectedRetailerListTab.value ==
                                          2
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: controller.selectedRetailerListTab
                                                .value !=
                                            2
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: CommonText(
                                    content: "Requests Data",
                                    textSize: 15.sp,
                                    textColor: controller
                                                .selectedRetailerListTab
                                                .value !=
                                            2
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      Widget returnScreen = NrAllRetailerTab();

                      controller.selectedRetailerListTab.value == 0
                          ? NrAllRetailerTab()
                          : NrLinkedRetailerTab();

                      if (controller.selectedRetailerListTab.value == 1) {
                        returnScreen = NrLinkedRetailerTab();
                      } else if (controller.selectedRetailerListTab.value ==
                          2) {
                        returnScreen = NrRequestsTab();
                      }

                      return returnScreen;
                    }),
                  ),
                  // Expanded(child: NrAllRetailerTab())
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  //   child: Obx(
                  //     () => CommonSearchField(
                  //       hintText: "Search for retailer store name",
                  //       showCloseIcon:
                  //           controller.showSuffixForREtailerSearchController.value,
                  //       closeOnTap: () {
                  //         controller.retailerSearchController.text = "";
                  //         controller.networkRetailerListCurrentPage.value = 0;
                  //         controller.networkRetailerListPageSize.value = 10;
                  //         controller.networkRetailerListTotalPages.value = 0;
                  //         controller.getNetworkRetailerList(searchText: "");

                  //         controller.showSuffixForREtailerSearchController.value =
                  //             false;
                  //       },
                  //       controller: controller.retailerSearchController,
                  //       onChanged: (String value) {
                  //         controller.networkRetailerListCurrentPage.value = 0;
                  //         controller.networkRetailerListPageSize.value = 10;
                  //         controller.networkRetailerListTotalPages.value = 0;
                  //         controller.getNetworkRetailerList(searchText: value);
                  //         controller.showSuffixForREtailerSearchController.value =
                  //             value.isNotEmpty;
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     child: Obx(
                  //       () => controller.isNetworkRetailerListLoading.value
                  //           ? Center(
                  //               child: CircularProgressIndicator(),
                  //             )
                  //           : NotificationListener<ScrollNotification>(
                  //               onNotification: (notification) {
                  //                 if (notification is ScrollEndNotification &&
                  //                     notification.metrics.extentAfter == 0) {
                  //                   if (controller
                  //                           .isNetworkRetailerListLoading.value ||
                  //                       controller.isNetworkRetailerMoreListLoading
                  //                           .value) {
                  //                     return false;
                  //                   }

                  //                   controller.getNetworkRetailerList(
                  //                     loadMore: true,
                  //                     searchText:
                  //                         controller.retailerSearchController.text,
                  //                   );
                  //                 }
                  //                 return false;
                  //               },
                  //               child: ListView.separated(
                  //                 itemCount: controller.networkRetailerList.length,
                  //                 padding: EdgeInsets.symmetric(
                  //                     horizontal: 8, vertical: 3),
                  //                 itemBuilder: (context, index) {
                  //                   NetworkRetailerSingleItem supplier =
                  //                       controller.networkRetailerList[index];
                  //                   return GestureDetector(
                  //                     onTap: () {
                  //                       NrBuyController controller =
                  //                           Get.put(NrBuyController());
                  //                       controller.searchController.value.clear();
                  //                       // controller.getBuyByProductDataApi('a', categoryId: categoryId);
                  //                       controller.getBuyByProductDataApi("",
                  //                           storeIdMain: supplier.id ?? '',
                  //                           categoryId:
                  //                               supplier.storeCategoryId ?? '');

                  //                       Get.to(() => MaterialWrapProductScreen(
                  //                             storeId: supplier.id ?? '',
                  //                             storeName: supplier.storeName ?? '',
                  //                             categoryId:
                  //                                 supplier.storeCategoryId ?? "",
                  //                           ));
                  //                     },
                  //                     child: Container(
                  //                       padding: EdgeInsets.all(10),
                  //                       width: double.infinity,
                  //                       decoration: BoxDecoration(
                  //                           boxShadow: [
                  //                             BoxShadow(
                  //                               color: Color.fromRGBO(0, 0, 0,
                  //                                   0.25), // RGBA color for shadow
                  //                               offset: Offset(0,
                  //                                   1), // Horizontal and vertical offset
                  //                               blurRadius: 4, // Blur radius
                  //                               spreadRadius: 0, // Spread radius
                  //                             ),
                  //                           ],
                  //                           borderRadius: BorderRadius.circular(4),
                  //                           color: Colors.white),
                  //                       child: Column(
                  //                         children: [
                  //                           Row(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Column(
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment.start,
                  //                                   children: [
                  //                                     Text(
                  //                                       supplier.storeName ?? '',
                  //                                       style: GoogleFonts.poppins(
                  //                                           fontSize: 18,
                  //                                           color: Color.fromRGBO(
                  //                                               0, 0, 0, 1),
                  //                                           fontWeight:
                  //                                               FontWeight.w600),
                  //                                     ),
                  //                                     if (supplier.storeNumber !=
                  //                                         null)
                  //                                       SizedBox(
                  //                                         height: 4,
                  //                                       ),
                  //                                     if (supplier.storeNumber !=
                  //                                         null)
                  //                                       Text(
                  //                                         supplier.storeNumber ==
                  //                                                 null
                  //                                             ? ""
                  //                                             : "Mobile : ${supplier.storeNumber}",
                  //                                         style:
                  //                                             GoogleFonts.poppins(
                  //                                                 fontSize: 16,
                  //                                                 color:
                  //                                                     Color
                  //                                                         .fromRGBO(
                  //                                                             84,
                  //                                                             84,
                  //                                                             84,
                  //                                                             1),
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .w400),
                  //                                       ),
                  //                                     if (supplier.storeAddressDetailRequest !=
                  //                                             null &&
                  //                                         supplier
                  //                                             .storeAddressDetailRequest!
                  //                                             .isNotEmpty &&
                  //                                         supplier
                  //                                                 .storeAddressDetailRequest![
                  //                                                     0]
                  //                                                 .addressLine1 !=
                  //                                             null) ...[
                  //                                       SizedBox(
                  //                                         height: 4,
                  //                                       ),
                  //                                       Text(
                  //                                         supplier
                  //                                                 .storeAddressDetailRequest![
                  //                                                     0]
                  //                                                 .addressLine1 ??
                  //                                             '',
                  //                                         style:
                  //                                             GoogleFonts.poppins(
                  //                                                 fontSize: 14,
                  //                                                 color:
                  //                                                     Color
                  //                                                         .fromRGBO(
                  //                                                             84,
                  //                                                             84,
                  //                                                             84,
                  //                                                             1),
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .w400),
                  //                                       ),
                  //                                     ]
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //                 separatorBuilder: (context, index) {
                  //                   return SizedBox(
                  //                     height: 10,
                  //                   );
                  //                 },
                  //                 // shrinkWrap: true,
                  //               ),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  // height: 10,
                  // ),
                ],
              ),
            ),
          ),
          Obx(() => controller.isLinkRetailerLoading.value
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
              : SizedBox())
        ],
      );
    });
  }
}
