import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';

class InventoryTab extends StatelessWidget {
  InventoryTab({
    Key? key,
    required this.searchController,
    required this.isCheck,
    required this.onEditTap,
    required this.onTapSubCategory,
  }) : super(key: key);

  final TextEditingController searchController;
  final VoidCallback onEditTap;
  final VoidCallback onTapSubCategory;
  late bool isCheck;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CommonText(
                      textSize: width * 0.045,
                      content: "12",
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
                      content: "168",
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
                      content: "09",
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
                      content: "15",
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
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTapSubCategory,
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
              Expanded(child: CommonSearchField(controller: searchController)),
            ],
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/tata.png",
                        scale: 3,
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: "Tata Chana dal",
                            boldNess: FontWeight.w500,
                            textColor: AppColors.textColor,
                          ),
                          CommonText(
                            content: "1 Kg",
                            textColor: AppColors.textColor,
                          ),
                          CommonText(
                            content: "Stock : 50",
                            textColor: AppColors.textColor,
                          ),
                          CommonText(
                            content: "LocUniGro000009_Orgveg",
                            textSize: width * 0.03,
                            textColor: AppColors.hintColor,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: onEditTap,
                                child: Image.asset(
                                  "assets/icons/edit.png",
                                  scale: 3,
                                ),
                              ),
                              CupertinoSwitch(
                                value: isCheck,
                                onChanged: (value) {
                                  isCheck == false
                                      ? isCheck = true
                                      : isCheck = false;
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonText(
                                textSize: width * 0.035,
                                content: "Sale Price",
                                textColor: AppColors.textColor,
                              ),
                              CommonText(
                                boldNess: FontWeight.w500,
                                content: " ₹110",
                                textColor: AppColors.textBlackColor,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonText(
                                textSize: width * 0.035,
                                content: "MRP",
                                textColor: AppColors.textColor,
                              ),
                              CommonText(
                                boldNess: FontWeight.w500,
                                content: " ₹120",
                                textColor: AppColors.hintColor,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  const Divider(color: Colors.grey),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
