import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_phone_filed_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/profile_controller/edit_profile_controller_new.dart';
import 'package:store_app_b2b/screens/auth/app_pending_screen_new.dart';
import 'package:store_app_b2b/screens/auth/app_process_screen_new.dart';
import 'package:store_app_b2b/screens/auth/app_rejected_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

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
                  icon: Icon(Icons.arrow_back_rounded),
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
                              SizedBox(height: 40),
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
                      const CommonText(content: "Business Type"),
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              editProfileController.selectedBusinessType.value =
                                  0;
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsConst.semiGreyColor),
                                shape: BoxShape.circle,
                              ),
                              child: Obx(
                                () => editProfileController
                                            .selectedBusinessType.value ==
                                        0
                                    ? Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ColorsConst.textColor,
                                          radius: 5,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CommonText(
                              content: "Retailer",
                              textColor: ColorsConst.textColor),
                          SizedBox(width: width * 0.2),
                          InkWell(
                            onTap: () {
                              editProfileController.selectedBusinessType.value =
                                  1;
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsConst.semiGreyColor),
                                shape: BoxShape.circle,
                              ),
                              child: Obx(
                                () => editProfileController
                                            .selectedBusinessType.value ==
                                        1
                                    ? Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ColorsConst.textColor,
                                          radius: 5,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CommonText(
                              content: "Supplier",
                              textColor: ColorsConst.textColor),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          style: TextStyle(color: ColorsConst.textColor),
                          items: editProfileController.businessCategoryList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value["categoryName"],
                              child: CommonText(
                                content: value['categoryName'],
                                textColor: ColorsConst.textColor,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            editProfileController.selectBusiness = value!;
                            for (int i = 0;
                                i <
                                    editProfileController
                                        .businessCategoryList.length;
                                i++) {
                              if (editProfileController.businessCategoryList[i]
                                      ['categoryName'] ==
                                  value) {
                                editProfileController.selectBusinessId =
                                    editProfileController
                                        .businessCategoryList[i]['categoryId'];
                                print(editProfileController.selectBusinessId);
                              }
                            }
                            print(value);
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
                            hintText: "Select Business",
                            hintStyle: GoogleFonts.poppins(
                                color: ColorsConst.hintColor),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Enter Owner Name",
                        hintText: "Enter Owner Name",
                        controller: editProfileController.ownerNameController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Store Name",
                        hintText: "Enter your Store Name",
                        controller: editProfileController.storeNameController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      // CommonTextField(
                      //   content: "Mobile Number",
                      //   hintText: "Enter mobile number",
                      //   controller: editProfileController.phoneController,
                      //   contentColor: ColorsConst.textColor,
                      // ),
                      CommonTextField(
                        controller: editProfileController.phoneController,
                        content: "Mobile Number",
                        hintText: "Enter mobile number",
                        keyboardType: TextInputType.number,
                        contentColor: ColorsConst.textColor,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Email",
                        hintText: "Enter email",
                        controller: editProfileController.emailController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Address",
                        hintText: "Enter Address",
                        controller: editProfileController.addressController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Deals in",
                        hintText: "",
                        controller: editProfileController.dealsInController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        content: "Popular in",
                        hintText: "",
                        controller: editProfileController.popularController,
                        contentColor: ColorsConst.textColor,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        controller: editProfileController.pharmaNameController,
                        content: "Registered Pharmacist Name",
                        hintText: "Enter Pharmacist Name",
                        focusNode: editProfileController.registeredNameFocus,
                        contentColor: ColorsConst.textColor,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextField(
                              content: "GST",
                              hintText: "Enter GST number",
                              controller: editProfileController.gstController,
                              contentColor: ColorsConst.textColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              editProfileController.gstNumber != null
                                  ? editProfileController.gstNumber = null
                                  : Get.bottomSheet(
                                      UploadImageEditView(type: 'gst'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              editProfileController.update();
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: editProfileController.gstNumber ==
                                              null
                                          ? ColorsConst.textColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        editProfileController.gstNumber == null
                                            ? "assets/icons/share.png"
                                            : "assets/icons/done.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      if (editProfileController.gstNumber !=
                                          null)
                                        SizedBox(width: 5),
                                      if (editProfileController.gstNumber !=
                                          null)
                                        AppImageAsset(
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
                              hintText: "Enter License number",
                              controller:
                                  editProfileController.storeLicenseController,
                              contentColor: ColorsConst.textColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              editProfileController.storeLicense != null
                                  ? editProfileController.storeLicense = null
                                  : Get.bottomSheet(
                                      UploadImageEditView(type: 'store'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              editProfileController.update();
                            },
                            child: Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                  color:
                                      editProfileController.storeLicense == null
                                          ? ColorsConst.textColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    editProfileController.storeLicense == null
                                        ? "assets/icons/share.png"
                                        : "assets/icons/done.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  if (editProfileController.storeLicense !=
                                      null)
                                    SizedBox(width: 6),
                                  if (editProfileController.storeLicense !=
                                      null)
                                    AppImageAsset(
                                      image: "assets/icons/delete_icon.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                ],
                              ),
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
                              content: "Drug License",
                              hintText: "Enter License number",
                              controller:
                                  editProfileController.drugLicenseController,
                              contentColor: ColorsConst.textColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          InkWell(
                            onTap: () async {
                              editProfileController.storeDrugLicense != null
                                  ? editProfileController.storeDrugLicense =
                                      null
                                  : Get.bottomSheet(
                                      UploadImageEditView(type: 'drug'),
                                      useRootNavigator: true,
                                      isScrollControlled: true);
                              editProfileController.update();
                            },
                            child: Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                  color:
                                      editProfileController.storeDrugLicense ==
                                              null
                                          ? ColorsConst.textColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    editProfileController.storeDrugLicense ==
                                            null
                                        ? "assets/icons/share.png"
                                        : "assets/icons/done.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  if (editProfileController.storeDrugLicense !=
                                      null)
                                    SizedBox(width: 6),
                                  if (editProfileController.storeDrugLicense !=
                                      null)
                                    AppImageAsset(
                                      image: "assets/icons/delete_icon.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonText(
                        content: "Slots",
                        textColor: ColorsConst.textColor,
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
                                  color: ColorsConst.textColor,
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
                                  color: ColorsConst.textColor,
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
                                  editProfileController
                                          .deliverySlotsList[index].isChecked =
                                      !editProfileController
                                          .deliverySlotsList[index].isChecked;
                                  editProfileController.update();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: editProfileController
                                            .deliverySlotsList[index].isChecked
                                        ? ColorsConst.primaryColor
                                        : ColorsConst.appWhite,
                                    border: Border.all(
                                        color: editProfileController
                                                .deliverySlotsList[index]
                                                .isChecked
                                            ? ColorsConst.primaryColor
                                            : ColorsConst.textColor,
                                        width: 1),
                                  ),
                                  child: const Icon(Icons.done,
                                      color: ColorsConst.appWhite),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CommonTextField(
                        controller: editProfileController.documentController,
                        content: "Document Address",
                        hintText: "Enter Address",
                        focusNode: editProfileController.documentFocus,
                        contentColor: ColorsConst.textColor,
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
                                  dialogBackgroundColor: ColorsConst.greenColor,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.textColor,
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
                                content: 'Store opening time*',
                                textColor: ColorsConst.textColor,
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
                                    border: Border.all(
                                        color: ColorsConst.textColor),
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
                                        color: ColorsConst.textColor),
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
                                  dialogBackgroundColor: ColorsConst.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.textColor,
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
                                  headerText: 'Store closing time*',
                                  headerColor: ColorsConst.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConst.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    focusNode:
                                        editProfileController.storeClosingFocus,
                                    controller: editProfileController
                                        .storeClosingController,
                                    readOnly: true,
                                    style: TextStyle(
                                      color: ColorsConst.textColor,
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
                            helpText: 'Wedding aniversary date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: ColorsConst.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.textColor,
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
                                  headerText: 'Wedding aniversary date :',
                                  headerColor: ColorsConst.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConst.textColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .weddingAniversaryController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ColorsConst.textColor),
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
                            helpText: 'Child 1 Birth date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: ColorsConst.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.textColor,
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
                                  headerText: 'Child 1 Birth date :',
                                  headerColor: ColorsConst.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConst.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .childOneController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ColorsConst.textColor),
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
                            helpText: 'Child 2 Birth date',
                            confirmText: 'okay',
                            cancelText: 'cancel',
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogBackgroundColor: ColorsConst.appWhite,
                                  colorScheme: ColorScheme.light(
                                    primary: ColorsConst.primaryColor,
                                    onSurface: ColorsConst.textColor,
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
                                  headerText: 'Child 2 Birth date :',
                                  headerColor: ColorsConst.textColor),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: true,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConst.textColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: editProfileController
                                        .childTwoController,
                                    readOnly: true,
                                    style: TextStyle(
                                        color: ColorsConst.textColor,
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
                                headerText: 'Delivery strength',
                                headerColor: ColorsConst.textColor),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: ColorsConst.textColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: editProfileController
                                    .deliveryStrengthController,
                                style: TextStyle(color: ColorsConst.textColor),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      AppHeaderText(
                          headerText: 'Message from retailer to customer',
                          headerColor: ColorsConst.textColor),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorsConst.textColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: editProfileController.messageController,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: 5,
                          style: TextStyle(color: ColorsConst.textColor),
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                await editProfileController
                                    .editProfilePostDataApi()
                                    .then((value) {
                                  if (value != null) {
                                    if (screenType == 'reject') {
                                      Get.offAll(AppProcessScreen());
                                    } else {
                                      Get.back();
                                    }
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                  content: "Save",
                                  textSize: width * 0.035,
                                  textColor: Colors.white,
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
                  onTap: () => dashboardController.selectBannerImage(
                      ImageSource.camera, isBack, type),
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
                  onTap: () => dashboardController.selectBannerImage(
                      ImageSource.gallery, isBack, type),
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
