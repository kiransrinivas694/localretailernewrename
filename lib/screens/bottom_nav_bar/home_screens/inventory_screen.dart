import 'dart:developer';

import 'package:b2c/components/common_primary_button.dart';
import 'package:b2c/components/update_inventory_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/screens/bottom_nav_bar/home_screens/inventory_detail_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/components/inventory_dialog.dart';
import 'package:b2c/components/sub_category_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bottom_controller/invetory_controller/inventory_controller.dart';
import 'package:b2c/widget/inventory_tab.dart';

import 'controller/enable_disable_product.dart';
import 'controller/get_inventory_status_controller.dart';
import 'controller/inventory_controller.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  ScrollController scrollController = ScrollController();

  InventoryController inventoryController = Get.put(InventoryController());

  RxInt selectedIndex = 0.obs;
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('DELIVERY IN PROGRESS ORDER TAB INIT');
    InventoryListController.to.todaysDealList.clear();
    InventoryListController.to.inventoryList.clear();
    InventoryListController.to.getCategoriesApi();
    GetInventoryStatusController.to.getInventoryStatusAPi();
    InventoryListController.to.inventoryListApi(
      queryParameters: {
        "page": page.value,
        "size": 10,
        "categoryId": GetHelperController.categoryID.value,
      },
    );
    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Get.dialog(UnlistedSoonDialog());
    });

    super.initState();
  }

  Future<void> _scrollListener() async {
    if (selectedIndex.value == 0) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        page.value = page.value + 1;
        log(
          page.value.toString(),
          name: "PAGE CHANGE",
        );
        await InventoryListController.to.inventoryListApi(
          queryParameters: {
            "page": page.value,
            "size": 10,
            "categoryId": GetHelperController.categoryID.value,
          },
        );

        isLoadingMore.value = false;
      }
    } else if (selectedIndex.value == 1) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        page.value = page.value + 1;
        log(
          page.value.toString(),
          name: "PAGE CHANGE",
        );
        await InventoryListController.to.todaysDealListApi(
          queryParameters: {"page": page.value, "size": 10},
        );

        isLoadingMore.value = false;
      }
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        page.value = page.value + 1;
        log(
          page.value.toString(),
          name: "PAGE CHANGE",
        );
        await InventoryListController.to.inventoryListApi(
          queryParameters: {
            "page": page.value,
            "size": 10,
            "categoryId": GetHelperController.categoryID.value,
          },
        );

        isLoadingMore.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: double.infinity,
      width: double.infinity,
    );

    return GetBuilder<InventoryController>(
      init: InventoryController(),
      builder: (inventoryController) => Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Column(
          children: [
            DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    controller: inventoryController.controller,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 5,
                    indicator: const MD2Indicator(
                      indicatorSize: MD2IndicatorSize.normal,
                      indicatorHeight: 3.0,
                      indicatorColor: Colors.orange,
                    ),
                    onTap: (value) {
                      selectedIndex.value = value;
                      InventoryListController.to.todaysDealRes.clear();
                      InventoryListController.to.inventoryRes.clear();
                      log(value.toString());
                      if (value == 0) {
                        InventoryListController.to.inventoryList.clear();
                        page.value = 0;
                        InventoryListController.to.inventoryListApi(
                          queryParameters: {
                            "page": page.value,
                            "size": 10,
                            "categoryId": GetHelperController.categoryID.value,
                          },
                        );
                      } else if (value == 1) {
                        InventoryListController.to.todaysDealList.clear();
                        page.value = 0;
                        InventoryListController.to.todaysDealListApi(
                          queryParameters: {"page": page.value, "size": 10},
                        );
                      } else {
                        InventoryListController.to.inventoryList.clear();
                        page.value = 0;
                        InventoryListController.to.inventoryListApi(
                          queryParameters: {
                            "page": page.value,
                            "size": 10,
                            "categoryId": GetHelperController.categoryID.value,
                          },
                        );
                      }
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    tabs: const [
                      Tab(
                        child: CommonText(
                          content: "Inventory",
                          textColor: Colors.black,
                          boldNess: FontWeight.w600,
                        ),
                      ),
                      Tab(
                        child: CommonText(
                          content: "Today's Deal",
                          textColor: Colors.black,
                          boldNess: FontWeight.w600,
                        ),
                      ),
                      Tab(
                        child: CommonText(
                          content: "Update Price",
                          textColor: Colors.black,
                          boldNess: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: inventoryController.controller,
                children: [
                  inventoryView(height, width, inventoryController),
                  todaysDealTabView(height, inventoryController, width),
                  updatePriceView(height, width),
                ],
              ),
            ),
            Obx(() {
              return isLoadingMore.value
                  ? SizedBox(
                      height: 20,
                    )
                  : SizedBox();
            })
          ],
        ),
      ),
    );
  }

  Padding updatePriceView(double height, double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          /*SizedBox(height: height * 0.02),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CommonText(
                                    textSize: width * 0.045,
                                    content:
                                    "${GetInventoryStatusController.to.getInventoryStatusRes['totalCategories'] ?? 0}",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  // SizedBox(height: height * 0.01),
                                  CommonText(
                                    textSize: width * 0.035,
                                    content: "Categories ",
                                    textColor: const Color(0xff8B8888),
                                    // boldNess: FontWeight.w600,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CommonText(
                                    textSize: width * 0.045,
                                    content:
                                    "${GetInventoryStatusController.to.getInventoryStatusRes['totalItems'] ?? 0}",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  // SizedBox(height: height * 0.01),
                                  CommonText(
                                    textSize: width * 0.035,
                                    content: "Items",
                                    textColor: const Color(0xff8B8888),
                                    // boldNess: FontWeight.w600,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CommonText(
                                    textSize: width * 0.045,
                                    content:
                                    "${GetInventoryStatusController.to.getInventoryStatusRes['totalDiscountItems'] ?? 0}",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  // SizedBox(height: height * 0.01),
                                  CommonText(
                                    textSize: width * 0.035,
                                    textAlign: TextAlign.center,
                                    content: "Discounted\nItems",
                                    textColor: const Color(0xff8B8888),
                                    // boldNess: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CommonText(
                                    textSize: width * 0.045,
                                    content:
                                    "${GetInventoryStatusController.to.getInventoryStatusRes['outOfStock'] ?? 0}",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  // SizedBox(height: height * 0.01),
                                  CommonText(
                                    textSize: width * 0.035,
                                    content: "Out of Stock ",
                                    textColor: const Color(0xff8B8888),
                                    // boldNess: FontWeight.w600,
                                  )
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                SubCategoryDialog(
                                  controller: inventoryController,
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText(
                                      content: "Sub-Category",
                                      textSize: width * 0.035,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Expanded(
                            child: CommonSearchField(
                              controller: inventoryController.searchController,
                              onChanged: (val) {
                                if (inventoryController.searchController.text.isEmpty) {
                                  InventoryListController.to.inventoryList.clear();
                                  InventoryListController.to.inventoryListApi(
                                    queryParameters: {
                                      "page": page.value,
                                      "size": 10,
                                      "categoryId": GetHelperController.categoryID.value,
                                    },
                                  );
                                } else {
                                  InventoryListController.to.inventoryList.clear();
                                  InventoryListController.to.inventoryListApi(
                                    queryParameters: {
                                      "productName":
                                      inventoryController.searchController.text,
                                      "categoryId": GetHelperController.categoryID.value,
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),*/
          SizedBox(height: height * 0.02),
          CommonSearchField(
            controller: inventoryController.searchController,
            onChanged: (val) {
              if (inventoryController.searchController.text.isEmpty) {
                InventoryListController.to.inventoryList.clear();
                InventoryListController.to.inventoryListApi(
                  queryParameters: {
                    "page": page.value,
                    "size": 10,
                    "categoryId": GetHelperController.categoryID.value,
                  },
                );
              } else {
                InventoryListController.to.inventoryList.clear();
                InventoryListController.to.inventoryListApi(
                  queryParameters: {
                    "productName": inventoryController.searchController.text,
                    "categoryId": GetHelperController.categoryID.value,
                  },
                );
              }
            },
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Obx(() {
              return InventoryListController.to.inventoryRes.isEmpty
                  ? CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    )
                  : ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          InventoryListController.to.inventoryList.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (InventoryListController.to.inventoryList[index]
                                              ['imageIds']?[0]?["imageId"] ??
                                          "") ==
                                      ""
                                  ? SizedBox()
                                  : Image.network(
                                      InventoryListController
                                                  .to.inventoryList[index]
                                              ['imageIds']?[0]?["imageId"] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTOkHm3_mPQ5PPRvGtU6Si7FJg8DVDtZ47rw&usqp=CAU',
                                      height: height * 0.1,
                                      width: width * 0.25,
                                    ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      content: InventoryListController
                                                  .to.inventoryList[index]
                                              ['productName'] ??
                                          '--',
                                      boldNess: FontWeight.w500,
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                "MRP : ₹${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['mrp'] ?? '--'}",
                                            textColor: AppColors.textColor,
                                            textSize: width * 0.035,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                "PTR : ₹${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['ptr'] ?? '--'}",
                                            textColor: AppColors.textColor,
                                            textSize: width * 0.035,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CommonText(
                                      content:
                                          "Discount : ${(InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['discountType'] ?? '%') != '%' ? "₹" : ''}${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['discount'] ?? '0'}${(InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['discountType'] ?? '%') == '%' ? "%" : ''}",
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content: "Discount Value: ₹" +
                                          '${(double.parse((InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['mrp'] ?? '0').toString()) - double.parse((InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['price'] ?? '0').toString())).toStringAsFixed(2)}',
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content:
                                          "Final Selling Price : ₹${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['price'] ?? '--'}",
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content:
                                          "Start Date : ${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['startDate'] ?? '--'}",
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content:
                                          "End Date : ${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['endDate'] ?? '--'}",
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.dialog(UpdateInventoryDialog(
                                    productID: InventoryListController
                                        .to.inventoryList[index]['id'],
                                    title: InventoryListController
                                                .to.inventoryList[index]
                                            ['productName'] ??
                                        '--',
                                    type: InventoryListController.to
                                            .inventoryList[index]['category'] ??
                                        '--',
                                    startDate: (InventoryListController
                                                        .to.inventoryList[index]
                                                    ['price'][
                                                GetHelperController.storeID
                                                    .value]['startDate'] ??
                                            '')
                                        .toString(),
                                    endDate: (InventoryListController
                                                        .to.inventoryList[index]
                                                    ['price'][
                                                GetHelperController.storeID
                                                    .value]['endDate'] ??
                                            '')
                                        .toString(),
                                    mrp: InventoryListController
                                        .to.inventoryList[index]['mrp']
                                        .toString(),
                                    ptr: InventoryListController
                                        .to.inventoryList[index]['ptr']
                                        .toString(),
                                    discount: (InventoryListController
                                                        .to.inventoryList[index]
                                                    ['price'][
                                                GetHelperController.storeID
                                                    .value]['discount'] ??
                                            '0')
                                        .toString(),
                                    disValue: (double.parse((InventoryListController
                                                                .to
                                                                .inventoryList[index]['price']
                                                            [GetHelperController.storeID.value]
                                                        ['mrp'] ??
                                                    '0')
                                                .toString()) -
                                            double.parse((InventoryListController
                                                            .to
                                                            .inventoryList[index]['price']
                                                        [GetHelperController.storeID.value]['price'] ??
                                                    '0')
                                                .toString()))
                                        .toStringAsFixed(2),
                                    disType: (InventoryListController
                                                            .to.inventoryList[
                                                        index]['price'][
                                                    GetHelperController.storeID
                                                        .value]['discountType'] ??
                                                '%') ==
                                            '%'
                                        ? 'PER'
                                        : 'RS',
                                    finalValue: (InventoryListController
                                                        .to.inventoryList[index]
                                                    ['price'][
                                                GetHelperController
                                                    .storeID.value]['price'] ??
                                            '')
                                        .toString(),
                                  ));
                                },
                                child: Image.asset(
                                  "assets/icons/edit.png",
                                  scale: 3.5,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    );
            }),
          ),
          Obx(() {
            return isLoadingMore.value
                ? CupertinoActivityIndicator(
                    color: AppColors.primaryColor,
                  )
                : SizedBox();
          })
        ],
      ),
    );
  }

  Padding todaysDealTabView(
      double height, InventoryController inventoryController, double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(height: height * 0.02),
          CommonSearchField(controller: inventoryController.searchController),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Obx(() {
              return InventoryListController.to.todaysDealRes.isEmpty
                  ? CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    )
                  : ListView.builder(
                      itemCount:
                          InventoryListController.to.todaysDealList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/tata.png",
                                scale: 4,
                              ),
                              SizedBox(width: width * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content:
                                        '${InventoryListController.to.todaysDealList[index]['productName'] ?? '--'}',
                                    boldNess: FontWeight.w500,
                                    textColor: AppColors.textColor,
                                  ),
                                  /*CommonText(
                                          content: "${ InventoryListController
                                              .to.todaysDealList[index]['description']??'--'}",
                                          textColor: AppColors.textColor,
                                        ),*/
                                  CommonText(
                                    content:
                                        "${InventoryListController.to.todaysDealList[index]['description'] ?? '--'}",
                                    textSize: width * 0.03,
                                    textColor: AppColors.hintColor,
                                  ),
                                  CommonText(
                                    content:
                                        "Max Quantity : ${InventoryListController.to.todaysDealList[index]['maxPurchaseQuantity'] ?? '--'}",
                                    boldNess: FontWeight.w500,
                                    textColor: AppColors.textColor,
                                  ),
                                  CommonText(
                                    content:
                                        "MRP: ₹${"${InventoryListController.to.todaysDealList[index]['mrp'] ?? '--'}"}",
                                    textSize: width * 0.03,
                                    textColor: AppColors.hintColor,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Obx(() {
                                return Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    trackColor: Colors.red,
                                    value: (InventoryListController.to
                                                        .todaysDealList[index]
                                                    ?['status'] ??
                                                'N') ==
                                            'N'
                                        ? false
                                        : true,
                                    onChanged: (value) {
                                      EnableDisableProductController.to
                                          .todaysDealEnableApi(
                                              productId: InventoryListController
                                                  .to
                                                  .todaysDealList[index]['id'],
                                              success: () {
                                                if ((EnableDisableProductController
                                                                .to
                                                                .todaysDealEnableRes[
                                                            'message'] ??
                                                        'N') ==
                                                    'Y') {
                                                  InventoryListController.to
                                                          .todaysDealList[index]
                                                      ?['status'] = "Y";
                                                  InventoryListController
                                                      .to.todaysDealList
                                                      .refresh();
                                                } else {
                                                  InventoryListController.to
                                                          .todaysDealList[index]
                                                      ?['status'] = "N";
                                                  InventoryListController
                                                      .to.todaysDealList
                                                      .refresh();
                                                }
                                              });
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Padding inventoryView(
      double height, double width, InventoryController inventoryController) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CommonText(
                        textSize: width * 0.045,
                        content:
                            "${GetInventoryStatusController.to.getInventoryStatusRes['totalCategories'] ?? 0}",
                        textColor: Colors.black,
                        boldNess: FontWeight.w600,
                      ),
                      // SizedBox(height: height * 0.01),
                      CommonText(
                        textSize: width * 0.035,
                        content: "Categories ",
                        textColor: const Color(0xff8B8888),
                        // boldNess: FontWeight.w600,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        textSize: width * 0.045,
                        content:
                            "${GetInventoryStatusController.to.getInventoryStatusRes['totalItems'] ?? 0}",
                        textColor: Colors.black,
                        boldNess: FontWeight.w600,
                      ),
                      // SizedBox(height: height * 0.01),
                      CommonText(
                        textSize: width * 0.035,
                        content: "Items",
                        textColor: const Color(0xff8B8888),
                        // boldNess: FontWeight.w600,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        textSize: width * 0.045,
                        content:
                            "${GetInventoryStatusController.to.getInventoryStatusRes['totalDiscountItems'] ?? 0}",
                        textColor: Colors.black,
                        boldNess: FontWeight.w600,
                      ),
                      // SizedBox(height: height * 0.01),
                      CommonText(
                        textSize: width * 0.035,
                        textAlign: TextAlign.center,
                        content: "Discounted\nItems",
                        textColor: const Color(0xff8B8888),
                        // boldNess: FontWeight.w600,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        textSize: width * 0.045,
                        content:
                            "${GetInventoryStatusController.to.getInventoryStatusRes['outOfStock'] ?? 0}",
                        textColor: Colors.black,
                        boldNess: FontWeight.w600,
                      ),
                      // SizedBox(height: height * 0.01),
                      CommonText(
                        textSize: width * 0.035,
                        content: "Out of Stock ",
                        textColor: const Color(0xff8B8888),
                        // boldNess: FontWeight.w600,
                      )
                    ],
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: height * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    SubCategoryDialog(
                      controller: inventoryController,
                    ),
                  );
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          content: "Sub-Category",
                          textSize: width * 0.035,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.02),
              Expanded(
                child: CommonSearchField(
                  controller: inventoryController.searchController,
                  onChanged: (val) {
                    if (inventoryController.searchController.text.isEmpty) {
                      InventoryListController.to.inventoryList.clear();
                      InventoryListController.to.inventoryListApi(
                        queryParameters: {
                          "page": page.value,
                          "size": 10,
                          "categoryId": GetHelperController.categoryID.value,
                        },
                      );
                    } else {
                      InventoryListController.to.inventoryList.clear();
                      InventoryListController.to.inventoryListApi(
                        queryParameters: {
                          "productName":
                              inventoryController.searchController.text,
                          "categoryId": GetHelperController.categoryID.value,
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Obx(() {
              return InventoryListController.to.inventoryRes.isEmpty
                  ? CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    )
                  : ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          InventoryListController.to.inventoryList.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (InventoryListController.to.inventoryList[index]
                                              ['imageIds']?[0]?["imageId"] ??
                                          "") ==
                                      ""
                                  ? SizedBox()
                                  : Image.network(
                                      InventoryListController
                                                  .to.inventoryList[index]
                                              ['imageIds']?[0]?["imageId"] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTOkHm3_mPQ5PPRvGtU6Si7FJg8DVDtZ47rw&usqp=CAU',
                                      height: height * 0.1,
                                      width: width * 0.25,
                                    ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      content: InventoryListController
                                                  .to.inventoryList[index]
                                              ['productName'] ??
                                          '--',
                                      boldNess: FontWeight.w500,
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content: InventoryListController
                                              .to.inventoryList[index]['sku'] ??
                                          '--',
                                      boldNess: FontWeight.w500,
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content: InventoryListController
                                                  .to.inventoryList[index]
                                              ['category'] ??
                                          '--',
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CommonText(
                                      content:
                                          "Stock : ${InventoryListController.to.inventoryList[index]['price'][GetHelperController.storeID.value]['quantity']}",
                                      textColor: AppColors.textColor,
                                      textSize: width * 0.035,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          /*Get.dialog(InventoryDialog(
                                    title: InventoryListController
                                                .to.inventoryList[index]
                                            ['productName'] ??
                                        '--',
                                    type: InventoryListController
                                                .to.inventoryList[index]
                                            ['category'] ??
                                        '--',
                                  ));*/
                                          Get.to(() => InventoryDetailScreen(
                                              inventoryDetail:
                                                  InventoryListController
                                                              .to.inventoryList[
                                                          index] ??
                                                      {}));
                                        },
                                        child: Image.asset(
                                          "assets/icons/edit.png",
                                          scale: 3.5,
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.7,
                                        child: StreamBuilder(
                                            stream: InventoryListController
                                                .to.inventoryList.stream,
                                            builder: (context, snapshot) {
                                              return CupertinoSwitch(
                                                trackColor: Colors.red,
                                                value: (InventoryListController
                                                                        .to
                                                                        .inventoryList[
                                                                    index]?['price']
                                                                [
                                                                GetHelperController
                                                                    .storeID
                                                                    .value]['isActive'] ??
                                                            'N') ==
                                                        'N'
                                                    ? false
                                                    : true,
                                                onChanged: (value) {
                                                  EnableDisableProductController
                                                      .to
                                                      .inventoryEnableApi(
                                                          productID:
                                                              InventoryListController
                                                                      .to
                                                                      .inventoryList[
                                                                  index]['id'],
                                                          success: () {
                                                            if ((EnableDisableProductController
                                                                            .to
                                                                            .inventoryEnableRes[
                                                                        'message'] ??
                                                                    'N') ==
                                                                "Y") {
                                                              InventoryListController
                                                                              .to
                                                                              .inventoryList[
                                                                          index]
                                                                      ?['price']
                                                                  [
                                                                  GetHelperController
                                                                      .storeID
                                                                      .value]['isActive'] = "Y";
                                                              InventoryListController
                                                                  .to
                                                                  .inventoryList
                                                                  .refresh();
                                                            } else {
                                                              InventoryListController
                                                                              .to
                                                                              .inventoryList[
                                                                          index]
                                                                      ?['price']
                                                                  [
                                                                  GetHelperController
                                                                      .storeID
                                                                      .value]['isActive'] = "N";
                                                              InventoryListController
                                                                  .to
                                                                  .inventoryList
                                                                  .refresh();
                                                            }
                                                          });
                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                  /*Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CommonText(
                                textSize: width * 0.03,
                                content: "Sale Price",
                                textColor: AppColors.textColor,
                              ),
                              CommonText(
                                boldNess: FontWeight.w500,
                                content: " ₹110",
                                textColor: AppColors.textBlackColor,
                                textSize: width * 0.04,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonText(
                                textSize: width * 0.032,
                                content: "MRP",
                                textColor: AppColors.textColor,
                              ),
                              CommonText(
                                boldNess: FontWeight.w500,
                                content: " ₹120",
                                textColor: AppColors.hintColor,
                                textSize: width * 0.035,
                              ),
                            ],
                          )*/
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    );
            }),
          ),
          Obx(() {
            return isLoadingMore.value
                ? CupertinoActivityIndicator(
                    color: AppColors.primaryColor,
                  )
                : SizedBox();
          })
        ],
      ),
    );
  }
}

enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class MD2Indicator extends Decoration {
  final double? indicatorHeight;
  final Color? indicatorColor;
  final MD2IndicatorSize? indicatorSize;

  const MD2Indicator(
      {this.indicatorHeight, this.indicatorColor, this.indicatorSize});

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

class _MD2Painter extends BoxPainter {
  final MD2Indicator decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    Rect rect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(16, decoration.indicatorHeight ?? 3);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor ?? const Color(0xff1967d2);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topRight: const Radius.circular(8),
            topLeft: const Radius.circular(8)),
        paint);
  }
}

class UnlistedSoonDialog extends StatelessWidget {
  const UnlistedSoonDialog({super.key, this.message = ""});

  final String message;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 3),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        content: Container(
          width: 400,
          padding: EdgeInsets.all(10),
          height: 475,
          child: Column(
            children: [
              CommonText(
                content: "Notification",
                textColor: Color.fromRGBO(255, 122, 0, 1),
                textSize: 20,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Color.fromRGBO(255, 122, 0, 1),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/image/unlisted_soon_image.png",
                width: 250,
                height: 250,
                package: 'store_app_b2b',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              CommonText(
                content:
                    '"Revamping for you! Exciting changes ahead for a better experience."',
                textColor: Color.fromRGBO(255, 122, 0, 1),
                textSize: 14,
                textAlign: TextAlign.center,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                height: 30,
              ),
              CommonPrimaryButton(
                // onTap: () => Get.offAll(() => const LoginScreen()),
                onTap: () {
                  Get.back();
                  // Get.back();
                },
                text: 'Back',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
