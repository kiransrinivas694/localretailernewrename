import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/components/common_text_field.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class InventoryDialog extends StatelessWidget {
  const InventoryDialog({
    Key? key,
  }) : super(key: key);

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
                    colors: ColorsConst.appGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          content: "Daawat Basmati Rice 1kg",
                          boldNess: FontWeight.w600,
                        ),
                        CommonText(
                          content: "LT foods LTD",
                          textSize: width * 0.03,
                          boldNess: FontWeight.w500,
                        ),
                      ],
                    ),
                    const Spacer(),
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
                    Row(
                      children: [
                        const CommonText(
                          content: "MRP :",
                          textColor: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsConst.borderColor),
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
                                color: ColorsConst.hintColor,
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "000",
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: ColorsConst.semiGreyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: width * 0.08),
                        const CommonText(
                          content: "Quantity :",
                          textColor: Colors.black,
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsConst.borderColor),
                          ),
                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "000",
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.poppins(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        const CommonText(
                          content: "MRP :",
                          textColor: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsConst.borderColor),
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
                                color: ColorsConst.hintColor,
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "000",
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: ColorsConst.semiGreyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: width * 0.08),
                        const CommonText(
                          content: "Selling\nprice :",
                          textColor: Colors.black,
                        ),
                        const Spacer(),
                        // SizedBox(width: width * 0.04),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsConst.borderColor),
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
                                color: ColorsConst.hintColor,
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "000",
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: ColorsConst.semiGreyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        fixedSize: Size(width, 45),
                      ),
                      onPressed: () {
                        Get.back();
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
