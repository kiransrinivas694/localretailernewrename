import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/utils/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:intl/intl.dart';

import '../screens/bottom_nav_bar/home_screens/controller/inventory_controller.dart';

class InventoryDialog extends StatefulWidget {
  final String title;
  final String type;
  final String invoiceID;
  final String date;
  final String mrp;
  final String ptr;
  final String qty;
  final String productID;
  final String contentId;
  InventoryDialog({
    required this.title,
    required this.type,
    required this.invoiceID,
    required this.date,
    required this.mrp,
    required this.ptr,
    required this.qty,
    required this.productID,
    required this.contentId,
  });

  @override
  State<InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {
  TextEditingController date = TextEditingController();
  TextEditingController invoiceID = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController ptr = TextEditingController();
  TextEditingController qty = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    date.text = widget.date;
    invoiceID.text = widget.invoiceID;
    mrp.text = widget.mrp;
    ptr.text = widget.ptr;
    qty.text = widget.qty;
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        date.text = DateFormat('yyyy-MM-dd').format(picked);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: const CommonText(
                                content: "Invoice Id :",
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*const CommonText(
                                      content: "₹",
                                      textColor: Colors.black,
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Container(
                                      height: 25,
                                      width: 1,
                                      color: AppColors.hintColor,
                                    ),
                                    SizedBox(width: width * 0.02),*/
                                    Expanded(
                                      child: TextField(
                                        controller: invoiceID,
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
                                content: "Date :",
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: date,
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
                                          _selectDate(context);
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: const CommonText(
                                content: "MRP :",
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        controller: mrp,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
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
                                content: "PTR :",
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        controller: ptr,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
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
                                content: "Quantity :",
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*const CommonText(
                                      content: "₹",
                                      textColor: Colors.black,
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Container(
                                      height: 25,
                                      width: 1,
                                      color: AppColors.hintColor,
                                    ),
                                    SizedBox(width: width * 0.02),*/
                                    Expanded(
                                      child: TextField(
                                        controller: qty,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    (widget.invoiceID == '' ||
                            widget.date == '' ||
                            widget.qty == '' ||
                            widget.ptr == '' ||
                            widget.mrp == '')
                        ? Row(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
                                    if (GetHelperController
                                        .storeID.value.isNotEmpty) {
                                      InventoryListController.to.addInvoiceApi(
                                          data: {
                                            "buyerId": GetHelperController
                                                .storeID.value,
                                            "id": null,
                                            "invoiceDate": date.text,
                                            "invoiceId": invoiceID.text,
                                            "mrp": mrp.text,
                                            "productId": widget.productID,
                                            "ptr": ptr.text,
                                            "quantity": qty.text
                                          },
                                          success: () {
                                            Get.back();
                                            InventoryListController.to
                                                .productListApi(
                                                    productId:
                                                        '${widget.productID}');
                                            showSnackBar(
                                                title: ApiConfig.success,
                                                message:
                                                    'Update Successfully..');
                                          },
                                          error: (e) {
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: '$e');
                                          });
                                    } else if (!Get.isDialogOpen!) {
                                      Get.dialog(const LoginDialog());
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: CommonText(
                                      content: 'Save',
                                      textSize: width * 0.034,
                                      textColor: Colors.white,
                                      boldNess: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black),
                              fixedSize: Size(width, 45),
                            ),
                            onPressed: () {
                              // Get.back();
                              // if(){}else{showSnackBar(title: ApiConfig.error, message:'Change ');}

                              if (GetHelperController
                                  .storeID.value.isNotEmpty) {
                                InventoryListController.to.updateInvoiceApi(
                                    data: {
                                      "buyerId":
                                          GetHelperController.storeID.value,
                                      "id": widget.contentId,
                                      "invoiceDate": date.text,
                                      "invoiceId": invoiceID.text,
                                      "mrp": mrp.text,
                                      "productId": widget.productID,
                                      "ptr": ptr.text,
                                      "quantity": qty.text
                                    },
                                    success: () {
                                      Get.back();
                                      InventoryListController.to.productListApi(
                                          productId: '${widget.productID}');
                                      showSnackBar(
                                          title: ApiConfig.success,
                                          message: 'Update Successfully..');
                                    },
                                    error: (e) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message: '$e');
                                    });
                              } else if (!Get.isDialogOpen!) {
                                Get.dialog(const LoginDialog());
                              }
                            },
                            child: CommonText(
                              content: "Update",
                              textSize: width * 0.04,
                              textColor: Colors.black,
                              boldNess: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
