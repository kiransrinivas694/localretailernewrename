import 'dart:developer';

import 'package:b2c/components/common_search_field_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/download_invoice_screen_new.dart';
import 'package:intl/intl.dart';

import 'controller/get_customers_controller_new.dart';
import 'controller/order_detail_screen_new.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map userData;
  const UserDetailsScreen({required this.userData});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController searchController = TextEditingController();

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    GetCustomersController.to.getCustomerOrdersList.clear();
    GetCustomersController.to.getCustomerOrderRes.clear();
    log(widget.userData.toString());
    GetCustomersController.to.getCustomerOrdersApi(
      userID: widget.userData['coustomerId'],
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
      await GetCustomersController.to.getCustomerOrdersApi(
        userID: widget.userData['coustomerId'],
        queryParameters: {"page": page.value, "size": 10},
      );

      isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "Users",
          boldNess: FontWeight.w600,
          textSize: width * 0.047,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CommonText(
                  content: widget.userData['customerName'] ?? '--',
                  textColor: AppColors.textColor,
                  boldNess: FontWeight.w500,
                ),
                const Spacer(),
                Obx(() {
                  return CommonText(
                    content:
                        "Order count: ${GetCustomersController.to.getCustomerOrderRes['numberOfElements'] ?? '0'}",
                    textColor: AppColors.textColor,
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CommonText(
              content: widget.userData['customerPhoneNumber'] ?? '--',
              textColor: AppColors.textColor,
              textSize: width * 0.035,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CommonText(
              content: widget.userData['coustomerId'] ?? '--',
              textColor: AppColors.textColor,
              textSize: width * 0.035,
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CommonSearchField(
              controller: searchController,
              onChanged: (value) {
                GetCustomersController.to.getCustomerOrdersList.clear();
                log(value, name: 'value');
                if (value.isEmpty) {
                  page.value = 0;
                  GetCustomersController.to.getCustomerOrdersApi(
                    userID: widget.userData['coustomerId'],
                    queryParameters: {
                      "page": page.value,
                      "size": 10,
                    },
                  );
                  /*GetCustomersController.to.getOrderDetailApi(
                    queryParameters: {
                      "page": page.value,
                      "size": 10,
                      'phoneNumber': searchController.text
                    },
                  );*/
                } else {
                  // page.value = 0;
                  GetCustomersController.to.getCustomerOrdersApi(
                    userID: widget.userData['coustomerId'],
                    queryParameters: {'orderId': searchController.text},
                  );
                  /* GetCustomersController.to.getCustomerApi(
                    queryParameters: {
                        "page": page.value,
                      "size": 10,
                      'phoneNumber': searchController.text
                    },
                  );*/
                }
              },
            ),
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Obx(() {
              return GetCustomersController.to.getCustomerOrderRes.isEmpty
                  ? Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: List.generate(
                          GetCustomersController
                              .to.getCustomerOrdersList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => OrderDetailScreen(
                                      userID: widget.userData['coustomerId'],
                                      orderData: GetCustomersController
                                          .to.getCustomerOrdersList[index],
                                    ));
                                // Get.to(() => const DownloadInvoiceScreen());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                "${GetCustomersController.to.getCustomerOrdersList[index]['storeName']}",
                                            textColor: AppColors.textBlackColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                "${GetCustomersController.to.getCustomerOrdersList[index]['orderStatus']}",
                                            textColor: AppColors.textBlackColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.005),
                                    CommonText(
                                      content:
                                          "${GetCustomersController.to.getCustomerOrdersList[index]['orderId']}",
                                      textColor: AppColors.textBlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: height * 0.005),
                                    CommonText(
                                      content:
                                          "Delivered  ${GetCustomersController.to.getCustomerOrdersList[index]['orderDate'] != null ? DateFormat.yMMMEd().format(DateTime.parse(
                                              "${GetCustomersController.to.getCustomerOrdersList[index]['orderDate']}",
                                            )) : '-'}",
                                      textSize: width * 0.035,
                                      textColor: AppColors.textColor,
                                      boldNess: FontWeight.w600,
                                    ),
                                    SizedBox(height: height * 0.005),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText(
                                          content:
                                              "${GetCustomersController.to.getCustomerOrdersList[index]['payMode']}",
                                          textColor: AppColors.textColor,
                                          // boldNess: FontWeight.w600,
                                          textSize: width * 0.04,
                                        ),
                                        CommonText(
                                          content:
                                              " ₹ ${GetCustomersController.to.getCustomerOrdersList[index]['orderValue']}",
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w600,
                                          textSize: width * 0.04,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
