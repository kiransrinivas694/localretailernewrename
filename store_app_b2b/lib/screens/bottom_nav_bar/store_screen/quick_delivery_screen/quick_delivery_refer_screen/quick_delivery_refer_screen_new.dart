import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/refer_supplier_controller_new.dart';
import '../order_summary_screen/order_summary_screen_new.dart';

class QuickDeliveryReferScreen extends StatelessWidget {
  const QuickDeliveryReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferSupplierController>(
      init: ReferSupplierController(),
      initState: (state) {
        Future.delayed(
          Duration(milliseconds: 150),
          () {
            ReferSupplierController controller =
                Get.find<ReferSupplierController>();
            controller.getCategory();
          },
        );
      },
      builder: (ReferSupplierController controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: "Refer Supplier",
              boldNess: FontWeight.w600,
              textSize: 18,
            ),
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text(
                      "Supplier Name",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      gapHeight: 4,
                      hintTextSize: 14,
                      maxLines: 1,
                      hintText: "Supplier Name",
                      hintTextWeight: FontWeight.w500,
                      controller: controller.supplierNameController,
                      titleShow: false,
                      contentColor: ColorsConst.textColor,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Company Name",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      gapHeight: 4,
                      hintTextSize: 14,
                      maxLines: 1,
                      hintText: "Company Name",
                      hintTextWeight: FontWeight.w500,
                      controller: controller.companyNameController,
                      titleShow: false,
                      contentColor: ColorsConst.textColor,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Contact Number",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText: "Contact Number",
                      gapHeight: 2,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      hintTextSize: 14,
                      controller: controller.contactNumberController,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Email Id",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText: "Email Id",
                      gapHeight: 2,
                      hintTextSize: 14,
                      maxLines: 1,
                      controller: controller.emailIdController,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    // SizedBox(height: 15),
                    // Text(
                    //   "Category Name",
                    //   style: GoogleFonts.poppins(
                    //     color: Color.fromRGBO(41, 41, 41, 1),
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 16,
                    //   ),
                    // ),
                    // CommonTextField(
                    //   content: "",
                    //   hintTextWeight: FontWeight.w500,
                    //   hintText: "Category Name",
                    //   gapHeight: 2,
                    //   hintTextSize: 14,
                    //   controller: controller.manufacturerController.value,
                    //   contentColor: ColorsConst.textColor,
                    //   titleShow: false,
                    // ),
                    SizedBox(height: 15),
                    const CommonText(
                      content: "Category",
                      textColor: Colors.black,
                      boldNess: FontWeight.w500,
                    ),
                    SizedBox(height: 4),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        dropdownColor: AppColors.appWhite,
                        // items: [
                        //   DropdownMenuItem(
                        //     child: Text("Kiran"),
                        //     value: "Kiran Nandamuri",
                        //   )
                        // ],
                        items: controller.businessCategoryList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value["categoryName"],
                            child: CommonText(
                              content: value['categoryName'],
                              textColor: Colors.black,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectCategory = value.toString();
                          for (int i = 0;
                              i < controller.businessCategoryList.length;
                              i++) {
                            if (controller.businessCategoryList[i]
                                    ['categoryName'] ==
                                value) {
                              controller.selectCategoryId = controller
                                  .businessCategoryList[i]['categoryId'];

                              controller.selectCategoryStatus.value = controller
                                  .businessCategoryList[i]['categoryName'];

                              print(controller.selectCategoryId);
                            }
                          }
                          print(value);
                          controller.update();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          hintText: "Select Business",
                          hintStyle:
                              GoogleFonts.poppins(color: AppColors.hintColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Supplier Type",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        dropdownColor: ColorsConst.appWhite,
                        items: controller.supplierTypeList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CommonText(
                              content: value,
                              textColor: Colors.black,
                            ),
                          );
                        }).toList(),
                        // items: [
                        //   DropdownMenuItem(
                        //     child: CommonText(content: "Kiran"),
                        //     value: "Kiran",
                        //   ),
                        // ],
                        onChanged: (value) {
                          // controller.retailerType = value!;
                          // for (int i = 0;
                          //     i < controller.businessCategoryList.length;
                          //     i++) {
                          //   if (controller.retailerTypeList[i] == value) {
                          //     controller.selectBusinessId = controller
                          //         .businessCategoryList[i]['categoryId'];
                          //     print(controller.selectBusinessId);
                          //   }
                          // }
                          // controller.update();
                          if (value == "Quick") {
                            controller.supplierType = "Q";
                          } else {
                            controller.supplierType = "R";
                          }
                          controller.update();
                          print("printing firmStatus value ---> $value");
                          print(
                              "printing firmStatus value ---> ${controller.supplierType}");
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorsConst.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorsConst.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorsConst.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorsConst.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorsConst.semiGreyColor,
                              width: 1,
                            ),
                          ),
                          hintText: "Select Supplier Type",
                          hintStyle:
                              GoogleFonts.poppins(color: ColorsConst.hintColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Address",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText: "Address",
                      gapHeight: 2,
                      hintTextSize: 14,
                      maxLines: 4,
                      controller: controller.addressController,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Additional Requests",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 41, 41, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    CommonTextField(
                      content: "",
                      hintTextWeight: FontWeight.w500,
                      hintText:
                          "Is there any more information you'd like to add about the store? Mention it here",
                      gapHeight: 2,
                      hintTextSize: 14,
                      maxLines: 4,
                      controller: controller.additionalRequestsController,
                      contentColor: ColorsConst.textColor,
                      titleShow: false,
                    ),
                    // SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Flexible(
                    //       child: SizedBox(
                    //         child: CommonTextField(
                    //           hintTextWeight: FontWeight.w500,
                    //           hintTextSize: 14,
                    //           counterText: '',
                    //           maxLength: 4,
                    //           content: "",
                    //           hintText: "QTY",
                    //           controller: controller.qtyController.value,
                    //           contentColor: ColorsConst.textColor,
                    //           keyboardType: TextInputType.number,
                    //           titleShow: false,
                    //           inputFormatters: [
                    //             FilteringTextInputFormatter.digitsOnly
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     Flexible(
                    //       child: SizedBox(
                    //         child: CommonTextField(
                    //           maxLength: 4,
                    //           counterText: '',
                    //           hintTextWeight: FontWeight.w500,
                    //           hintTextSize: 14,
                    //           content: "",
                    //           hintText: "Free QTY +22",
                    //           controller: controller.freeQtyController.value,
                    //           contentColor: ColorsConst.textColor,
                    //           keyboardType: TextInputType.number,
                    //           titleShow: false,
                    //           inputFormatters: [
                    //             FilteringTextInputFormatter.digitsOnly
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
              viewOrderSummary(controller, context)
            ],
          ),
        );
      },
    );
  }

  Widget viewOrderSummary(
      ReferSupplierController controller, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (controller.quickDeliveryProductList.isEmpty) {
        //   CommonSnackBar.showToast('Add products', context,
        //       showTickMark: false);
        // } else {
        //   Get.to(() => const OrderSummeryScreen());
        // }
        controller.verifyAddRefer();
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConst.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: const CommonText(
          content: 'Refer',
          boldNess: FontWeight.w500,
          textSize: 16,
        ),
      ),
    );
  }
}
