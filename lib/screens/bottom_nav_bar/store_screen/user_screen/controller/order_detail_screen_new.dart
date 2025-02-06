import 'dart:developer';

import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/controller/get_customers_controller_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/colors_const_new.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map orderData;
  final String userID;
  OrderDetailScreen({Key? key, required this.orderData, required this.userID})
      : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    log(widget.orderData.toString(), name: 'orderData');
    GetCustomersController.to.getOrderRes.clear();
    GetCustomersController.to.getOrderDetailApi(
        userID: widget.userID, orderID: widget.orderData['orderId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Container(
            margin: const EdgeInsets.only(
              top: 0,
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 6,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back,
                        size: 25, color: AppColors.textBlackColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${widget.orderData['orderId']}",
                  style: TextStyle(color: AppColors.textBlackColor),
                  /* style: semiBoldPoppins.copyWith(
                      fontSize: 3.9, color: AppColors.darkGreyColor),*/
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.appWhite,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Obx(() {
            return GetCustomersController.to.getOrderRes.isEmpty
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 5.5, left: 5.5),
                          child: CommonText(
                            content:
                                "${GetCustomersController.to.getOrderRes['storeId'] ?? '-'}",
                            boldNess: FontWeight.w500,
                            textColor: AppColors.textBlackColor,
                            textSize: 16,
                          )),
                      Container(
                        margin: const EdgeInsets.only(right: 5.5, left: 5.5),
                        child: CommonText(
                          content:
                              "${DateFormat('MMMM dd, hh:mm a').format(DateTime.parse("${GetCustomersController.to.getOrderRes['createdAt'] ?? DateTime.now()}"))}",
                          boldNess: FontWeight.w400,
                          textColor: AppColors.hintColor,
                          textSize: 14,
                        ),
                      ),
                      divider(right: 5.5, left: 5.5),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                              children: List.generate(
                                  (GetCustomersController
                                          .to.getOrderRes['items'])
                                      .length,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: width * 0.2,
                                                  width: width * 0.2,
                                                  child: Image.network(
                                                    '${GetCustomersController.to.getOrderRes['items'][index]['itemURL']}',
                                                    fit: BoxFit.cover,
                                                    height: width * 0.2,
                                                    width: width * 0.2,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content:
                                                              '${GetCustomersController.to.getOrderRes['items'][index]['productName']} \n(${GetCustomersController.to.getOrderRes['items'][index]['quantity']})',
                                                          textColor: AppColors
                                                              .textBlackColor,
                                                        ),
                                                        CommonText(
                                                          content:
                                                              'Rs. ${GetCustomersController.to.getOrderRes['items'][index]['price']}',
                                                          textColor: AppColors
                                                              .textBlackColor,
                                                        ),
                                                      ]),
                                                ),
                                                CommonText(
                                                  content:
                                                      'Rs. ${(double.parse("${GetCustomersController.to.getOrderRes['items']?[index]?['price'] ?? '0'}") * (double.parse("${GetCustomersController.to.getOrderRes['items']?[index]?['quantity'] ?? '0'}")))}',
                                                  textColor:
                                                      AppColors.textBlackColor,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            divider(),
                                          ],
                                        ),
                                      ))),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: width * 0.002,
                              horizontal: width * 0.02,
                            ),
                            child: CommonText(
                              content:
                                  "Slot : ${GetCustomersController.to.getOrderRes['slot'] ?? '-'}",
                              boldNess: FontWeight.w500,
                              textColor: AppColors.textBlackColor,
                              textSize: 16,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Total",
                            textSize: width * 0.04,
                            textColor: AppColors.textBlackColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.textBlackColor,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "₹",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textBlackColor,
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['orderAcceptedValue'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Delivery Charges",
                            textSize: width * 0.038,
                            textColor: AppColors.hintColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: "+",
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['deliveryCharges'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Service Charges",
                            textSize: width * 0.038,
                            textColor: AppColors.hintColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: "+",
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['serviceCharges'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Tax",
                            textSize: width * 0.038,
                            textColor: AppColors.hintColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: "+",
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['tax'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Discount Applied",
                            textSize: width * 0.038,
                            textColor: AppColors.hintColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: "-",
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['discount'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.01),
                        child: divider(right: 5.5, left: 5.5, top: 2.7),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Paid",
                            textSize: width * 0.04,
                            textColor: AppColors.textBlackColor,
                            boldNess: FontWeight.w500,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.textBlackColor,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "₹",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textBlackColor,
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " ${GetCustomersController.to.getOrderRes['orderTotalValue'] ?? 0}", //"11,381/-",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
          }),
        ));
  }

  ///----------- charges widget -------

  Widget divider({
    double? left,
    double? right,
    double? top,
  }) {
    return Container(
      margin: EdgeInsets.only(
          left: left == null ? 0.0 : left,
          right: right == null ? 0.0 : right,
          top: top == null ? 1.5 : top,
          bottom: 1),
      height: 0.17,
      color: AppColors.borderColor.withOpacity(0.7),
    );
  }

  ///---- amount widget -----------//
}
