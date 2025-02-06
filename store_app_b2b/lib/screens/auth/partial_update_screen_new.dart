import 'dart:developer';

import 'package:b2c/components/app_image_viewer.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/partial_update_controller_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class PartialUpdateScreen extends StatelessWidget {
  PartialUpdateScreen(
      {super.key, required this.types, required this.profileData});

  final List<String> types;
  final Map<String, dynamic> profileData;

  final PartialUpdateController controller = Get.put(PartialUpdateController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<PartialUpdateController>(initState: (state) {
      log('log profile details inside partial screen ${profileData}');
      //attaching gst fields
      if (profileData.containsKey('gst') && profileData['gst'] != null) {
        controller.gstController.text = profileData['gst']['gstNumber'] ?? '';
        controller.gstUrl = profileData['gst']['docUrl'] ?? '';
      }

      //attaching store fields
      if (profileData.containsKey('storeLicense') &&
          profileData['storeLicense'] != null) {
        controller.storeLicenseController.text =
            profileData['storeLicense']['storeLicense'] ?? '';
        controller.storeLicenseUrl =
            profileData['storeLicense']['docUrl'] ?? '';
      }

      //attaching gst fields
      if (profileData.containsKey('drugLicense') &&
          profileData['drugLicense'] != null) {
        controller.drugLicenseController.text =
            profileData['drugLicense']['drugLicenseNumber'] ?? '';
        controller.drugLicenseUrl =
            profileData['drugLicense']['documentId'] ?? '';
        controller.durgLicenseExpiryController.text =
            profileData["drugLicense"]["expiryDate"];
        controller.pharmaNameController.text =
            profileData["registeredPharmacistName"] ?? '';
      }
    }, builder: (_) {
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/bg.png"),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    //Heading
                    CommonText(content: ""),

                    Gap(20),

                    //GST EDIT FIELDS

                    if (types.contains('gst')) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "GST",
                              hintText: "Enter GST Numbers",
                              controller: controller.gstController,
                              focusNode: controller.gstFocus,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              controller.gstUrl != ""
                                  ? controller.gstUrl = ""
                                  : Get.bottomSheet(
                                      UploadImageViewPartial(type: 'gst'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              controller.update();
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: controller.gstUrl == ""
                                          ? ColorsConst.textColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.gstUrl == ""
                                            ? "assets/icons/share.png"
                                            : "assets/icons/done.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      if (controller.gstUrl != '')
                                        SizedBox(width: 5),
                                      if (controller.gstUrl != '')
                                        AppImageAsset(
                                          image: "assets/icons/delete_icon.png",
                                          color: Colors.white,
                                          height: 16,
                                          width: 16,
                                        ),
                                      if (controller.gstUrl != "")
                                        InkWell(
                                          onTap: () => Get.to(() =>
                                              AppImageViewer(
                                                  imageView:
                                                      controller.gstUrl)),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: AppColors.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Gap(20),
                    ],

                    //STORE LICENSE FIELDS
                    if (types.contains('store')) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "Store License",
                              hintText: "Enter License Numbers",
                              controller: controller.storeLicenseController,
                              focusNode: controller.storeLicenseFocus,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              controller.storeLicenseUrl != ""
                                  ? controller.storeLicenseUrl = ""
                                  : Get.bottomSheet(
                                      UploadImageViewPartial(type: 'store'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: controller.storeLicenseUrl == ""
                                      ? ColorsConst.textColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    controller.storeLicenseUrl == ""
                                        ? "assets/icons/share.png"
                                        : "assets/icons/done.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  if (controller.storeLicenseUrl != "")
                                    SizedBox(width: 6),
                                  if (controller.storeLicenseUrl != "")
                                    AppImageAsset(
                                      image: "assets/icons/delete_icon.png",
                                      height: 16,
                                      width: 16,
                                      color: Colors.white,
                                    ),
                                  if (controller.storeLicenseUrl != "")
                                    InkWell(
                                      onTap: () => Get.to(() => AppImageViewer(
                                          imageView:
                                              controller.storeLicenseUrl)),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: AppColors.primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],

                    //DRUG LICENSE FEILDS
                    if (types.contains('drug')) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "Drug License*",
                              hintText: "Enter License Copy",
                              controller: controller.drugLicenseController,
                              focusNode: controller.drugLicenseFocus,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              controller.drugLicenseUrl != ""
                                  ? controller.drugLicenseUrl = ""
                                  : Get.bottomSheet(
                                      UploadImageViewPartial(type: 'drug'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              controller.update();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: controller.drugLicenseUrl == ''
                                      ? ColorsConst.textColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    controller.drugLicenseUrl == ''
                                        ? "assets/icons/share.png"
                                        : "assets/icons/done.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  if (controller.drugLicenseUrl != '')
                                    SizedBox(width: 6),
                                  if (controller.drugLicenseUrl != '')
                                    AppImageAsset(
                                      image: "assets/icons/delete_icon.png",
                                      height: 16,
                                      width: 16,
                                      color: Colors.white,
                                    ),
                                  if (controller.drugLicenseUrl != "")
                                    InkWell(
                                      onTap: () => Get.to(() => AppImageViewer(
                                          imageView:
                                              controller.drugLicenseUrl)),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Center(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            lastDate: DateTime(DateTime.now().year + 100, 1),
                            firstDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            helpText: 'Drug License Expiry Date',
                            confirmText: 'Okay',
                            cancelText: 'Cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: ColorsConst.textColor,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.appWhite,
                                  ),
                                  dialogTheme: DialogTheme(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 2,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.durgLicenseExpiryController.text =
                                DateTimeUtils.getFormattedDateTime(picked);
                            controller.update();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: const AppHeaderText(
                                  headerText: 'Drug License Expiry :',
                                  headerColor: ColorsConst.appWhite),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConst.greyBgColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    focusNode:
                                        controller.drugLicenseExpiryFocus,
                                    controller:
                                        controller.durgLicenseExpiryController,
                                    readOnly: true,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: ColorsConst.appWhite),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CommonTextField(
                        controller: controller.pharmaNameController,
                        content: "Registered Pharmacist Name*",
                        hintText: "Enter Pharmacist Name",
                        focusNode: controller.registeredNameFocus,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                      )
                    ],
                  ],
                ),
              ),

              //bottom update profile button
              GestureDetector(
                onTap: () {
                  controller.validate(types);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: ColorsConst.primaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: CommonText(
                      content: "Update Profile",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class UploadImageViewPartial extends StatelessWidget {
  final dashboardController = Get.find<PartialUpdateController>();
  final bool isBack;
  final String? type;

  UploadImageViewPartial({Key? key, this.isBack = false, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorsConst.appWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 22),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 10),
            child: CommonText(
                content: 'Select store cover image',
                textSize: 16,
                textColor: ColorsConst.textColor,
                boldNess: FontWeight.w600),
          ),
          Divider(color: ColorsConst.textColor, thickness: 1, height: 0),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async => await dashboardController
                      .selectBannerImage(ImageSource.camera, isBack, type),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: ColorsConst.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: ColorsConst.semiGreyColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/camera.svg",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 20),
                        CommonText(
                          content: 'camera',
                          textSize: 16,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async => await dashboardController
                      .selectBannerImage(ImageSource.gallery, isBack, type),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: ColorsConst.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: ColorsConst.appBoxShadow,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/gallery.png",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 20),
                        CommonText(
                          content: 'gallery',
                          textSize: 16,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
