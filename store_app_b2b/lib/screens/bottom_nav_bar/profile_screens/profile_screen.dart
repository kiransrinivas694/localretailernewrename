import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_details_text.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/profile_controller/edit_profile_controller.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/profile_screens/edit_profile_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key, this.screenType}) : super(key: key);
  String? screenType = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetX<EditProfileController>(
        init: EditProfileController(),
        initState: (state) async {
          await state.controller!.getUserId();
          state.controller!.getCategory();
          await state.controller!.getProfileDataApi();
        },
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: ColorsConst.greyBgColor,
              body: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ColorsConst.primaryColor))
                  : Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.centerRight,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 50),
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AppImageAsset(
                                                      image:
                                                          "assets/icons/camera.svg",
                                                      height: 35,
                                                      width: 35),
                                                ),
                                              ),
                                              if (controller.profileData[
                                                              'imageUrl']
                                                          ?['bannerImageId'] !=
                                                      null &&
                                                  controller
                                                      .profileData['imageUrl']
                                                          ['bannerImageId']
                                                      .isNotEmpty)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: AppImageAsset(
                                                      image: controller
                                                                  .profileData[
                                                              'imageUrl']
                                                          ['bannerImageId'],
                                                      height: 130,
                                                      width: width),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 40),
                                        ],
                                      ),
                                      Container(
                                        height: 110,
                                        width: 110,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          margin: const EdgeInsets.all(2),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle),
                                          child: (controller.profileData[
                                                              'imageUrl']
                                                          ?['profileImageId'] !=
                                                      null &&
                                                  controller
                                                      .profileData['imageUrl']
                                                          ['profileImageId']
                                                      .isNotEmpty)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500),
                                                  child: AppImageAsset(
                                                      image: controller
                                                                  .profileData[
                                                              'imageUrl']
                                                          ['profileImageId'],
                                                      height: 100,
                                                      width: 100),
                                                )
                                              : const AppImageAsset(
                                                  image:
                                                      "assets/icons/camera.svg",
                                                  height: 24,
                                                  width: 32),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              content: controller.profileData[
                                                      'storeName'] ??
                                                  "",
                                              textSize: width * 0.05,
                                              boldNess: FontWeight.w600,
                                              textColor: ColorsConst.textColor,
                                            ),
                                            Row(
                                              children: [
                                                CommonText(
                                                  content:
                                                      "Store Rating ${controller.profileData['storeRating'] ?? ""}",
                                                  textSize: width * 0.03,
                                                  boldNess: FontWeight.w400,
                                                  textColor:
                                                      ColorsConst.textColor,
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 3,
                                                  itemSize: 15,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      content:
                                                          "Application Status",
                                                      textSize: width * 0.03,
                                                      boldNess: FontWeight.w400,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                    ),
                                                    CommonText(
                                                      content: "Store Status",
                                                      textSize: width * 0.03,
                                                      boldNess: FontWeight.w400,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                    ),
                                                    CommonText(
                                                      content: "Onboarded On",
                                                      textSize: width * 0.03,
                                                      boldNess: FontWeight.w400,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CommonText(
                                                          content: ":",
                                                          textSize:
                                                              width * 0.03,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.black,
                                                        ),
                                                        CommonText(
                                                          content: controller
                                                                      .profileData[
                                                                  'applicationStatus'] ??
                                                              "",
                                                          textSize:
                                                              width * 0.03,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.green,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        CommonText(
                                                          content: ":",
                                                          textSize:
                                                              width * 0.03,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.black,
                                                        ),
                                                        CommonText(
                                                          content: controller
                                                                      .profileData[
                                                                  'storeLiveStatus'] ??
                                                              "",
                                                          textSize:
                                                              width * 0.03,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.green,
                                                        ),
                                                      ],
                                                    ),
                                                    CommonText(
                                                      content:
                                                          ": ${controller.profileData['applicationStatusDate'] ?? ""}",
                                                      textSize: width * 0.03,
                                                      boldNess: FontWeight.w400,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => MapScreen(),
                                                  arguments: {
                                                    'latitude': controller
                                                            .profileData[
                                                                'storeAddressDetailRequest']
                                                            .first['latitude'] ??
                                                        "",
                                                    'longitude': controller
                                                            .profileData[
                                                                'storeAddressDetailRequest']
                                                            .first['longitude'] ??
                                                        ""
                                                  });
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: ColorsConst.primaryColor,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.015),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => EditProfileScreen(
                                                  screenType: screenType));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: ColorsConst.textColor,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  CommonText(
                                                    content: "Edit Profile",
                                                    textSize: width * 0.03,
                                                    boldNess: FontWeight.w500,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.015),
                                          InkWell(
                                            onTap: () async {
                                              // await FlutterShare.share(
                                              //   title: 'Store B2B',
                                              //   text: "Let's explore",
                                              //   linkUrl: '',
                                              // );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color:
                                                      ColorsConst.primaryColor,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Icon(
                                                      Icons.share_outlined,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  CommonText(
                                                    content: "Share my store",
                                                    textSize: width * 0.03,
                                                    boldNess: FontWeight.w500,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    content: "Business Details",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Business type",
                                      details: controller
                                              .profileData['businessType'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Business",
                                      details: controller
                                              .profileData['storeCategory'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Store name",
                                      details:
                                          controller.profileData['storeName'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Store number",
                                      details: controller
                                              .profileData['storeNumber'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Owner",
                                      details:
                                          controller.profileData['ownerName'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Registered Pharmacist",
                                      details: controller.profileData[
                                              'registeredPharmacistName'] ??
                                          ""),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    content: "Contact",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Mobile Number",
                                      details: controller
                                              .profileData['phoneNumber'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Email",
                                      details:
                                          controller.profileData['email'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Wedding anniversary date",
                                      details:
                                          controller.profileData['createdAt'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Child 1 Birth date",
                                      details: controller.profileData[
                                              'retailerChildOneBirthDay'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Child 2 Birth date",
                                      details: controller.profileData[
                                              'retailerChildTwoBirthDay'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Address",
                                      details: controller.profileData[
                                                  'storeAddressDetailRequest']
                                              ?[0]?['addressLine1'] ??
                                          ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Deals in",
                                      details:
                                          controller.profileData['dealsIn'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Popular in",
                                      details:
                                          controller.profileData['popularIn'] ??
                                              ""),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    content: "License",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                              content: "GST",
                                              textSize: width * 0.04,
                                              textColor: ColorsConst.textColor,
                                              boldNess: FontWeight.w500,
                                            ),
                                          ),
                                          CommonText(
                                            content: ":",
                                            textSize: width * 0.04,
                                            textColor: Colors.black,
                                            boldNess: FontWeight.w400,
                                          ),
                                          SizedBox(width: width * 0.05),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CommonText(
                                                    content:
                                                        controller.profileData[
                                                                    'gst']?[
                                                                "gstNumber"] ??
                                                            "",
                                                    textSize: width * 0.04,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                ),
                                                if (controller.profileData[
                                                        'gstVerifed'] ==
                                                    0) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/pending.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'gstVerifed'] ==
                                                    1) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/done.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'gstVerifed'] ==
                                                    2) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/cancel.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller.profileData['gst']
                                                  ?['documentId'] !=
                                              null &&
                                          controller
                                              .profileData['gst']['documentId']
                                              .isNotEmpty &&
                                          controller.profileData['gst']
                                                  ['documentId']
                                              .contains('http')) ...[
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.to(() =>
                                                    ImageViewScreen(
                                                        image: controller
                                                                        .profileData[
                                                                    'gst'][
                                                                'documentId'] ??
                                                            '')),
                                                child: AppImageAsset(
                                                    image:
                                                        controller.profileData[
                                                                    'gst'][
                                                                'documentId'] ??
                                                            '',
                                                    height: 100,
                                                    width: 130),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                              content: "Store License",
                                              textSize: width * 0.04,
                                              textColor: ColorsConst.textColor,
                                              boldNess: FontWeight.w500,
                                            ),
                                          ),
                                          CommonText(
                                            content: ":",
                                            textSize: width * 0.04,
                                            textColor: Colors.black,
                                            boldNess: FontWeight.w400,
                                          ),
                                          SizedBox(width: width * 0.05),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CommonText(
                                                    content: controller
                                                                    .profileData[
                                                                'storeLicense']
                                                            ?["storeLicense"] ??
                                                        "",
                                                    textSize: width * 0.04,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                ),
                                                if (controller.profileData[
                                                        'storeLicenseVerifed'] ==
                                                    0) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/pending.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'storeLicenseVerifed'] ==
                                                    1) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/done.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'storeLicenseVerifed'] ==
                                                    2) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/cancel.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller.profileData['storeLicense']
                                                  ?['storeLicenseNumber'] !=
                                              null &&
                                          controller
                                              .profileData['storeLicense']
                                                  ['storeLicenseNumber']
                                              .isNotEmpty &&
                                          controller.profileData['storeLicense']
                                                  ['storeLicenseNumber']
                                              .contains('http')) ...[
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.to(() =>
                                                    ImageViewScreen(
                                                        image: controller
                                                                        .profileData[
                                                                    'storeLicense']
                                                                ['docUrl'] ??
                                                            '')),
                                                child: AppImageAsset(
                                                    image: controller
                                                                    .profileData[
                                                                'storeLicense']
                                                            ['docUrl'] ??
                                                        '',
                                                    height: 100,
                                                    width: 130),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: CommonText(
                                              content: "Drug License",
                                              textSize: width * 0.04,
                                              textColor: ColorsConst.textColor,
                                              boldNess: FontWeight.w500,
                                            ),
                                          ),
                                          CommonText(
                                            content: ":",
                                            textSize: width * 0.04,
                                            textColor: Colors.black,
                                            boldNess: FontWeight.w400,
                                          ),
                                          SizedBox(width: width * 0.05),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CommonText(
                                                    content: controller
                                                                    .profileData[
                                                                'drugLicense']?[
                                                            "drugLicenseNumber"] ??
                                                        "",
                                                    textSize: width * 0.04,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                ),
                                                if (controller.profileData[
                                                        'drugLicenseVerifed'] ==
                                                    0) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/pending.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'drugLicenseVerifed'] ==
                                                    1) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/done.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                                if (controller.profileData[
                                                        'drugLicenseVerifed'] ==
                                                    2) ...[
                                                  InkWell(
                                                    // onTap: () => logic
                                                    //     .updateGstStatus(1),
                                                    child: AppImageAsset(
                                                        image:
                                                            "assets/icons/cancel.png",
                                                        height: 24,
                                                        width: 24),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller.profileData['drugLicense']
                                                  ?['documentId'] !=
                                              null &&
                                          controller
                                              .profileData['drugLicense']
                                                  ?['documentId']
                                              .isNotEmpty &&
                                          controller.profileData['drugLicense']
                                                  ?['documentId']
                                              .contains('http')) ...[
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.to(() =>
                                                    ImageViewScreen(
                                                        image: controller
                                                                        .profileData[
                                                                    'drugLicense']
                                                                [
                                                                'documentId'] ??
                                                            '')),
                                                child: AppImageAsset(
                                                    image: controller
                                                                    .profileData[
                                                                'drugLicense']
                                                            ['documentId'] ??
                                                        '',
                                                    height: 100,
                                                    width: 130),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    content: "Store Timing info",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Opening time",
                                      details:
                                          controller.profileData['openTime'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Closing time",
                                      details:
                                          controller.profileData['closeTime'] ??
                                              ""),
                                  SizedBox(height: height * 0.01),
                                  CommonDetailsText(
                                      title: "Delivery Strength",
                                      details: controller.profileData[
                                              'deliveryStrength'] ??
                                          ""),
                                  SizedBox(height: height * 0.03),
                                  CommonText(
                                    content: "Slots :",
                                    textSize: width * 0.04,
                                    textColor: ColorsConst.textColor,
                                    boldNess: FontWeight.w500,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Column(
                                    children: List.generate(
                                      (controller.profileData['slots'] ?? [])
                                          .length,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: controller.profileData['slots']
                                                    [index]["isChecked"] ==
                                                false
                                            ? SizedBox()
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: CommonText(
                                                      content: controller
                                                                  .profileData[
                                                              'slots'][index]
                                                          ["slotName"],
                                                      textSize: width * 0.035,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                  CommonText(
                                                    content: ":",
                                                    textSize: width * 0.04,
                                                    textColor: Colors.black,
                                                    boldNess: FontWeight.w400,
                                                  ),
                                                  SizedBox(width: width * 0.05),
                                                  Expanded(
                                                    child: CommonText(
                                                      content:
                                                          "${controller.profileData['slots'][index]["startTime"]} - ${controller.profileData['slots'][index]["endTime"]}",
                                                      textSize: width * 0.035,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorsConst.semiGreyColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    content:
                                        "Message to customer from retailer :",
                                    textColor: Colors.black,
                                    boldNess: FontWeight.w600,
                                  ),
                                  Row(
                                    children: [
                                      CommonText(
                                        content: controller.profileData[
                                                'retailerMessage'] ??
                                            "",
                                        textSize: width * 0.04,
                                        textColor: ColorsConst.textColor,
                                        boldNess: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}

class ProfileHeaderValue extends StatelessWidget {
  final String headerText;

  const ProfileHeaderValue({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: SizedBox(
        width: width / 2,
        // child: AppText(
        //   headerText,
        //   color: AppColorConstants.hex('404040'),
        //   fontWeight: FontWeight.w400,
        // ),
        child: CommonText(
          content: headerText,
          textSize: width * 0.04,
          textColor: ColorsConst.textColor,
          boldNess: FontWeight.w400,
        ),
      ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final String? image;

  const ImageViewScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppImageAsset(
      image: image,
      height: Get.height,
      width: Get.width,
      fit: BoxFit.fill,
    );
  }
}
