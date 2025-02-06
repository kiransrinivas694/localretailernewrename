import 'package:b2c/components/common_primary_button.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/account_edit_screen.dart';
import 'package:b2c/widget/app_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../components/common_text.dart';
import '../../components/common_text_field.dart';
import '../../controllers/auth_controller/signup_controller.dart';

class SignUp2Screen extends StatelessWidget {
  SignUp2Screen({Key? key}) : super(key: key);
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
          initState: (state) async {
            await signupController.getDeliverySlots();
          },
          builder: (signupController) {
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
                          SizedBox(height: height * 0.02),
                          Container(
                            height: height / 5.7,
                            width: width / 1.3,
                            alignment: Alignment.topLeft,
                            child: Image.asset("assets/image/text.png"),
                          ),
                          SizedBox(height: height * 0.03),
                          CommonTextField(
                            controller: signupController.documentController,
                            content: "Document Address",
                            hintText: "Enter Address",
                            focusNode: signupController.documentFocus,
                          ),
                          SizedBox(height: height * 0.02),
                          CommonTextField(
                            controller: signupController.landmarkController,
                            content: "Landmark",
                            hintText: "Enter Landmark",
                            focusNode: signupController.landmarkFocus,
                          ),
                          SizedBox(height: height * 0.02),
                          CommonTextField(
                            controller:
                                signupController.storeLocationController,
                            content: 'Store Location*',
                            hintText: 'Location Address*',
                            readOnly: true,
                            focusNode: signupController.storeAddressFocus,
                            onTap: () =>
                                Get.to(() => MapScreen(status: "register")),
                          ),
                          SizedBox(height: height * 0.02),
                          CommonTextField(
                            controller: signupController.dealsInController,
                            content: 'Deals in',
                            hintText: "",
                            focusNode: signupController.dealsInFocus,
                          ),
                          SizedBox(height: height * 0.02),
                          CommonTextField(
                            controller: signupController.popularController,
                            content: 'Popular in',
                            hintText: "",
                            focusNode: signupController.popularFocus,
                          ),
                          SizedBox(height: height * 0.02),
                          const CommonText(
                              content: 'Slots',
                              textColor: AppColors.appWhite,
                              boldNess: FontWeight.w600),
                          SizedBox(height: height * 0.01),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  signupController.deliverySlotsList.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: AppText(
                                      signupController
                                          .deliverySlotsList[index].slotName
                                          .toString(),
                                      color: AppColors.appWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  signupController.deliverySlotsList.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: AppText(
                                      ' : ${signupController.deliverySlotsList[index].startTime} - ${signupController.deliverySlotsList[index].endTime}',
                                      color: AppColors.appWhite,
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
                                  signupController.deliverySlotsList.length,
                                  (index) => InkWell(
                                    onTap: () {
                                      print(signupController
                                          .deliverySlotsList[index].isChecked);
                                      signupController.deliverySlotsList[index]
                                          .isChecked = signupController
                                                  .deliverySlotsList[index]
                                                  .isChecked ==
                                              'Y'
                                          ? 'N'
                                          : 'Y';
                                      signupController.update();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: signupController
                                                    .deliverySlotsList[index]
                                                    .isChecked ==
                                                "Y"
                                            ? AppColors.primaryColor
                                            : AppColors.appWhite,
                                        // border: Border.all(
                                        //     color: AppColors.appWhite,
                                        //     width: 1),
                                      ),
                                      child: const Icon(Icons.done,
                                          color: AppColors.appWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                confirmText: 'Confirm',
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      dialogBackgroundColor:
                                          AppColors.greenColor,
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
                              signupController.storeOpeningController.text =
                                  time!.format(Get.context!);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const CommonText(
                                      content: 'Store opening time*',
                                      textColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        focusNode:
                                            signupController.storeOpeningFocus,
                                        controller: signupController
                                            .storeOpeningController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            color: AppColors.appWhite),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
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
                              signupController.storeClosingController.text =
                                  time!.format(Get.context!);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const AppHeaderText(
                                      headerText: 'Store Closing Time*',
                                      headerColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        focusNode:
                                            signupController.storeClosingFocus,
                                        controller: signupController
                                            .storeClosingController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            color: AppColors.appWhite),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
                                lastDate: DateTime.now(),
                                initialDate: DateTime.now(),
                                helpText: 'Your Birth Date',
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
                                signupController.birthDateController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const AppHeaderText(
                                      headerText: 'Your Birth date :',
                                      headerColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller: signupController
                                            .birthDateController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.appWhite),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
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
                                signupController
                                        .weddingAniversaryController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const AppHeaderText(
                                      headerText: 'Wedding Aniversary Date :',
                                      headerColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: signupController
                                            .weddingAniversaryController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.appWhite),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
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
                                signupController.childOneController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const AppHeaderText(
                                      headerText: 'Child 1 Birth Date :',
                                      headerColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller:
                                            signupController.childOneController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.appWhite),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
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
                                signupController.childTwoController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 2,
                                  child: const AppHeaderText(
                                      headerText: 'Child 2 Birth Date :',
                                      headerColor: AppColors.appWhite),
                                ),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyBgColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        controller:
                                            signupController.childTwoController,
                                        readOnly: true,
                                        style: const TextStyle(
                                            color: AppColors.appWhite,
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
                          const SizedBox(height: 12),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.appWhite, width: 0.5)),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Delivery Strength',
                                    headerColor: AppColors.appWhite),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.greyBgColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: signupController
                                        .deliveryStrengthController,
                                    style: const TextStyle(
                                        color: AppColors.appWhite),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const AppHeaderText(
                              headerText: 'Message From Retailer To Customer',
                              headerColor: AppColors.appWhite),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyBgColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: signupController.messageController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              maxLines: 5,
                              style: const TextStyle(color: AppColors.appWhite),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          CommonPrimaryButton(
                            isLoading: signupController.isLoading.value,
                            text: "Register",
                            onTap: () {
                              signupController.registerTowUser();
                              // Get.to(() => MobileNoScreen());
                            },
                          ),
                          SizedBox(height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class MapScreen extends StatelessWidget {
  MapScreen({Key? key, this.status}) : super(key: key);
  String? status = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<MapController>(
      init: MapController(),
      initState: (state) {
        Future.delayed(
          const Duration(microseconds: 300),
          () {
            final mapController = Get.find<MapController>();
            mapController.bodyMap = Get.arguments ?? {};
            mapController.update();
            mapController.getCurrentLocation();
          },
        );
      },
      builder: (MapController mapController) {
        return Scaffold(
          appBar: AppBar(
            title: CommonText(
              content: 'My Store Location',
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
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                !mapController.isLoading
                    ? GoogleMap(
                        myLocationEnabled: true,
                        onTap: (argument) async {
                          print(mapController.bodyMap);
                          if (status != 'show') {
                            if (mapController.bodyMap.isEmpty) {
                              mapController.markers.first.position.latitude;

                              await mapController.manageMarker(LatLng(
                                  argument.latitude, argument.longitude));
                              LatLng(argument.latitude, argument.longitude);
                            }
                          }
                        },
                        initialCameraPosition: CameraPosition(
                          target: mapController.bodyMap.isEmpty
                              ? LatLng(mapController.position!.latitude,
                                  mapController.position!.longitude)
                              : LatLng(
                                  double.parse(
                                      mapController.bodyMap['latitude']),
                                  double.parse(
                                      mapController.bodyMap['longitude'])),
                          zoom: 12,
                        ),
                        zoomControlsEnabled: false,
                        markers: mapController.markers,
                      )
                    : const SizedBox(),
                mapController.isLoading
                    ? const SizedBox()
                    : Container(
                        height: height / 7,
                        width: width,
                        decoration: const BoxDecoration(color: Colors.white),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppImageAsset(
                                image: "assets/icons/map_marker.svg",
                                height: 20,
                                width: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: mapController.address?.name ?? '',
                                    boldNess: FontWeight.bold,
                                    textSize: 18,
                                    textColor: AppColors.textColor,
                                  ),
                                  CommonText(
                                    content:
                                        '${mapController.address?.street ?? ''}, ${mapController.address?.locality ?? ''}, ${mapController.address?.subLocality ?? ''}, ${mapController.address?.postalCode ?? ''}, ${mapController.address?.country ?? ''}',
                                    boldNess: FontWeight.w400,
                                    textSize: 14,
                                    textColor: AppColors.textColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                if (mapController.isLoading)
                  Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor)),
              ],
            ),
          ),
          bottomNavigationBar: (status != 'show')
              ? SafeArea(
                  child: InkWell(
                    onTap: () {
                      if (mapController.bodyMap.isNotEmpty) {
                        Get.back();
                        return;
                      }
                      if (status == "register") {
                        final onboardController = Get.find<SignupController>();
                        onboardController.storeLocationController.text =
                            '${mapController.address!.street ?? ''}, ${mapController.address!.locality ?? ''}, ${mapController.address!.subLocality ?? ''}, ${mapController.address!.postalCode ?? ''}, ${mapController.address!.country ?? ''}';
                        onboardController.latitude = mapController
                            .markers.first.position.latitude
                            .toString();
                        onboardController.longitude = mapController
                            .markers.first.position.longitude
                            .toString();
                        print(onboardController.latitude);
                        print(onboardController.longitude);
                        Get.back();
                      } else if (status == "edit") {
                        final editProfileController =
                            Get.find<EditProfileController>();
                        editProfileController.addressController.text =
                            '${mapController.address!.street ?? ''}, ${mapController.address!.locality ?? ''}, ${mapController.address!.subLocality ?? ''}, ${mapController.address!.postalCode ?? ''}, ${mapController.address!.country ?? ''}';
                        editProfileController.latitude = mapController
                            .markers.first.position.latitude
                            .toString();
                        editProfileController.longitude = mapController
                            .markers.first.position.longitude
                            .toString();
                        editProfileController.pincodeController.text =
                            mapController.address!.postalCode ?? '';
                        editProfileController.stateController.text =
                            mapController.address!.administrativeArea ?? '';
                        print(editProfileController.latitude);
                        print(editProfileController.longitude);
                        editProfileController.update();
                        print(editProfileController.addressController.text);
                        Get.back();
                      }
                    },
                    child: Container(
                      height: mapController.isLoading ? 0 : 48,
                      margin: const EdgeInsets.only(
                          right: 22, left: 22, bottom: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.yellowColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: CommonText(
                        content: mapController.bodyMap.isNotEmpty
                            ? 'Back to store'
                            : 'Confirm location',
                        textSize: 18,
                        boldNess: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}

class AppText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const AppText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Colors.white,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 14,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class AppHeaderText extends StatelessWidget {
  final String headerText;
  final Color headerColor;

  const AppHeaderText(
      {Key? key, required this.headerText, required this.headerColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: AppText(
        headerText,
        color: headerColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DateTimeUtils {
  static String getFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(dateTime);
  }
}
