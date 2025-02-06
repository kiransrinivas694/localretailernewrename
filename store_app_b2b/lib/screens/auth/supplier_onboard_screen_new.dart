import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/supplier_onboard_controller_new.dart';
import 'package:store_app_b2b/model/supplier_list_response/supplier_list_response_new.dart';

class SupplierOnboardScreen extends StatelessWidget {
  SupplierOnboardScreen({super.key, required this.retailerId});

  final String retailerId;

  final SupplierOnboardController controller =
      Get.put(SupplierOnboardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierOnboardController>(initState: (state) {
      controller.supplierListCurrentPage.value = 0;
      controller.supplierListTotalPages.value = 0;
      controller.getSupplierList();
    }, builder: (context) {
      print('print retailer id ${retailerId} ${controller.supplierList}');
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
                content: 'Choose Supplier', boldNess: FontWeight.w500),
            automaticallyImplyLeading: false,
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
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 26),
                        child: GestureDetector(
                          onTap: () {
                            // controller.selectedSupplierId.value = "";
                            // controller.getSupplierList();
                          },
                          child: Text(
                            "Choose a supplier to proceed with the onboarding process.",
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        child: Obx(
                          () => CommonSearchField(
                            hintText: "Search for suppliers",
                            showCloseIcon: controller
                                .showSuffixForSeachServiceProductController
                                .value,
                            closeOnTap: () {
                              controller.supplierSearchController.text = "";
                              controller.supplierListCurrentPage.value = 0;
                              controller.supplierListPageSize.value = 10;
                              controller.supplierListTotalPages.value = 0;
                              controller.getSupplierList(searchText: "");

                              controller
                                  .showSuffixForSeachServiceProductController
                                  .value = false;
                              controller.selectedSupplierId.value = "";
                            },
                            controller: controller.supplierSearchController,
                            onChanged: (String value) {
                              controller.supplierListCurrentPage.value = 0;
                              controller.supplierListPageSize.value = 10;
                              controller.supplierListTotalPages.value = 0;
                              controller.getSupplierList(searchText: value);
                              controller
                                  .showSuffixForSeachServiceProductController
                                  .value = value.isNotEmpty;
                              controller.selectedSupplierId.value = "";
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          child: Obx(
                            () => controller.isSupplierListLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : controller.supplierList.length == 0
                                    ? Center(
                                        child: CommonText(
                                          content: "Suppliers Not Found",
                                          textColor: Colors.black,
                                        ),
                                      )
                                    : NotificationListener<ScrollNotification>(
                                        onNotification: (notification) {
                                          if (notification
                                                  is ScrollEndNotification &&
                                              notification
                                                      .metrics.extentAfter ==
                                                  0) {
                                            if (controller
                                                    .isSupplierMoreListLoading
                                                    .value ||
                                                controller.isSupplierListLoading
                                                    .value) {
                                              return false;
                                            }

                                            controller.getSupplierList(
                                              loadMore: true,
                                              searchText: controller
                                                  .supplierSearchController
                                                  .text,
                                            );
                                          }
                                          return false;
                                        },
                                        child: ListView.separated(
                                          itemCount:
                                              controller.supplierList.length,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          itemBuilder: (context, index) {
                                            SupplierDetail supplier =
                                                controller.supplierList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                controller.selectedSupplierId
                                                    .value = supplier.id ?? '';
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Color.fromRGBO(
                                                            157, 157, 157, 1),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                supplier.storeName ??
                                                                    '',
                                                                style: GoogleFonts.roboto(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              if (supplier
                                                                      .storeNumber !=
                                                                  null)
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              if (supplier
                                                                      .storeNumber !=
                                                                  null)
                                                                Text(
                                                                  supplier.storeNumber ??
                                                                      '',
                                                                  style: GoogleFonts.roboto(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              84,
                                                                              84,
                                                                              84,
                                                                              1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
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
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  supplier
                                                                          .storeAddressDetailRequest![
                                                                              0]
                                                                          .addressLine1 ??
                                                                      '',
                                                                  style: GoogleFonts.roboto(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              84,
                                                                              84,
                                                                              84,
                                                                              1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ]
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Obx(
                                                          () => Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 14,
                                                                    right: 10),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: controller.selectedSupplierId.value ==
                                                                            supplier
                                                                                .id
                                                                        ? Color.fromRGBO(
                                                                            253,
                                                                            140,
                                                                            32,
                                                                            1)
                                                                        : Color.fromRGBO(
                                                                            30,
                                                                            30,
                                                                            30,
                                                                            1))),
                                                            height: 20,
                                                            width: 20,
                                                            child: Obx(
                                                              () => Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: controller.selectedSupplierId.value ==
                                                                            supplier
                                                                                .id
                                                                        ? Color.fromRGBO(
                                                                            253,
                                                                            140,
                                                                            32,
                                                                            1)
                                                                        : Colors
                                                                            .transparent),
                                                                height: 6,
                                                                width: 6,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
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
                      Obx(
                        () => controller.selectedSupplierId.value.isEmpty
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  controller.onboardSupplierPost(
                                      retailerId: retailerId);
                                },
                                child: Container(
                                  width: 170,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 16),
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     Color(0xff2F394B),
                                      //     Color(0xff090F1A),
                                      //   ],
                                      // ),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Color.fromRGBO(253, 140, 32, 1)),
                                  child: Center(
                                    child: CommonText(
                                      content: "Link Supplier",
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                Obx(
                  () => controller.isOnboarSupplierLoading.value
                      ? Positioned.fill(
                          child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black38,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ))
                      : SizedBox(),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
