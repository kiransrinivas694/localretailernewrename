import 'dart:math';

import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/utils/snack_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:intl/intl.dart';

import '../screens/bottom_nav_bar/home_screens/controller/inventory_controller_new.dart';
import 'login_dialog_new.dart';

class UpdateInventoryDialog extends StatefulWidget {
  final String title;
  final String type;
  // final String invoiceID;
  final String startDate;
  final String endDate;
  final String mrp;
  final String ptr;
  final String productID;
  final String disValue;
  final String discount;
  final String disType;
  final String finalValue;
  UpdateInventoryDialog({
    required this.title,
    required this.type,
    required this.mrp,
    required this.ptr,
    required this.productID,
    required this.startDate,
    required this.endDate,
    required this.disValue,
    required this.discount,
    required this.disType,
    required this.finalValue,
  });

  @override
  State<UpdateInventoryDialog> createState() => _UpdateInventoryDialogState();
}

class _UpdateInventoryDialogState extends State<UpdateInventoryDialog> {
  TextEditingController startDate = TextEditingController();
  DateTime? startDateTime;
  DateTime? endDateTime;
  TextEditingController endDate = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController ptr = TextEditingController();
  TextEditingController perDis = TextEditingController();
  TextEditingController rsDis = TextEditingController();
  TextEditingController discountValue = TextEditingController();
  TextEditingController finalSellingPrice = TextEditingController();
  RxString disType = 'PER'.obs;

  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    startDate.text = widget.startDate;
    endDate.text = widget.endDate;
    // invoiceID.text = widget.invoiceID;
    mrp.text = widget.mrp;
    finalSellingPrice.text = mrp.text;
    ptr.text = widget.ptr;
    widget.disType != '' ? disType.value = widget.disType : null;
    disType.value == 'PER'
        ? perDis.text = widget.discount
        : rsDis.text = widget.discount;
    widget.discount != '' ? discountValue.text = widget.discount : null;
    widget.finalValue != '' ? finalSellingPrice.text = widget.finalValue : null;
    super.initState();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        startDateTime = picked;
        startDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        endDateTime = picked;
        endDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: AppColors.appGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: widget.title,
                            boldNess: FontWeight.w600,
                          ),
                          CommonText(
                            content: widget.type,
                            textSize: width * 0.03,
                            boldNess: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CommonText(
                                  content: "Mrp : ${mrp.text}",
                                  textColor: Colors.black,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: CommonText(
                                  content: "Ptr : ${ptr.text}",
                                  textColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.03),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: const CommonText(
                                  content: "Start Date",
                                  textColor: Colors.black,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.borderColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: startDate,
                                          readOnly: true,
                                          validator: (value) {
                                            if (startDate.text.isEmpty) {
                                              return "Please Select Start Date";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "000",
                                            border: InputBorder.none,
                                            hintStyle: GoogleFonts.poppins(
                                              color: AppColors.semiGreyColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Container(
                                        height: 25,
                                        width: 1,
                                        color: AppColors.hintColor,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      InkWell(
                                          onTap: () {
                                            _selectStartDate(context);
                                          },
                                          child: Icon(Icons.calendar_month))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.03),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: const CommonText(
                                  content: "End Date",
                                  textColor: Colors.black,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.borderColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: endDate,
                                          validator: (value) {
                                            if (endDate.text.isEmpty) {
                                              return "Please Select End Date";
                                            }
                                            return null;
                                          },
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "000",
                                            border: InputBorder.none,
                                            hintStyle: GoogleFonts.poppins(
                                              color: AppColors.semiGreyColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Container(
                                        height: 25,
                                        width: 1,
                                        color: AppColors.hintColor,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      InkWell(
                                          onTap: () {
                                            _selectEndDate(context);
                                          },
                                          child: Icon(Icons.calendar_month))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      StreamBuilder(
                          stream: disType.stream,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: const CommonText(
                                        content: "Discount :",
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: disType.value,
                                            groupValue: 'PER',
                                            onChanged: (value) {
                                              disType.value = "PER";
                                              rsDis.clear();
                                              perDis.clear();
                                              discountValue.clear();
                                              finalSellingPrice.text = mrp.text;
                                            },
                                            activeColor: AppColors.primaryColor,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        AppColors.borderColor),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const CommonText(
                                                    content: "%",
                                                    textColor: Colors.black,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  Container(
                                                    height: 25,
                                                    width: 1,
                                                    color: AppColors.hintColor,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  Expanded(
                                                    child: TextField(
                                                      controller: perDis,
                                                      readOnly:
                                                          disType.value == 'PER'
                                                              ? false
                                                              : true,
                                                      onChanged: (value) {
                                                        if (perDis
                                                            .text.isEmpty) {
                                                          discountValue.text =
                                                              "0";
                                                        } else {
                                                          discountValue
                                                              .text = (double
                                                                      .parse(mrp
                                                                          .text) *
                                                                  double.parse(
                                                                      perDis
                                                                          .text) /
                                                                  100)
                                                              .toStringAsFixed(
                                                                  2);
                                                          finalSellingPrice
                                                              .text = (double
                                                                      .parse(mrp
                                                                          .text) -
                                                                  double.parse(
                                                                      discountValue
                                                                          .text))
                                                              .toStringAsFixed(
                                                                  2);
                                                        }
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        hintText: "000",
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .semiGreyColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width * 0.03),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: const CommonText(
                                        content: "",
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: disType.value,
                                            groupValue: 'RS',
                                            onChanged: (value) {
                                              disType.value = "RS";
                                              rsDis.clear();
                                              perDis.clear();
                                              discountValue.clear();
                                              finalSellingPrice.text = mrp.text;
                                            },
                                            activeColor: AppColors.primaryColor,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        AppColors.borderColor),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const CommonText(
                                                    content: "₹",
                                                    textColor: Colors.black,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  Container(
                                                    height: 25,
                                                    width: 1,
                                                    color: AppColors.hintColor,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  Expanded(
                                                    child: TextField(
                                                      controller: rsDis,
                                                      readOnly:
                                                          disType.value == 'RS'
                                                              ? false
                                                              : true,
                                                      onChanged: (value) {
                                                        if (rsDis
                                                            .text.isEmpty) {
                                                          discountValue.text =
                                                              "0";
                                                        } else {
                                                          discountValue
                                                              .text = (double
                                                                  .parse(rsDis
                                                                      .text))
                                                              .toStringAsFixed(
                                                                  2);
                                                          finalSellingPrice
                                                              .text = (double
                                                                      .parse(mrp
                                                                          .text) -
                                                                  double.parse(
                                                                      discountValue
                                                                          .text))
                                                              .toStringAsFixed(
                                                                  2);
                                                        }
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        hintText: "000",
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .semiGreyColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width * 0.03),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: const CommonText(
                                        content: "Discount Value",
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CommonText(
                                              content: "₹",
                                              textColor: Colors.black,
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColors.hintColor,
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Expanded(
                                              child: TextField(
                                                controller: discountValue,
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText: "000",
                                                  border: InputBorder.none,
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                    color:
                                                        AppColors.semiGreyColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width * 0.03),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: const CommonText(
                                        content: "Final Selling Price",
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CommonText(
                                              content: "₹",
                                              textColor: Colors.black,
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Container(
                                              height: 25,
                                              width: 1,
                                              color: AppColors.hintColor,
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Expanded(
                                              child: TextField(
                                                controller: finalSellingPrice,
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText: "000",
                                                  border: InputBorder.none,
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                    color:
                                                        AppColors.semiGreyColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                      SizedBox(height: height * 0.03),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: AppColors.redColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                  content: "Cancel",
                                  textSize: width * 0.034,
                                  textColor: AppColors.redColor,
                                  boldNess: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff049337),
                              ),
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  if (endDateTime!.isBefore(startDateTime!)) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message:
                                            'End date should not be greater than start date.');
                                  } else if (disType.value == 'PER' &&
                                      ((int.parse(perDis.text) < 0) ||
                                          (int.parse(perDis.text) > 100))) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message:
                                            'Discount should be 0 to 100.');
                                  } else if (disType.value == 'RS' &&
                                      (double.parse(finalSellingPrice.text) <
                                          0)) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message:
                                            'Amount should not be less then 0');
                                  } else {
                                    if (GetHelperController
                                        .storeID.value.isNotEmpty) {
                                      InventoryListController.to
                                          .updateInvoiceApi(
                                              data: {
                                            "storeId": GetHelperController
                                                .storeID.value,
                                            "startDate": startDate.text,
                                            "endDate": endDate.text,
                                            "mrp": mrp.text,
                                            "ptr": ptr.text,
                                            "price": finalSellingPrice.text,
                                            "discount": disType.value == 'RS'
                                                ? rsDis.text
                                                : perDis.text,
                                            "discountType":
                                                disType.value == 'RS'
                                                    ? "F"
                                                    : "%",
                                            "productId": widget.productID,
                                          },
                                              success: () {
                                                Get.back();
                                                Get.back();
                                                InventoryListController
                                                    .to.inventoryList
                                                    .clear();
                                                InventoryListController.to
                                                    .inventoryListApi(
                                                  queryParameters: {
                                                    "page": 0,
                                                    "size": 10,
                                                    "categoryId":
                                                        GetHelperController
                                                            .categoryID.value,
                                                  },
                                                );

                                                showSnackBar(
                                                    title: ApiConfig.success,
                                                    message:
                                                        "Updated successfully...");
                                              },
                                              error: (e) {
                                                showSnackBar(
                                                    title: ApiConfig.error,
                                                    message: '$e');
                                              });
                                    }
                                    Future.delayed(
                                      Duration(milliseconds: 300),
                                      () {
                                        if (!Get.isDialogOpen!) {
                                          Get.dialog(const LoginDialog());
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                  content: 'Update',
                                  textSize: width * 0.034,
                                  textColor: Colors.white,
                                  boldNess: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
