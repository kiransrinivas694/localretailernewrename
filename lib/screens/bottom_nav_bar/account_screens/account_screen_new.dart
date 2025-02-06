import 'dart:developer';

import 'package:b2c/components/common_details_text_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/auth_controller/signup_controller_new.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/account_edit_screen_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {Key? key,
      this.screenType,
      this.isShowAllBar = false,
      this.isCallApi = false})
      : super(key: key);
  String? screenType = "";
  bool isShowAllBar;
  bool isCallApi;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BranchUniversalObject? buo;

  BranchLinkProperties? lp;

  BranchResponse? response;

  @override
  void initState() {
    // ConnectivityService.instance.connectionStream();
    initializeDeepLinkData();
  }

  void initializeDeepLinkData() async {
    String id = await SharPreferences.getString(SharPreferences.loginId) ?? '';
    log('logging shareable id -> ${id}');
    buo = BranchUniversalObject(
      canonicalIdentifier: 'store/${id}',
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata("deep_link_title", 'flutter deep link')
        ..addCustomMetadata('retailerId', id),
    );
    FlutterBranchSdk.registerView(buo: buo!);

    lp = BranchLinkProperties();
    lp?.addControlParam('\$uri_redirect_mode', '1');
    lp?.addControlParam(
        '\$canonical_url', 'https://acintyolocal.test-app.link/store/$id');
  }

  void generateDeepLink(BuildContext context) async {
    try {
      log("log share click -2");
      BranchResponse response =
          await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
      log("log share click 2");
      if (response.success) {
        Share.share('Check out my store ${response.result}');
        print('Link generated: ${response.result}');
        // Get.snackbar('popup', 'Link generated: ${response.result}');
      } else {
        // Get.snackbar('popup',
        log('Link generated: ${response.errorCode} - ${response.errorMessage}');
      }
    } catch (e) {
      log("log share click 3 ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetX<EditProfileController>(
        init: EditProfileController(),
        initState: (state) async {
          if (widget.isCallApi) {
            await state.controller!.getUserId();
            state.controller!.getCategory();
            await state.controller!.getProfileDataApi();
          }
        },
        builder: (controller) {
          print('isShowAllBar --> ${widget.isShowAllBar}');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.screenType == 'reject'
                ? AppBar(
                    title: CommonText(
                      content: "Profile",
                      boldNess: FontWeight.w600,
                      textSize: width * 0.047,
                    ),
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
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
                  )
                : (widget.isShowAllBar)
                    ? AppBar(
                        centerTitle: true,
                        title: CommonText(
                          content: "My Account",
                          boldNess: FontWeight.w600,
                          textSize: width * 0.047,
                        ),
                        elevation: 0,
                        leading: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
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
                      )
                    : null,
            body: controller.isLoading.value
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.zero,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
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
                                            height: 188,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (controller.profileData['imageUrl']
                                                      ?['bannerImageId'] !=
                                                  null &&
                                              controller
                                                  .profileData['imageUrl']
                                                      ['bannerImageId']
                                                  .isNotEmpty)
                                            AppImageAsset(
                                                image: controller
                                                        .profileData['imageUrl']
                                                    ['bannerImageId'],
                                                height: 188,
                                                width: width,
                                                fit: BoxFit.fill),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 15, bottom: 40),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () => Get.to(() =>
                                                    EditProfileScreen(
                                                        screenType:
                                                            widget.screenType)),
                                                child: Container(
                                                    height: 28.94,
                                                    width: 30.94,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ColorsConst
                                                          .appWhite
                                                          .withOpacity(0.8),
                                                    ),
                                                    child: const Icon(
                                                        Icons.edit,
                                                        size: 15,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: -5,
                                    child: Container(
                                      height: 103,
                                      width: 103,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Container(
                                        height: 103,
                                        width: 103,
                                        margin: const EdgeInsets.all(2),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
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
                                                    BorderRadius.circular(103),
                                                child: AppImageAsset(
                                                    image:
                                                        controller.profileData[
                                                                'imageUrl']
                                                            ['profileImageId'],
                                                    height: 103,
                                                    width: 103,
                                                    fit: BoxFit.fill),
                                              )
                                            : const AppImageAsset(
                                                image:
                                                    "assets/icons/camera.svg",
                                                height: 24,
                                                width: 32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.025),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9.55),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: AppColors.greyBorderColor,
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CommonText(
                                                  content:
                                                      controller.profileData[
                                                              'storeName'] ??
                                                          "",
                                                  textSize: width * 0.05,
                                                  boldNess: FontWeight.w600,
                                                  textColor:
                                                      AppColors.textColor,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      () => MapScreen(
                                                          status: "show"),
                                                      arguments: {
                                                        'latitude': controller
                                                                .profileData[
                                                                    'storeAddressDetailRequest']
                                                                .first['latitude'] ??
                                                            "",
                                                        'longitude': controller
                                                                    .profileData[
                                                                        'storeAddressDetailRequest']
                                                                    .first[
                                                                'longitude'] ??
                                                            ""
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "Store Rating: ",
                                                textSize: width * 0.03,
                                                boldNess: FontWeight.w400,
                                                textColor: AppColors.textColor,
                                              ),
                                              CommonText(
                                                content:
                                                    "${controller.profileData['storeRating'] ?? ""}",
                                                textSize: width * 0.03,
                                                boldNess: FontWeight.w400,
                                                textColor: AppColors.textColor,
                                              ),
                                              SizedBox(width: width * 0.01),
                                              IgnorePointer(
                                                ignoring: true,
                                                child: RatingBar.builder(
                                                  initialRating: double.parse(
                                                      controller.profileData[
                                                              'storeRating'] ??
                                                          '0'),
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
                                                    null;
                                                  },
                                                ),
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
                                                        AppColors.textColor,
                                                  ),
                                                  CommonText(
                                                    content: "Store Status",
                                                    textSize: width * 0.03,
                                                    boldNess: FontWeight.w400,
                                                    textColor:
                                                        AppColors.textColor,
                                                  ),
                                                  CommonText(
                                                    content: "Onboarded On",
                                                    textSize: width * 0.03,
                                                    boldNess: FontWeight.w400,
                                                    textColor:
                                                        AppColors.textColor,
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
                                                        content: " : ",
                                                        textSize: width * 0.03,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor: Colors.black,
                                                      ),
                                                      CommonText(
                                                        content: controller
                                                                    .profileData[
                                                                'applicationStatus'] ??
                                                            "",
                                                        textSize: width * 0.03,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor: controller
                                                                        .profileData[
                                                                    'applicationStatus'] ==
                                                                "Rejected"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                        content: " : ",
                                                        textSize: width * 0.03,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor: Colors.black,
                                                      ),
                                                      CommonText(
                                                        content: controller
                                                                    .profileData[
                                                                'storeLiveStatus'] ??
                                                            "",
                                                        textSize: width * 0.03,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor:
                                                            (controller.profileData[
                                                                            'storeLiveStatus'] ??
                                                                        '') ==
                                                                    'Inactive'
                                                                ? Colors.red
                                                                : Colors.green,
                                                      ),
                                                    ],
                                                  ),
                                                  CommonText(
                                                    content:
                                                        " : ${controller.profileData['applicationStatusDate'] ?? ""}",
                                                    textSize: width * 0.03,
                                                    boldNess: FontWeight.w400,
                                                    textColor:
                                                        AppColors.textColor,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    // await FlutterShare.share(
                                                    //   title: 'Store B2B',
                                                    //   text: "Let's explore",
                                                    //   linkUrl: '',
                                                    // );
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5),
                                                          child: Icon(
                                                            Icons
                                                                .share_outlined,
                                                            size: 18,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            log("log share click");
                                                            bool isLogin = await SharPreferences
                                                                    .getBoolean(
                                                                        SharPreferences
                                                                            .isLogin) ??
                                                                false;

                                                            if (isLogin) {
                                                              log("log share click 1");
                                                              generateDeepLink(
                                                                  context);
                                                            } else {
                                                              Get.dialog(
                                                                  LoginDialog());
                                                            }
                                                          },
                                                          child: CommonText(
                                                            content:
                                                                "Share my store",
                                                            textSize:
                                                                width * 0.03,
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor: AppColors
                                                                .textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.015),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                                collapsedShape: const RoundedRectangleBorder(
                                    side: BorderSide.none),
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide.none),
                                leading: SvgPicture.asset(
                                    'assets/icons/business_details.svg',
                                    fit: BoxFit.cover),
                                collapsedIconColor: AppColors.appGreyShade300,
                                iconColor: AppColors.appGreyShade300,
                                title: const CommonText(
                                  content: "Business Details",
                                  textColor: Color(0xff333333),
                                  textSize: 16,
                                  boldNess: FontWeight.w600,
                                ),
                                childrenPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                children: [
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
                                  controller.selectBusiness == "Medical"
                                      ? CommonDetailsText(
                                          title: "Registered Pharmacist",
                                          details: controller.profileData[
                                                  'registeredPharmacistName'] ??
                                              "")
                                      : const SizedBox()
                                ]),
                          ),
                          SizedBox(height: height * 0.015),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.appGreyShade300,
                              iconColor: AppColors.appGreyShade300,
                              collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: SvgPicture.asset(
                                  'assets/icons/business_details.svg',
                                  fit: BoxFit.cover),
                              title: const CommonText(
                                content: "Bank Details",
                                textColor: Color(0xff333333),
                                textSize: 16,
                                boldNess: FontWeight.w600,
                              ),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              children: [
                                CommonDetailsText(
                                    title: "Account number",
                                    details: controller
                                            .profileData['accountNumber'] ??
                                        ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Account name",
                                    details:
                                        controller.profileData['accuntName'] ??
                                            ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "IFSC code",
                                    details:
                                        controller.profileData['ifsc'] ?? ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Bank branch",
                                    details:
                                        controller.profileData['bankbranch'] ??
                                            ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Bank name",
                                    details:
                                        controller.profileData['bank'] ?? ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "UPI Number",
                                    details: controller
                                            .profileData['upiPhoneNumber'] ??
                                        ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "UPI ID",
                                    details:
                                        controller.profileData['upiId'] ?? ""),
                                SizedBox(height: height * 0.01),
                                // CommonDetailsText(
                                //     title: "Google pay",
                                //     details:
                                //         controller.profileData['googlepay'] ??
                                //             ""),
                                // SizedBox(height: height * 0.01),
                                // CommonDetailsText(
                                //     title: "Phone pay",
                                //     details:
                                //         controller.profileData['phonepay'] ??
                                //             ""),
                                // SizedBox(height: height * 0.01),
                                // CommonDetailsText(
                                //     title: "Paytm",
                                //     details:
                                //         controller.profileData['paytm'] ?? ""),
                                // SizedBox(height: height * 0.01),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.appGreyShade300,
                              iconColor: AppColors.appGreyShade300,
                              collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: SvgPicture.asset(
                                  'assets/icons/contact_us.svg',
                                  fit: BoxFit.cover),
                              title: const CommonText(
                                content: "Contact",
                                textColor: Color(0xff333333),
                                textSize: 16,
                                boldNess: FontWeight.w600,
                              ),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              children: [
                                CommonDetailsText(
                                    title: "Mobile Number",
                                    details:
                                        controller.profileData['phoneNumber'] ??
                                            ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Email",
                                    details:
                                        controller.profileData['email'] ?? ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Application Started date",
                                    details:
                                        controller.profileData['createdAt'] ??
                                            ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Birth Date",
                                    details: controller
                                            .profileData['retailerBirthday'] ??
                                        ""),
                                SizedBox(height: height * 0.01),
                                CommonDetailsText(
                                    title: "Marriage Date",
                                    details: controller.profileData[
                                            'retailerMarriageDay'] ??
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
                                                'storeAddressDetailRequest']?[0]
                                            ?['addressLine1'] ??
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
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.appGreyShade300,
                              iconColor: AppColors.appGreyShade300,
                              collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: SvgPicture.asset(
                                  'assets/icons/lincense.svg',
                                  fit: BoxFit.cover),
                              title: const CommonText(
                                content: "License",
                                textColor: Color(0xff333333),
                                textSize: 16,
                                boldNess: FontWeight.w600,
                              ),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content: "GST",
                                            textSize: width * 0.04,
                                            textColor: AppColors.textColor,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: CommonText(
                                                  content:
                                                      controller.profileData[
                                                                  'gst']
                                                              ?["gstNumber"] ??
                                                          "",
                                                  textSize: width * 0.04,
                                                  textColor:
                                                      AppColors.textColor,
                                                  boldNess: FontWeight.w400,
                                                ),
                                              ),
                                              if (controller.profileData[
                                                      'gstVerifed'] ==
                                                  0) ...[
                                                const InkWell(
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
                                                const InkWell(
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
                                                const InkWell(
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
                                                ?['docUrl'] !=
                                            null &&
                                        controller.profileData['gst']['docUrl']
                                            .isNotEmpty &&
                                        controller.profileData['gst']['docUrl']
                                            .contains('http')) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => Get.to(() =>
                                                  ImageViewScreen(
                                                      image: controller
                                                                  .profileData[
                                                              'gst']['docUrl'] ??
                                                          '')),
                                              child: AppImageAsset(
                                                  image: controller.profileData[
                                                          'gst']['docUrl'] ??
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content: "Store License",
                                            textSize: width * 0.04,
                                            textColor: AppColors.textColor,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: CommonText(
                                                  content: controller
                                                                  .profileData[
                                                              'storeLicense']
                                                          ?["storeLicense"] ??
                                                      "",
                                                  textSize: width * 0.04,
                                                  textColor:
                                                      AppColors.textColor,
                                                  boldNess: FontWeight.w400,
                                                ),
                                              ),
                                              if (controller.profileData[
                                                      'storeLicenseVerifed'] ==
                                                  0) ...[
                                                const InkWell(
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
                                                const InkWell(
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
                                                const InkWell(
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
                                                ?['docUrl'] !=
                                            null &&
                                        controller
                                            .profileData['storeLicense']
                                                ['docUrl']
                                            .isNotEmpty &&
                                        controller.profileData['storeLicense']
                                                ['docUrl']
                                            .contains('http')) ...[
                                      const SizedBox(height: 10),
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
                                                image: controller.profileData[
                                                            'storeLicense']
                                                        ['docUrl'] ??
                                                    '',
                                                height: 100,
                                                width: 130,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                                controller.profileData['storeCategory']
                                        .toString()
                                        .toLowerCase()
                                        .contains('med')
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CommonText(
                                                  content: "Drug License",
                                                  textSize: width * 0.04,
                                                  textColor:
                                                      AppColors.textColor,
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
                                                    Flexible(
                                                      child: CommonText(
                                                        content: controller
                                                                        .profileData[
                                                                    'drugLicense']
                                                                ?[
                                                                "drugLicenseNumber"] ??
                                                            "",
                                                        textSize: width * 0.04,
                                                        textColor:
                                                            AppColors.textColor,
                                                        boldNess:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    if (controller.profileData[
                                                            'drugLicenseVerifed'] ==
                                                        0) ...[
                                                      const InkWell(
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
                                                      const InkWell(
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
                                                      const InkWell(
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
                                          if (controller.profileData[
                                                          'drugLicense']
                                                      ?['documentId'] !=
                                                  null &&
                                              controller
                                                  .profileData['drugLicense']
                                                      ?['documentId']
                                                  .isNotEmpty &&
                                              controller
                                                  .profileData['drugLicense']
                                                      ?['documentId']
                                                  .contains('http')) ...[
                                            const SizedBox(height: 10),
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
                                                                [
                                                                'documentId'] ??
                                                            '',
                                                        height: 100,
                                                        width: 130),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CommonText(
                                                  content:
                                                      "Drug License Expiry Date",
                                                  textSize: width * 0.04,
                                                  textColor:
                                                      AppColors.textColor,
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
                                              Flexible(
                                                child: CommonText(
                                                  content:
                                                      controller.profileData[
                                                                  'drugLicense']
                                                              ?["expiryDate"] ??
                                                          "",
                                                  textSize: width * 0.04,
                                                  textColor:
                                                      AppColors.textColor,
                                                  boldNess: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.appGreyShade300,
                              iconColor: AppColors.appGreyShade300,
                              collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: SvgPicture.asset(
                                  'assets/icons/timing.svg',
                                  fit: BoxFit.cover),
                              title: const CommonText(
                                content: "Store Timing",
                                textColor: Color(0xff333333),
                                textSize: 16,
                                boldNess: FontWeight.w600,
                              ),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              children: [
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
                                    details: controller
                                            .profileData['deliveryStrength'] ??
                                        ""),
                                SizedBox(height: height * 0.03),
                                CommonText(
                                  content: "Slots :",
                                  textSize: width * 0.04,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w500,
                                ),
                                SizedBox(height: height * 0.01),
                                Column(
                                  children: List.generate(
                                    (controller.profileData['slots'] ?? [])
                                        .length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: controller.profileData['slots']
                                                      [index]["isChecked"] ==
                                                  false ||
                                              controller.profileData['slots']
                                                      [index]["isChecked"] ==
                                                  null
                                          ? const SizedBox()
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: CommonText(
                                                    content:
                                                        controller.profileData[
                                                                'slots'][index]
                                                            ["slotName"],
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        AppColors.textColor,
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
                                                        AppColors.textColor,
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
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.55),
                              color: Colors.white,
                              border: Border.all(
                                width: 0.96,
                                color: AppColors.greyBorderColor,
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.appGreyShade300,
                              iconColor: AppColors.appGreyShade300,
                              collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: SvgPicture.asset(
                                  'assets/icons/about_us.svg',
                                  fit: BoxFit.cover),
                              title: const CommonText(
                                content: "Others",
                                textColor: Color(0xff333333),
                                textSize: 16,
                                boldNess: FontWeight.w600,
                              ),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                      content: controller
                                              .profileData['retailerMessage'] ??
                                          "",
                                      textSize: width * 0.04,
                                      textColor: AppColors.textColor,
                                      boldNess: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: height * 0.015),
                          // InkWell(
                          //   onTap: () async {
                          //     await PreferencesHelper().clearPreferenceData();
                          //     Get.offAll(() => LoginScreen());
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       vertical: 10,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //       border: Border.all(
                          //         color: AppColors.primaryColor,
                          //       ),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.only(right: 5),
                          //           child: Icon(
                          //             Icons.exit_to_app_rounded,
                          //             size: 18,
                          //             color: AppColors.primaryColor,
                          //           ),
                          //         ),
                          //         CommonText(
                          //           content: "Log Out",
                          //           textSize: width * 0.04,
                          //           boldNess: FontWeight.w500,
                          //           textColor: AppColors.primaryColor,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: height * 0.04),
                        ],
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
          textColor: AppColors.textColor,
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
