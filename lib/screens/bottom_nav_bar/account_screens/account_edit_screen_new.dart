import 'package:b2c/components/app_image_viewer_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/components/common_text_field_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller_new.dart';
import 'package:b2c/screens/auth/app_process_screen_new.dart';
import 'package:b2c/screens/auth/otp_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/otp_edit_screen_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/sign_up_2_screen_new.dart';

class NoLeadingSpaceInputFormatter1 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      // Prevent input if the first character is a space
      return oldValue;
    }
    return newValue;
  }
}

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key, this.screenType}) : super(key: key);
  String? screenType = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<EditProfileController>(
        init: EditProfileController(),
        initState: (state) async {},
        builder: (editProfileController) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: CommonText(
                  content: "Profile edit",
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
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await Get.bottomSheet(
                                      UploadImageEditView(isBack: true),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                                },
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: const Align(
                                        alignment: Alignment.centerRight,
                                        child: AppImageAsset(
                                            image: "assets/icons/camera.svg",
                                            height: 35,
                                            width: 35),
                                      ),
                                    ),
                                    if (editProfileController.storeBackImage !=
                                            null &&
                                        editProfileController
                                            .storeBackImage!.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: AppImageAsset(
                                            image: editProfileController
                                                .storeBackImage,
                                            height: 130,
                                            width: width),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                          InkWell(
                            onTap: () => Get.bottomSheet(
                                UploadImageEditView(isBack: false),
                                useRootNavigator: true,
                                isScrollControlled: true),
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                                child: (editProfileController.storeFrontImage !=
                                            null &&
                                        editProfileController
                                            .storeFrontImage!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500),
                                        child: AppImageAsset(
                                            image: editProfileController
                                                .storeFrontImage,
                                            height: 100,
                                            width: 100),
                                      )
                                    : const AppImageAsset(
                                        image: "assets/icons/camera.svg",
                                        height: 24,
                                        width: 32),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      // const CommonText(content: "Business Type"),
                      // SizedBox(height: height * 0.01),
                      // Row(
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         editProfileController.selectedBusinessType.value =
                      //             0;
                      //       },
                      //       child: Container(
                      //         height: 20,
                      //         width: 20,
                      //         decoration: BoxDecoration(
                      //           border:
                      //               Border.all(color: AppColors.semiGreyColor),
                      //           shape: BoxShape.circle,
                      //         ),
                      //         child: Obx(
                      //           () => editProfileController
                      //                       .selectedBusinessType.value ==
                      //                   0
                      //               ? Center(
                      //                   child: CircleAvatar(
                      //                     backgroundColor: AppColors.textColor,
                      //                     radius: 5,
                      //                   ),
                      //                 )
                      //               : const SizedBox(),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     CommonText(
                      //         content: "Retailer",
                      //         textColor: AppColors.textColor),
                      //     SizedBox(width: width * 0.2),
                      //     InkWell(
                      //       onTap: () {
                      //         editProfileController.selectedBusinessType.value =
                      //             1;
                      //       },
                      //       child: Container(
                      //         height: 20,
                      //         width: 20,
                      //         decoration: BoxDecoration(
                      //           border:
                      //               Border.all(color: AppColors.semiGreyColor),
                      //           shape: BoxShape.circle,
                      //         ),
                      //         child: Obx(
                      //           () => editProfileController
                      //                       .selectedBusinessType.value ==
                      //                   1
                      //               ? Center(
                      //                   child: CircleAvatar(
                      //                     backgroundColor: AppColors.textColor,
                      //                     radius: 5,
                      //                   ),
                      //                 )
                      //               : const SizedBox(),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     CommonText(
                      //         content: "Supplier",
                      //         textColor: AppColors.textColor),
                      //   ],
                      // ),
                      // SizedBox(height: height * 0.02),
                      // CommonText(
                      //   content: "Business",
                      //   textColor: AppColors.textColor,
                      //   boldNess: FontWeight.w600,
                      // ),
                      // SizedBox(height: height * 0.01),
                      // ButtonTheme(
                      //   alignedDropdown: true,
                      //   child: DropdownButtonFormField(
                      //     style: TextStyle(color: AppColors.textColor),
                      //     hint: CommonText(
                      //       content: editProfileController.selectBusiness,
                      //       textColor: AppColors.textColor,
                      //     ),
                      //     items: editProfileController.businessCategoryList
                      //         .map<DropdownMenuItem<String>>((value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value["categoryName"],
                      //         child: CommonText(
                      //           content: value['categoryName'],
                      //           textColor: AppColors.textColor,
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (value) {
                      //       editProfileController.selectBusiness =
                      //           value.toString();
                      //       for (int i = 0;
                      //           i <
                      //               editProfileController
                      //                   .businessCategoryList.length;
                      //           i++) {
                      //         if (editProfileController.businessCategoryList[i]
                      //                 ['categoryName'] ==
                      //             value) {
                      //           editProfileController.selectBusinessId =
                      //               editProfileController
                      //                   .businessCategoryList[i]['categoryId'];
                      //           print(editProfileController.selectBusinessId);
                      //         }
                      //       }
                      //       print(value);
                      //     },
                      //     decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 10, horizontal: 20),
                      //       border: OutlineInputBorder(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           color: AppColors.semiGreyColor,
                      //           width: 1,
                      //         ),
                      //       ),
                      //       disabledBorder: OutlineInputBorder(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           color: AppColors.semiGreyColor,
                      //           width: 1,
                      //         ),
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           color: AppColors.semiGreyColor,
                      //           width: 1,
                      //         ),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           color: AppColors.semiGreyColor,
                      //           width: 1,
                      //         ),
                      //       ),
                      //       errorBorder: OutlineInputBorder(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           color: AppColors.semiGreyColor,
                      //           width: 1,
                      //         ),
                      //       ),
                      //       hintText: "Select Business",
                      //       hintStyle:
                      //           GoogleFonts.poppins(color: AppColors.hintColor),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Enter Owner Name*",
                        hintText: "Enter Owner Name",
                        controller: editProfileController.ownerNameController,
                        contentColor: AppColors.textColor,
                        readOnly: false,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Store Name*",
                        hintText: "Enter your Store Name",
                        controller: editProfileController.storeNameController,
                        contentColor: AppColors.textColor,
                        readOnly: true,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Store Mobile Number*",
                        hintText: "Enter Store mobile number",
                        controller: editProfileController.storeNumberController,
                        contentColor: AppColors.textColor,
                        readOnly: true,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Mobile Number",
                        hintText: "Enter mobile number",
                        controller: editProfileController.phoneController,
                        contentColor: AppColors.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Email*",
                        hintText: "Enter email",
                        controller: editProfileController.emailController,
                        contentColor: AppColors.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Address*",
                        hintText: "Enter Address",
                        controller: editProfileController.addressController,
                        contentColor: AppColors.textColor,
                        enabled: true,
                        readOnly: true,
                        onTap: () {
                          print(">>>>>>>>>>>>");
                          Get.to(() => MapScreen(status: "edit"));
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "State*",
                        hintText: "",
                        focusNode: editProfileController.stateFocus,
                        controller: editProfileController.stateController,
                        contentColor: AppColors.textColor,
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                          NoLeadingSpaceInputFormatter1(), // Allows only alphabets and spaces
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Pincode*",
                        hintText: "",
                        focusNode: editProfileController.pincodeFocus,
                        controller: editProfileController.pincodeController,
                        contentColor: AppColors.textColor,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Deals In",
                        hintText: "",
                        controller: editProfileController.dealsInController,
                        contentColor: AppColors.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Popular In",
                        hintText: "",
                        controller: editProfileController.popularController,
                        contentColor: AppColors.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      editProfileController.selectBusiness
                              .toLowerCase()
                              .contains('medi')
                          ? CommonTextField(
                              controller:
                                  editProfileController.pharmaNameController,
                              content: "Registered Pharmacist Name*",
                              hintText: "Enter Pharmacist Name",
                              focusNode:
                                  editProfileController.registeredNameFocus,
                              contentColor: AppColors.textColor,
                              readOnly: true,
                            )
                          : const SizedBox(),
                      editProfileController.selectBusiness
                              .toLowerCase()
                              .contains('medi')
                          ? SizedBox(height: height * 0.02)
                          : SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "GST",
                              hintText: "Enter GST number",
                              controller: editProfileController.gstController,
                              contentColor: AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          // if ((editProfileController
                          //             .profileData['applicationStatus'] ??
                          //         "") ==
                          //     'Rejected') ...[
                          InkWell(
                            onTap: () async {
                              editProfileController.gstNumber != ""
                                  ? editProfileController.gstNumber = ""
                                  : Get.bottomSheet(
                                      UploadImageEditView(type: 'gst'),
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                    );

                              editProfileController.update();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color:
                                          editProfileController.gstNumber == ""
                                              ? AppColors.textColor
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        editProfileController.gstNumber == ""
                                            ? "assets/icons/share.png"
                                            : "assets/icons/done.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      if (editProfileController.gstNumber != "")
                                        const SizedBox(width: 5),
                                      if (editProfileController.gstNumber != "")
                                        const AppImageAsset(
                                          image: "assets/icons/delete_icon.png",
                                          // color: Colors.white,
                                          height: 16,
                                          width: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ],
                          if ((editProfileController
                                          .profileData['applicationStatus'] ??
                                      "") !=
                                  'Rejected' &&
                              editProfileController.gstNumber != "")
                            InkWell(
                              onTap: () => Get.to(() => AppImageViewer(
                                  // imageView: editProfileController
                                  //     .profileData['gst']['docUrl'])),
                                  imageView: editProfileController.gstNumber)),
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.remove_red_eye,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "Store License",
                              hintText: "Enter License number",
                              controller:
                                  editProfileController.storeLicenseController,
                              contentColor: AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          // if ((editProfileController
                          //             .profileData['applicationStatus'] ??
                          //         "") ==
                          //     'Rejected') ...[
                          InkWell(
                            onTap: () async {
                              editProfileController.storeLicense != ""
                                  ? editProfileController.storeLicense = ""
                                  : Get.bottomSheet(
                                      UploadImageEditView(type: 'store'),
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                    );

                              editProfileController.update();
                            },
                            child: Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                  color:
                                      editProfileController.storeLicense == ""
                                          ? AppColors.textColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    editProfileController.storeLicense == ""
                                        ? "assets/icons/share.png"
                                        : "assets/icons/done.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  if (editProfileController.storeLicense != "")
                                    const SizedBox(width: 6),
                                  if (editProfileController.storeLicense != "")
                                    const AppImageAsset(
                                      image: "assets/icons/delete_icon.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // ],
                          if ((editProfileController
                                          .profileData['applicationStatus'] ??
                                      "") !=
                                  'Rejected' &&
                              editProfileController.storeLicense != "")
                            InkWell(
                              onTap: () => Get.to(() => AppImageViewer(
                                  // imageView: editProfileController
                                  //     .profileData['storeLicense']['docUrl'])),
                                  imageView:
                                      editProfileController.storeLicense)),
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.remove_red_eye,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      editProfileController.selectBusiness
                              .toLowerCase()
                              .contains('medi')
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: CommonTextField(
                                    content: "Drug License",
                                    hintText: "Enter License number",
                                    controller: editProfileController
                                        .drugLicenseController,
                                    contentColor: AppColors.textColor,
                                    readOnly: true,
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                // if ((editProfileController
                                //             .profileData['applicationStatus'] ??
                                //         "") ==
                                //     'Rejected')
                                // InkWell(
                                //   onTap: () async {
                                //     editProfileController.storeDrugLicense != ""
                                //         ? editProfileController
                                //             .storeDrugLicense = ""
                                //         : Get.bottomSheet(
                                //             UploadImageEditView(type: 'drug'),
                                //             useRootNavigator: true,
                                //             isScrollControlled: true,
                                //           );
                                //     editProfileController.update();
                                //   },
                                //   child: Container(
                                //     height: 46,
                                //     padding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 12),
                                //     decoration: BoxDecoration(
                                //       color: editProfileController
                                //                   .storeDrugLicense ==
                                //               ""
                                //           ? AppColors.textColor
                                //           : Colors.transparent,
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: Row(
                                //       children: [
                                //         Image.asset(
                                //           editProfileController
                                //                       .storeDrugLicense ==
                                //                   ""
                                //               ? "assets/icons/share.png"
                                //               : "assets/icons/done.png",
                                //           height: 16,
                                //           width: 16,
                                //         ),
                                //         if (editProfileController
                                //                 .storeDrugLicense !=
                                //             "")
                                //           const SizedBox(width: 6),
                                //         if (editProfileController
                                //                 .storeDrugLicense !=
                                //             "")
                                //           const AppImageAsset(
                                //             image:
                                //                 "assets/icons/delete_icon.png",
                                //             height: 16,
                                //             width: 16,
                                //           ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                if ((editProfileController.profileData[
                                                'applicationStatus'] ??
                                            "") !=
                                        'Rejected' &&
                                    editProfileController.storeDrugLicense !=
                                        "")
                                  InkWell(
                                    onTap: () => Get.to(() => AppImageViewer(
                                        imageView: editProfileController
                                            //     .profileData['drugLicense']
                                            // ['documentId'])),
                                            .storeDrugLicense)),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Icon(Icons.remove_red_eye,
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(height: height * 0.02),
                      editProfileController.selectBusiness
                              .toLowerCase()
                              .contains('medi')
                          ? InkWell(
                              onTap: () async {
                                // final DateTime? picked = await showDatePicker(
                                //   context: context,
                                //   firstDate: DateTime.now(),
                                //   lastDate:
                                //       DateTime(DateTime.now().year + 100, 1),
                                //   initialDate: DateTime.now(),
                                //   helpText: 'Drug License Expiry',
                                //   confirmText: 'okay',
                                //   cancelText: 'cancel',
                                //   builder: (context, child) {
                                //     return Theme(
                                //       data: ThemeData(
                                //         dialogBackgroundColor:
                                //             AppColors.appWhite,
                                //         colorScheme: ColorScheme.light(
                                //           primary: AppColors.primaryColor,
                                //           onSurface: AppColors.textColor,
                                //         ),
                                //         dialogTheme: DialogTheme(
                                //           shape: RoundedRectangleBorder(
                                //               borderRadius:
                                //                   BorderRadius.circular(20)),
                                //           elevation: 2,
                                //         ),
                                //       ),
                                //       child: child!,
                                //     );
                                //   },
                                // );
                                // if (picked != null) {
                                //   editProfileController
                                //           .drugLicenseExpiryController.text =
                                //       DateTimeUtils.getFormattedDateTime(
                                //           picked);
                                //   editProfileController.update();
                                // }
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width / 2,
                                    child: AppHeaderText(
                                        headerText: 'Drug License Expiry :',
                                        headerColor: AppColors.textColor),
                                  ),
                                  Expanded(
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.textColor),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: TextFormField(
                                          controller: editProfileController
                                              .drugLicenseExpiryController,
                                          readOnly: true,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textColor),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(height: height * 0.02),
                      CommonText(
                        content: "Slots",
                        textColor: AppColors.textColor,
                        boldNess: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              editProfileController.deliverySlotsList.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  editProfileController
                                      .deliverySlotsList[index].slotName
                                      .toString(),
                                  color: AppColors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              editProfileController.deliverySlotsList.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  ' : ${editProfileController.deliverySlotsList[index].startTime} - ${editProfileController.deliverySlotsList[index].endTime}',
                                  color: AppColors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              editProfileController.deliverySlotsList.length,
                              (index) => InkWell(
                                onTap: () {
                                  editProfileController.deliverySlotsList[index]
                                      .isChecked = editProfileController
                                              .deliverySlotsList[index]
                                              .isChecked ==
                                          "Y"
                                      ? "N"
                                      : "Y";
                                  editProfileController.update();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: editProfileController
                                                .deliverySlotsList[index]
                                                .isChecked ==
                                            "Y"
                                        ? AppColors.primaryColor
                                        : AppColors.appWhite,
                                    border: Border.all(
                                        color: editProfileController
                                                    .deliverySlotsList[index]
                                                    .isChecked ==
                                                "Y"
                                            ? AppColors.primaryColor
                                            : AppColors.textColor,
                                        width: 1),
                                  ),
                                  child: const Icon(Icons.done,
                                      color: AppColors.appWhite),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        controller: editProfileController.documentController,
                        content: "Document Address*",
                        hintText: "Enter Address",
                        focusNode: editProfileController.documentFocus,
                        contentColor: AppColors.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            confirmText: 'Confirm',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.greenColor,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
                                  ),
                                  // fontFamily: AppAssets.defaultFont,
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
                          editProfileController.storeOpeningController.text =
                              time!.format(Get.context!);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: CommonText(
                                content: 'Store Opening Time*',
                                textColor: AppColors.textColor,
                                boldNess: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    focusNode:
                                        editProfileController.storeOpeningFocus,
                                    controller: editProfileController
                                        .storeOpeningController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textColor),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            confirmText: 'Confirm',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
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
                          editProfileController.storeClosingController.text =
                              time!.format(Get.context!);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: AppHeaderText(
                                  headerText: 'Store Closing Time*',
                                  headerColor: AppColors.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    focusNode:
                                        editProfileController.storeClosingFocus,
                                    controller: editProfileController
                                        .storeClosingController,
                                    readOnly: true,
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 13,
                                    ),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            helpText: 'Retailer Birthdate',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
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
                            editProfileController
                                    .retailerBirthdateController.text =
                                DateTimeUtils.getFormattedDateTime(picked);
                            editProfileController.update();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: AppHeaderText(
                                  headerText: 'Retailer Birthdate :',
                                  headerColor: AppColors.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .retailerBirthdateController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textColor),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            helpText: 'Wedding Aniversary Date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
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
                            editProfileController
                                    .weddingAniversaryController.text =
                                DateTimeUtils.getFormattedDateTime(picked);
                            editProfileController.update();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: AppHeaderText(
                                  headerText: 'Wedding Aniversary Date :',
                                  headerColor: AppColors.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .weddingAniversaryController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textColor),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            helpText: 'Child 1 Birth Date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
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
                            editProfileController.childOneController.text =
                                DateTimeUtils.getFormattedDateTime(picked);
                            editProfileController.update();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: AppHeaderText(
                                  headerText: 'Child 1 Birth Date :',
                                  headerColor: AppColors.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .childOneController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textColor),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            helpText: 'Child 2 Birth Date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: AppColors.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                    onSurface: AppColors.textColor,
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
                            editProfileController.childTwoController.text =
                                DateTimeUtils.getFormattedDateTime(picked);
                            editProfileController.update();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: AppHeaderText(
                                  headerText: 'Child 2 Birth Date :',
                                  headerColor: AppColors.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .childTwoController,
                                    readOnly: true,
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 13),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: width / 2,
                            child: AppHeaderText(
                                headerText: 'Delivery Strength',
                                headerColor: AppColors.textColor),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.textColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: editProfileController
                                    .deliveryStrengthController,
                                style: TextStyle(color: AppColors.textColor),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      AppHeaderText(
                          headerText: 'Message From Retailer To Customer',
                          headerColor: AppColors.textColor),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: editProfileController.messageController,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: 5,
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.black),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                  content: "Cancel",
                                  textSize: width * 0.035,
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  await editProfileController
                                      .editValidation(screenType);
                                  print(screenType);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: editProfileController.isLoading.value
                                      ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 10,
                                        )
                                      : CommonText(
                                          content: "Save",
                                          textSize: width * 0.035,
                                          textColor: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class UploadImageEditView extends StatelessWidget {
  final dashboardController = Get.find<EditProfileController>();
  final bool isBack;
  final String? type;

  UploadImageEditView({Key? key, this.isBack = false, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.appWhite,
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
                textColor: AppColors.textColor,
                boldNess: FontWeight.w600),
          ),
          Divider(color: AppColors.textColor, thickness: 1, height: 0),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => dashboardController.selectBannerImage(
                      ImageSource.camera, isBack, type),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: AppColors.semiGreyColor,
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
                          textColor: AppColors.textColor,
                          boldNess: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => dashboardController.selectBannerImage(
                      ImageSource.gallery, isBack, type),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: AppColors.appBoxShadow,
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
                          textColor: AppColors.textColor,
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
