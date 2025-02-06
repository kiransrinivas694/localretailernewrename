import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          content: "Review",
          boldNess: FontWeight.w600,
          textSize: width * 0.047,
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
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            CommonText(
              content: "Custome rating",
              textColor: AppColors.textBlackColor,
            ),
            SizedBox(height: height * 0.01),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: "5",
                        textSize: width * 0.035,
                        textColor: AppColors.textBlackColor,
                      ),
                      const Icon(Icons.star, size: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                CommonText(
                  textSize: width * 0.035,
                  content: " 5465",
                  textColor: AppColors.hintColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: "4",
                        textSize: width * 0.035,
                        textColor: AppColors.textBlackColor,
                      ),
                      const Icon(Icons.star, size: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                CommonText(
                  textSize: width * 0.035,
                  content: " 2003",
                  textColor: AppColors.hintColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: "3",
                        textSize: width * 0.035,
                        textColor: AppColors.textBlackColor,
                      ),
                      const Icon(Icons.star, size: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                CommonText(
                  textSize: width * 0.035,
                  content: " 837",
                  textColor: AppColors.hintColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: "2",
                        textSize: width * 0.035,
                        textColor: AppColors.textBlackColor,
                      ),
                      const Icon(Icons.star, size: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                CommonText(
                  textSize: width * 0.035,
                  content: " 356",
                  textColor: AppColors.hintColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        content: "1",
                        textSize: width * 0.035,
                        textColor: AppColors.textBlackColor,
                      ),
                      const Icon(Icons.star, size: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: width / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                CommonText(
                  textSize: width * 0.035,
                  content: " 158",
                  textColor: AppColors.hintColor,
                )
              ],
            ),
            SizedBox(height: height * 0.02),
            const Divider(color: Colors.grey),
            SizedBox(height: height * 0.01),
            CommonText(
              content: "Customer Reviews",
              textColor: AppColors.textBlackColor,
              boldNess: FontWeight.w600,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 23, backgroundColor: AppColors.primaryColor),
                      title: CommonText(
                        content: "Vandana Surana",
                        boldNess: FontWeight.w500,
                        textColor: AppColors.textColor,
                      ),
                      subtitle: CommonText(
                        textSize: width * 0.034,
                        content: "1 Day ago",
                        textColor: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  content: "5",
                                  textSize: width * 0.035,
                                  textColor: Colors.white,
                                ),
                                const Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        CommonText(
                          content: "On time Delivery and product quality.",
                          textColor: AppColors.textColor,
                          textSize: width * 0.035,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/icons/green_like.png",
                              scale: 3.2),
                          SizedBox(width: width * 0.02),
                          CommonText(
                            content: "20 Likes",
                            textColor: Colors.grey,
                            textSize: width * 0.035,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    const Divider(color: Colors.grey)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
