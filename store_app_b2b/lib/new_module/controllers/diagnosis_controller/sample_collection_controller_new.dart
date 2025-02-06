import 'dart:io';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/helper/firebase_token_storeb2b_helper_new.dart';
import 'package:store_app_b2b/new_module/constant/app_api_type_constants_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/lucid/find_location_model_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_my_booking_screen_new.dart';
import 'package:store_app_b2b/new_module/services/new_apiresponse_new.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service_new.dart';
import 'package:store_app_b2b/new_module/services/payloads_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/store_screen_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;

class SampleCollectionController extends GetxController
    implements APiResponseFlow {
  final GlobalMainController globalController = Get.put(GlobalMainController());
  CartLabtestController cartController = Get.put(CartLabtestController());
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressInfoController = TextEditingController();
  TextEditingController appointmentController = TextEditingController();
  String displayedAppointmentDate = '';
  TextEditingController ageController = TextEditingController();

  String? selectedTitle;
  String? latitude;
  String? longitude;
  String? selectedCity;
  String? selectedGender;
  String? selectedLocation;
  String? selectedRelation;

  String? selectedDescription = "";

  late Razorpay razorpay;

  @override
  Future<void> onInit() async {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  final ThemeController themeController = Get.find();
  clearForm() {
    appointmentController.clear();
    firstNameController.clear();
    lastNameController.clear();
    mobileNumberController.clear();
    descriptionController.clear();
    addressController.clear();
    addressInfoController.clear();
    ageController.clear();
    selectedCity = null;
    selectedGender = null;
    selectedLocation = null;
    selectedRelation = null;
    displayedAppointmentDate = "";
  }

  void showSuccessDialog() {
    appointmentController.clear();
    firstNameController.clear();
    lastNameController.clear();
    mobileNumberController.clear();
    descriptionController.clear();
    addressController.clear();
    addressInfoController.clear();
    ageController.clear();
    selectedCity = null;
    selectedGender = null;
    selectedLocation = null;
    selectedRelation = null;
    displayedAppointmentDate = "";
    Get.dialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.99),
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            width: 90.w,
            decoration: BoxDecoration(
                color: themeController.textPrimaryColor,
                borderRadius: BorderRadius.circular(48)),
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child:
                      Image.asset('assets/images/appointment_confirmation.png'),
                ),
                const Gap(30),
                AppText(
                  'Confirmed!',
                  color: themeController.black500Color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                const Gap(5),
                AppText(
                  'Your test is confirmed .',
                  color: themeController.black100Color,
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w200,
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () async {
                    CartLabtestController cltController =
                        Get.find<CartLabtestController>();
                    cltController.getDiagnosticCartData(homeCollection: "0");
                    cltController.getDiagnosticCartData(homeCollection: "1");

                    Get.offAll(() => const home.HomeScreen());
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeController.navShadow1,
                    ),
                    child: AppText(
                      'Done',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: themeController.textPrimaryColor,
                    ),
                  ),
                ),
                Gap(4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    if (firstNameController.text.isEmpty &&
        lastNameController.text.isEmpty &&
        ageController.text.isEmpty &&
        selectedCity == null &&
        selectedGender == null &&
        selectedLocation == null &&
        appointmentController.text.isEmpty &&
        //  addressController.text.isEmpty &&
        selectedRelation == null &&
        mobileNumberController.text.isEmpty) {
      customFailureToast(content: 'Please enter details');
      return false;
    } else if (firstNameController.text.isEmpty) {
      customFailureToast(content: "First Name is required");
      return false;
    } else if (fieldLengthCheck(
        value: firstNameController.text, fieldName: "First Name")) {
      return false;
    } else if (lastNameController.text.isEmpty) {
      customFailureToast(content: "Last Name is required");
      return false;
    } else if (fieldLengthCheck(
        value: lastNameController.text, fieldName: "Last Name")) {
      return false;
    } else if (ageController.text.isEmpty) {
      customFailureToast(content: "Age is required");
      return false;
    } else if (!isNumeric(ageController.text)) {
      customFailureToast(content: "Age must be a numeric value");
      return false;
    } else if (selectedGender == null) {
      customFailureToast(content: "Gender is required");
      return false;
    } else if (mobileNumberController.text.isEmpty) {
      customFailureToast(content: "Mobile Number is required");
      return false;
    } else if (!isNumeric(mobileNumberController.text)) {
      customFailureToast(content: "Mobile Number must be a numeric value");
      return false;
    } else if (mobileNumberController.text.length != 10) {
      customFailureToast(content: "please enter valid mobile number");
      return false;
    } else if (selectedCity == null) {
      customFailureToast(content: "City is required");
      return false;
    } else if (selectedLocation == null) {
      customFailureToast(content: "Location is required");
      return false;
    } else if (selectedRelation == null) {
      customFailureToast(content: "Relation is required");
      return false;
    } else if (appointmentController.text.isEmpty) {
      customFailureToast(content: "Booking Time is required");
      return false;
    }

    return true;
  }

  bool isNumeric(String str) {
    if (str.isEmpty) {
      return false;
    }
    final number = num.tryParse(str);
    return number != null;
  }

  RxBool isPatientDataLoading = false.obs;

  RxString isHc = "".obs;
  Future<void> postPatientData() async {
    isPatientDataLoading.value = true;
    try {
      String branchId = "";
      for (var item in locationList) {
        if (item.branchName == selectedLocation) {
          branchId = item.id ?? '';
          break;
        }
      }
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(now);
      String userId = await getUserId();
      Map<String, dynamic> map = Payloads().postPatientDetails(
        cartId: cartController.diagnosticCartData.value!.data!.id ?? "",
        branchId: branchId,
        userId: userId,
        relation: selectedRelation!,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        age: int.parse(ageController.text),
        mobileNumber: mobileNumberController.text,
        city: selectedCity!,
        gender: selectedGender!,
        location: selectedLocation!,
        comments: descriptionController.text,
        address: addressController.text,
        appointmentDate: appointmentController.text,
        isUrgent: selectedRelation!,
        bookingDate: formattedDate,
        isHomeCollection: isHc.value,
        latitude: latitude,
        longitude: longitude,
        fullAddress: addressInfoController.text,
      );
      logs("Response Bodey-->${map["body"]}");

      await RestServices.instance.postRestCall(
        body: map["body"],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.saveLucidPatient,
      );
      logs("Response Bodey-->${map["body"]}");
    } on SocketException catch (e) {
      isPatientDataLoading.value = false;
      logs('Catch exception in addCart --> ${e.message}');
    }
  }

  RxList<BasicLocationModel> locationList = <BasicLocationModel>[].obs;
  RxList<String> locationsTextList = <String>[].obs;
  RxBool isLocationListLoading = false.obs;

  Future<void> getAllBranches({
    String endpoint = "",
  }) async {
    try {
      isLocationListLoading.value = true;

      await RestServices.instance.getRestCall<FindLocationModel>(
        fromJson: (json) {
          return findLocationModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty ? endpoint : Payloads().getAllBranches(),
        flow: this,
        apiType: ApiTypes.getAllBranches,
      );
    } catch (e) {
      isLocationListLoading.value = false;
    }
    update();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logs('Success Response orderId:- ${response.orderId}');
    logs('Success Response paymentId:- ${response.paymentId}');
    logs('Success Response signature:- ${response.signature}');
    logs('Success Response subject:- ${response.obs.subject.stream}');

    logs("====razor pay response $response");

    cartController.postDiagnosticPayment(
      response: response,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    logs('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    logs('External SDK Response: $response');
  }

  Future<dynamic> getRazorPayDataApi(num amount, String? orderId, Key) async {
    return openCheckout(amount, orderId, Key);
  }

  void openCheckout(num price, String? orderId, Key) async {
    var options = {
      'key': Key,
      'amount': (price * 100),
      "id": orderId,
      'name': 'Acintyo Retailer Buy',
      'description': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'external': {
        'wallets': ['paytm']
      },
      "notes": {
        "order_id": orderId,
      }
    };

    logs("printing opencheckout pay now options ---> $options");

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void onFailure(String message, String apiType, Map<String, dynamic> info) {
    customFailureToast(content: message);

    if (apiType == ApiTypes.getAllBranches) {
      customFailureToast(content: message);
      isLocationListLoading.value = false;
    }
    if (apiType == ApiTypes.saveLucidPatient) {
      customFailureToast(content: message);
      isPatientDataLoading.value = false;
    }
  }

  @override
  void onSuccess<T>(T? data, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.saveLucidPatient) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        Get.offAll(() => const home.HomeScreen());
      } else {
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while adding to cart');
      }
      isPatientDataLoading.value = false;
    }

    if (apiType == ApiTypes.getAllBranches) {
      FindLocationModel modelData = data as FindLocationModel;
      logs("userid ->${modelData.data!}");
      logs("length of data${modelData.data!.length}");
      if (modelData.data != null && modelData.data!.isNotEmpty) {
        locationList.value = modelData.data!;
        locationList.value = modelData.data!;
        locationsTextList.clear();

        for (BasicLocationModel i in locationList) {
          locationsTextList.add(i.branchName ?? '');
        }
        if (selectedLocation != null &&
            !locationsTextList.contains(selectedLocation)) {
          selectedLocation = null;
          update();
        }
      }
      isLocationListLoading.value = false;
    }
  }

  @override
  void onTokenExpired(
      String apiType, String endPoint, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllBranches) {
      getAllBranches(endpoint: endPoint);
    }
  }
}
