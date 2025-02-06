import 'package:b2c/components/common_text.dart';
import 'package:b2c/components/common_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/common_primary_button.dart';
import '../../constants/colors_const.dart';
import '../../controllers/auth_controller/signup_controller.dart';
import '../../widget/app_image_assets.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<SignupController>(
        init: SignupController(),
        initState: (state) {
          signupController.getCategory();
          signupController.getDeliverySlots();
        },
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/image/bg.png"),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: height * 0.02),
                        // Container(
                        //   height: height / 5.7,
                        //   width: width / 1.3,
                        //   alignment: Alignment.topLeft,
                        //   child: Image.asset("assets/image/text.png"),
                        // ),
                        SizedBox(height: height * 0.05),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Get.bottomSheet(
                                        UploadImageView(isBack: true),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 50),
                                        child: const Align(
                                          alignment: Alignment.centerRight,
                                          child: AppImageAsset(
                                              image: "assets/icons/camera.svg",
                                              height: 35,
                                              width: 35),
                                        ),
                                      ),
                                      if (signupController.storeBackImage !=
                                              null &&
                                          signupController
                                              .storeBackImage!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: AppImageAsset(
                                              image: signupController
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
                                  UploadImageView(isBack: false),
                                  useRootNavigator: true,
                                  isScrollControlled: true),
                              child: Container(
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
                                  child: (signupController.storeFrontImage !=
                                              null &&
                                          signupController
                                              .storeFrontImage!.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: AppImageAsset(
                                              image: signupController
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
                        // CommonTextField(
                        //   controller: signupController.userNameController,
                        //   content: "User Name",
                        //   hintText: "E-mail address / User ID",
                        //   focusNode: signupController.userNameFocusNode,
                        //   keyboardType: TextInputType.emailAddress,
                        // ),
                        /*SizedBox(height: height * 0.02),
                         const CommonText(content: "Business Type"),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                signupController.selectedBusinessType.value =
                                    "Retailer";
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.semiGreyColor),
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () => signupController
                                              .selectedBusinessType.value ==
                                          "Retailer"
                                      ? const Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 5,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CommonText(content: "Retailer"),
                            SizedBox(width: width * 0.2),
                            InkWell(
                              onTap: () {
                                signupController.selectedBusinessType.value =
                                    "Supplier";
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.semiGreyColor),
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () => signupController
                                              .selectedBusinessType.value ==
                                          "Supplier"
                                      ? const Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 5,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CommonText(content: "Supplier"),
                          ],
                        ),*/
                        SizedBox(height: height * 0.02),
                        const CommonText(
                          content: "Business",
                          textColor: Colors.white,
                          boldNess: FontWeight.w500,
                        ),
                        SizedBox(height: height * 0.02),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            dropdownColor: AppColors.notificationTextColor,
                            items: signupController.businessCategoryList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value["categoryName"],
                                child:
                                    CommonText(content: value['categoryName']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              signupController.selectBusiness =
                                  value.toString();
                              for (int i = 0;
                                  i <
                                      signupController
                                          .businessCategoryList.length;
                                  i++) {
                                if (signupController.businessCategoryList[i]
                                        ['categoryName'] ==
                                    value) {
                                  signupController.selectBusinessId =
                                      signupController.businessCategoryList[i]
                                          ['categoryId'];

                                  signupController.selectBusinessStatus.value =
                                      signupController.businessCategoryList[i]
                                          ['medicalCategory'];

                                  print(signupController.selectBusinessId);
                                }
                              }
                              print(value);
                              signupController.update();
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
                              hintStyle: GoogleFonts.poppins(
                                  color: AppColors.hintColor),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.storeNameController,
                          content: "Store Name*",
                          hintText: "Enter Your Store Name",
                          focusNode: signupController.storeNameFocus,
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.storeNumberController,
                          content: "Store Number*",
                          hintText: 'Enter Store Number',
                          focusNode: signupController.storeNumberFocus,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.ownerNameController,
                          content: 'Owner Name*',
                          hintText: 'Enter Owner Name',
                          focusNode: signupController.ownerNameFocus,
                        ),
                        SizedBox(height: height * 0.02),

                        CommonTextField(
                          controller: signupController.phoneController,
                          content: "Mobile Number*",
                          hintText: "Enter Mobile Number",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          focusNode: signupController.phoneFocusNode,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: height * 0.02),
                        Obx(
                          () => CommonTextField(
                            controller: signupController.passwordController,
                            content: "Password*",
                            hintText: "Enter Password",
                            focusNode: signupController.passwordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !signupController.password.value,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signupController.password.value =
                                    !signupController.password.value;
                              },
                              child: Icon(
                                  signupController.password.value == false
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Obx(
                          () => CommonTextField(
                            controller:
                                signupController.confirmPasswordController,
                            content: "Confirm Password*",
                            hintText: "Enter Password",
                            focusNode: signupController.confirmPasswordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                !signupController.confirmPassword.value,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signupController.confirmPassword.value =
                                    !signupController.confirmPassword.value;
                              },
                              child: Icon(
                                  signupController.confirmPassword.value ==
                                          false
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.emailController,
                          content: "Email*",
                          hintText: "Enter Your Email Address",
                          focusNode: signupController.emailFocus,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: height * 0.02),

                        // CommonTextField(
                        //   controller: signupController.areaController,
                        //   content: "Area",
                        //   hintText: "Enter Your Area",
                        //   focusNode: signupController.areaFocus,
                        // ),
                        // SizedBox(height: height * 0.02),
                        // CommonTextField(
                        //   controller: signupController.addressController,
                        //   content: "Address",
                        //   hintText: "Enter Your Address",
                        //   focusNode: signupController.addressFocus,
                        // ),
                        // SizedBox(height: height * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CommonTextField(
                                content: "GST",
                                hintText: "Enter GST Numbers",
                                controller: signupController.gstController,
                                focusNode: signupController.gstFocus,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            InkWell(
                              onTap: () async {
                                signupController.gstNumber != null
                                    ? signupController.gstNumber = null
                                    : Get.bottomSheet(
                                        UploadImageView(type: 'gst'),
                                        useRootNavigator: true,
                                        isScrollControlled: true);
                                signupController.update();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 46,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 12),
                                    decoration: BoxDecoration(
                                        color:
                                            signupController.gstNumber == null
                                                ? AppColors.textColor
                                                : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          signupController.gstNumber == null
                                              ? "assets/icons/share.png"
                                              : "assets/icons/done.png",
                                          height: 16,
                                          width: 16,
                                        ),
                                        if (signupController.gstNumber != null)
                                          const SizedBox(width: 5),
                                        if (signupController.gstNumber != null)
                                          const AppImageAsset(
                                            image:
                                                "assets/icons/delete_icon.png",
                                            color: Colors.white,
                                            height: 16,
                                            width: 16,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CommonTextField(
                                content: "Store License",
                                hintText: "Enter License Numbers",
                                controller:
                                    signupController.storeLicenseController,
                                focusNode: signupController.storeLicenseFocus,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            InkWell(
                              onTap: () async {
                                signupController.storeLicense != null
                                    ? signupController.storeLicense = null
                                    : Get.bottomSheet(
                                        UploadImageView(type: 'store'),
                                        useRootNavigator: true,
                                        isScrollControlled: true);
                                signupController.update();
                              },
                              child: Container(
                                height: 46,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: signupController.storeLicense == null
                                        ? AppColors.textColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      signupController.storeLicense == null
                                          ? "assets/icons/share.png"
                                          : "assets/icons/done.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                    if (signupController.storeLicense != null)
                                      const SizedBox(width: 6),
                                    if (signupController.storeLicense != null)
                                      const AppImageAsset(
                                        image: "assets/icons/delete_icon.png",
                                        height: 16,
                                        width: 16,
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        signupController.selectBusinessStatus.value == "Y"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: CommonTextField(
                                      content: "Drug License",
                                      hintText: "Enter License Copy",
                                      controller: signupController
                                          .drugLicenseController,
                                      focusNode:
                                          signupController.drugLicenseFocus,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  InkWell(
                                    onTap: () async {
                                      signupController.storeDrugLicense != null
                                          ? signupController.storeDrugLicense =
                                              null
                                          : Get.bottomSheet(
                                              UploadImageView(type: 'drug'),
                                              useRootNavigator: true,
                                              isScrollControlled: true);
                                      signupController.update();
                                    },
                                    child: Container(
                                      height: 46,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: signupController
                                                      .storeDrugLicense ==
                                                  null
                                              ? AppColors.textColor
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            signupController.storeDrugLicense ==
                                                    null
                                                ? "assets/icons/share.png"
                                                : "assets/icons/done.png",
                                            height: 16,
                                            width: 16,
                                          ),
                                          if (signupController
                                                  .storeDrugLicense !=
                                              null)
                                            const SizedBox(width: 6),
                                          if (signupController
                                                  .storeDrugLicense !=
                                              null)
                                            const AppImageAsset(
                                              image:
                                                  "assets/icons/delete_icon.png",
                                              height: 16,
                                              width: 16,
                                              color: Colors.white,
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(height: height * 0.02),
                        signupController.selectBusinessStatus.value == "Y"
                            ? CommonTextField(
                                controller:
                                    signupController.pharmaNameController,
                                content: "Registered Pharmacist Name",
                                hintText: "Enter Pharmacist Name",
                                focusNode: signupController.registeredNameFocus,
                              )
                            : const SizedBox(),

                        SizedBox(height: height * 0.05),
                        CommonPrimaryButton(
                          text: "Next",
                          onTap: () {
                            signupController.registerUser();
                            // Get.to(() => MobileNoScreen());
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.poppins(
                                  color: AppColors.hintColor),
                              children: [
                                TextSpan(
                                  text: "LOGIN",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Center(
                        //   child: CommonText(
                        //     content:
                        //         "Terms and Conditions applied. Privacy policy",
                        //     textSize: width * 0.032,
                        //   ),
                        // ),
                        SizedBox(height: height * 0.015),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UploadImageView extends StatelessWidget {
  final dashboardController = Get.find<SignupController>();
  final bool isBack;
  final String? type;

  UploadImageView({Key? key, this.isBack = false, this.type}) : super(key: key);

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
                  onTap: () async => await dashboardController
                      .selectBannerImage(ImageSource.camera, isBack, type),
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
                  onTap: () async => await dashboardController
                      .selectBannerImage(ImageSource.gallery, isBack, type),
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
