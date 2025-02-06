import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/model/business_category_model_new.dart';
import 'package:store_app_b2b/model/delivery_slots_model_new.dart';
import 'package:store_app_b2b/screens/auth/mobile_no_screen_new.dart';
import 'package:store_app_b2b/screens/auth/otp_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/service/location_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/utils/validation_utils_new.dart';
// import 'package:store_app_b2b/utils/string_extensions_new.dart';
// import 'package:store_app_b2b/utils/validation_utils.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignupController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  int selectedOnboardIndex = 0;

  var showPincodeAndState = false.obs;

  //RxInt selectedBusinessType = 0.obs;
  String businessType = "";
  String selectBusiness = "";
  String selectFirmStatus = "";
  String selectBusinessId = "";
  RxString selectBusinessStatus = "".obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();

  TextEditingController areaController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController storeLicenseController = TextEditingController();
  TextEditingController drugLicenseController = TextEditingController();
  TextEditingController durgLicenseExpiryController = TextEditingController();
  TextEditingController pharmaNameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();
  TextEditingController storeLocationInfoController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController dealsInController = TextEditingController();
  TextEditingController popularController = TextEditingController();
  TextEditingController storeOpeningController = TextEditingController();
  TextEditingController storeClosingController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weddingAniversaryController = TextEditingController();
  TextEditingController childOneController = TextEditingController();
  TextEditingController childTwoController = TextEditingController();
  TextEditingController deliveryStrengthController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String otp = "";

  List<DeliverySlotsModel> deliverySlotsList = [];
  List businessCategoryList = [];
  List firmStatusList = ["Proprietor", "Partnership", "Pvt Ltd", "Others"];

  FocusNode userNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode storeNameFocus = FocusNode();
  FocusNode storeNumberFocus = FocusNode();
  FocusNode ownerNameFocus = FocusNode();
  FocusNode areaFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode gstFocus = FocusNode();
  FocusNode storeLicenseFocus = FocusNode();
  FocusNode drugLicenseFocus = FocusNode();
  FocusNode drugLicenseExpiryFocus = FocusNode();
  FocusNode registeredNameFocus = FocusNode();
  FocusNode documentFocus = FocusNode();
  FocusNode landmarkFocus = FocusNode();
  FocusNode storeLocationFocus = FocusNode();
  FocusNode dealsInFocus = FocusNode();
  FocusNode popularFocus = FocusNode();
  FocusNode storeAddressFocus = FocusNode();
  FocusNode pincodeFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode storeOpeningFocus = FocusNode();
  FocusNode storeClosingFocus = FocusNode();

  String? gstNumber;
  String? storeLicense;
  String? storeDrugLicense;

  String? storeBackImage;
  String? storeFrontImage;

  String? latitude;
  String? longitude;

  /// end point : api-auth/store/m/register
  /// base url : https://dev.acintyotechapi.com/

  getCategory() async {
    try {
      print("category url ---> ${API.getCategory}");
      final response = await http.get(Uri.parse(API.getCategory),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);
      print("response>>>>>>>$response");
      print("responseBody>>>$responseBody");

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        businessCategoryList = responseBody;
      } else {
        CommonSnackBar.showError(responseBody['error'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    update();
  }

  // String? validateDrugLicense(String value) {
  //   final licenseRegex = RegExp(r'^[A-Za-z0-9/,\-]{10,30}$');
  //   if (value.isEmpty) {
  //     return 'Drug license number is required';
  //   } else if (!licenseRegex.hasMatch(value)) {
  //     return 'Invalid drug license number format';
  //   } else if (value.length < 10) {
  //     return 'License number must be at least 10 characters';
  //   } else if (value.length > 30) {
  //     return 'License number cannot exceed 30 characters';
  //   }
  //   return null; // Input is valid
  // }

  registerUser() async {
    // Get.to(() => SignUp2Screen());
    // return;

    if (storeBackImage == null) {
      'Please select store image'.showError();
      return;
    }
    if (storeFrontImage == null) {
      'Please select store profile image'.showError();
      return;
    }
    if (selectBusiness == "") {
      'Please select business type'.showError();
      return;
    }
    if (selectFirmStatus == "") {
      'Please select firm type'.showError();
      return;
    }

    if (ValidationUtils.instance.validateEmptyController(storeNameController)) {
      'Store name can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNameFocus);
      });
      return;
    }

    if (storeNameController.length < 5) {
      'Store name must contain at least 5 characters'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNameFocus);
      });
      return;
    }

    if (storeNameController.length > 100) {
      'Store name cannot exceed 100 characters'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNameFocus);
      });
      return;
    }

    if (ValidationUtils.instance
        .validateEmptyController(storeNumberController)) {
      'Store number can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNumberFocus);
      });
      return;
    }
    if (ValidationUtils.instance.lengthValidator(storeNumberController, 10)) {
      'Store number must be 10 digits'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNumberFocus);
      });
    }
    if (ValidationUtils.instance.validateEmptyController(ownerNameController)) {
      'Owner name can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(ownerNameFocus);
      });
      return;
    }
    // if (ValidationUtils.instance.validateEmptyController(userNameController)) {
    //   'Username can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(userNameFocusNode);
    //   });
    //   return;
    // }
    // if (ValidationUtils.instance.lengthValidator(phoneController, 10)) {
    //   'Phone number can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(phoneFocusNode);
    //   });
    //   return;
    // }
    if (ValidationUtils.instance.validateEmptyController(emailController)) {
      'Email can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(emailFocus);
      });
      return;
    }
    if (!ValidationUtils.instance
        .regexValidator(emailController, ValidationUtils.emailRegExp)) {
      'Enter valid email '.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(emailFocus);
      });
      return;
    }
    // if (ValidationUtils.instance.validateEmptyController(passwordController)) {
    //   'Enter password'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(passwordFocus);
    //   });
    //   return;
    // }
    // if (ValidationUtils.instance
    //     .validateEmptyController(confirmPasswordController)) {
    //   'Confirm Password can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(confirmPasswordFocus);
    //   });
    //   return;
    // }
    // if (passwordController.text.toString() !=
    //     confirmPasswordController.text.toString()) {
    //   'Password Or Confirm Password Not Match'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(passwordFocus);
    //   });
    //   return;
    // }
    // if (ValidationUtils.instance.validateEmptyController(areaController)) {
    //   'Area can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(areaFocus);
    //   });
    //   return;
    // }
    // if (ValidationUtils.instance.validateEmptyController(addressController)) {
    //   'address can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(addressFocus);
    //   });
    //   return;
    // }
    if (ValidationUtils.instance.validateEmptyController(gstController)) {
      'GST Number can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(gstFocus);
      });
      return;
    }

    bool isValidDrugLicense(String input) {
      // Define the pattern to match alphanumeric characters, slashes, and hyphens
      final pattern = RegExp(r'^[a-zA-Z0-9/-]*$');

      // Check if the input matches the pattern
      return pattern.hasMatch(input);
    }

    bool isValidGst(String input) {
      // Define the pattern to match the custom alphanumeric structure
      final pattern =
          RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

      // Check if the input matches the pattern
      return pattern.hasMatch(input);
    }

    // if (ValidationUtils.instance
    //     .validateEmptyController(storeLicenseController)) {
    //   'Store License can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
    //   });
    //   return;
    // }

    if (!isValidGst(gstController.text) && gstController.text.isNotEmpty) {
      'Gst number format is not valid (Eg. 22AAAAA0000A1Z5)'.showError();
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
      // });
      return;
    }

    if (
        // gstController.text.isNotEmpty &&
        (gstNumber == null || gstNumber!.isEmpty)) {
      'Please provide gst image'.showError();
      return;
    }

    if (storeLicenseController.text.isNotEmpty) {
      if (storeLicenseController.length < 10) {
        'Store license number must be at least 10 characters'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
        });
        return;
      }

      if (storeLicense == null || storeLicense!.isEmpty) {
        'Please provide store license image'.showError();

        return;
      }
    }

    if (selectBusinessStatus.value == "Y") {
      if (ValidationUtils.instance
          .validateEmptyController(drugLicenseController)) {
        'Drug licence can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        });
        return;
      }

      if (drugLicenseController.length < 10) {
        'Drug license number must be at least 10 characters'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
        });
        return;
      }

      print('is valid ${isValidDrugLicense(drugLicenseController.text)}');

      if (!isValidGst(gstController.text) && gstController.text.isNotEmpty) {
        'Gst number format is not valid (Eg. 22AAAAA0000A1Z5)'.showError();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        // });
        return;
      }
      if (storeDrugLicense == null) {
        'Please select store drug licence image'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        });
        return;
      }

      if (ValidationUtils.instance
          .validateEmptyController(durgLicenseExpiryController)) {
        'Drug license expiry can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseExpiryFocus);
        });
        return;
      }

      if (ValidationUtils.instance
          .validateEmptyController(pharmaNameController)) {
        'Registered Pharmacist Name can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(registeredNameFocus);
        });
        return;
      }
    }

    // if (storeDrugLicense == null) {
    //   'Please select store drug licence image'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
    //   });
    //   return;
    // }
    // if (ValidationUtils.instance
    //     .validateEmptyController(pharmaNameController)) {
    //   'Registered Pharmacist Name can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(registeredNameFocus);
    //   });
    //   return;
    // }
    // else {
    //   // Get.to(() => MobileNoScreen(), arguments: phoneController.text);
    //   Get.to(() => SignUp2Screen());
    // }

    bool isStoreNumberVerified = await verifyStoreNumber();

    if (isStoreNumberVerified) {
      return;
    }

    // bool isPhoneNumberVerified = await verifyPhoneOtp();

    // print('log log is verified -> $isPhoneNumberVerified');
    // if (isPhoneNumberVerified) {
    //   return;
    // }

    bool isEmaiNumberExists = await verifyEmailOtp();

    if (isEmaiNumberExists) {
      return;
    }
    // print('log log go to screen2 -> $isPhoneNumberVerified');

    Get.to(() => SignUp2Screen());
  }

  Future<bool> verifyPhoneOtp() async {
    try {
      String url = "${API.verifyPhone}${phoneController.text}";

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      print("verifyPhoneOtp url --> $url");
      print("verifyPhoneOtp response --> ${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        print('log log 1');
        if (responseMap['status']) {
          print('log log 2');
          'Mobile Number already exist'.showError();
          return true;
        }
        print('log log 3');
        return responseMap['status'];
      } else {
        CommonSnackBar.showError('Something went wrong'.toString());
        return true;
      }
    } on SocketException catch (e) {
      logs('Catch Socket Exception in onboardStore --> ${e.message}');
      return false;
    } on TimeoutException catch (e) {
      logs('Catch Timeout Exception in onboardStore --> ${e.message}');
      return false;
    }
  }

  Future<bool> verifyEmailOtp() async {
    try {
      String url = "${API.verifyEmail}${emailController.text}";

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      print("verifyEmailOtp url --> $url");
      print("verifyEmailOtp response --> ${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap['response']) {
          'Email already exist'.showError();
        }
        return responseMap['response'];
      } else {
        CommonSnackBar.showError('Something went wrong'.toString());
        return true;
      }
    } on SocketException catch (e) {
      logs('Catch Socket Exception in onboardStore --> ${e.message}');
      CommonSnackBar.showError('Something went wrong'.toString());
      return true;
    } on TimeoutException catch (e) {
      logs('Catch Timeout Exception in onboardStore --> ${e.message}');
      CommonSnackBar.showError('Something went wrong'.toString());
      return true;
    }
  }

  Future<bool> verifyStoreNumber() async {
    try {
      log('storenumber ---> ${storeNumberController.text}');
      final response = await http.post(
        Uri.parse(API.logInWithPhone +
            "?phoneNumber=${storeNumberController.value.text.trim()}&role=Retailer"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        if (responseBody['response'] == true) {
          CommonSnackBar.showError('Store number already exists');
          return true;
        } else {
          // Get.to(() => SignUp2Screen());
          return false;
        }
        // CommonSnackBar.showSuccess(responseBody['message'].toString());
      } else {
        CommonSnackBar.showError('Something went wrong'.toString());
        return true;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }

  registerTowUser() async {
    if (ValidationUtils.instance.validateEmptyController(documentController)) {
      'Document address can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(documentFocus);
      });
      return;
    }

    if (ValidationUtils.instance.validateEmptyController(landmarkController)) {
      'Landmark can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(landmarkFocus);
      });
      return;
    }

    if (landmarkController.text.length < 3) {
      'Landmark must be atleast 3 characters'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(landmarkFocus);
      });
      return;
    }

    if (ValidationUtils.instance
        .validateEmptyController(storeLocationController)) {
      'Store Location can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeAddressFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(pincodeController)) {
      'Pincode can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(pincodeFocus);
      });
      return;
    }
    if (pincodeController.text.length != 6) {
      'Pincode must be 6 characters'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(pincodeFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(stateController)) {
      'State can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(stateFocus);
      });
      return;
    }

    int count = 0;
    for (int i = 0; i < deliverySlotsList.length; i++) {
      if (deliverySlotsList[i].isChecked == true) {
        count++;
      }
    }
    if (count == 0) {
      'Please select the slots'.showError();
      return;
    }

    if (ValidationUtils.instance
        .validateEmptyController(storeOpeningController)) {
      'Store opening time can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeOpeningFocus);
      });
      return;
    }
    if (ValidationUtils.instance
        .validateEmptyController(storeClosingController)) {
      'Store closing time can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeClosingFocus);
      });
      return;
    }

    if (weddingAniversaryController.text.isNotEmpty &&
        birthDateController.text.isNotEmpty) {
      DateTime birthDate = DateTime.parse(birthDateController.text);
      DateTime weddingDate = DateTime.parse(weddingAniversaryController.text);

      if (!weddingDate.isAfter(birthDate)) {
        'Wedding anniversary date must be after the birth date.'.showError();
        return;
      }
    }

    if (childOneController.text.isNotEmpty &&
        birthDateController.text.isNotEmpty) {
      DateTime birthDate = DateTime.parse(birthDateController.text);
      DateTime weddingDate = DateTime.parse(childOneController.text);

      if (!weddingDate.isAfter(birthDate)) {
        'Child 1 birth date must be after the birth date.'.showError();
        return;
      }
    }

    if (childTwoController.text.isNotEmpty &&
        birthDateController.text.isNotEmpty) {
      DateTime birthDate = DateTime.parse(birthDateController.text);
      DateTime weddingDate = DateTime.parse(childTwoController.text);

      if (!weddingDate.isAfter(birthDate)) {
        'Child 2 birth date must be after the birth date.'.showError();
        return;
      }
    }

    // 'Success'.showError();
    // return;
    Get.to(() => OTPScreen(
        type: "register", mobile: storeNumberController.text.toString()));
  }

  Future<dynamic> registerPost() async {
    final String loginId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    // if (loginId.isEmpty) {
    try {
      List<Map<String, dynamic>> slotsListMap = [];
      for (DeliverySlotsModel element in deliverySlotsList) {
        slotsListMap.add(element.toJson());
      }

      String dateString = durgLicenseExpiryController.text;
      String finalDrugExpiryDate = "";

      // Parse the string into a DateTime object
      if (dateString.isNotEmpty) {
        print("printing dateString -> ${dateString}");
        DateTime date = DateFormat("dd/MM/yyyy").parse(dateString);
        String formattedDate = DateFormat("yyyy-MM-dd").format(date);
        finalDrugExpiryDate = formattedDate;
        print("printing finalDrug -> ${finalDrugExpiryDate}");
      }

      // Format the DateTime object into the desired format

      Map<String, dynamic> bodyMap = {
        "otp": otp,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'password': passwordController.text,
        'storeName': storeNameController.text.toUpperCase(),
        'businessType': 'Retailer',
        'storeCategory': selectBusiness,
        'storeCategoryId': selectBusinessId,
        'firmType': selectFirmStatus,
        'ownerName': ownerNameController.text.toUpperCase(),
        'storeNumber': storeNumberController.text,
        'openTime': storeOpeningController.text,
        'closeTime': storeClosingController.text,
        "dealsIn": dealsInController.text.toUpperCase(),
        "popularIn": popularController.text.toUpperCase(),
        'deliveryStrength': deliveryStrengthController.text,
        'retailerBirthday': birthDateController.text,
        'retailerMarriageDay': weddingAniversaryController.text,
        'retailerChildOneBirthDay': childOneController.text,
        'retailerChildTwoBirthDay': childTwoController.text,
        'retailerMessage': messageController.text.toUpperCase(),
        'gst': {
          'gstNumber': gstController.text.isEmpty
              ? "No GST"
              : gstController.text.toUpperCase(),
          'docUrl': gstNumber == null ? '' : gstNumber.toString()
        },
        'storeLicense': {
          'storeLicense': storeLicenseController.text.isEmpty
              ? "No Store Licence"
              : storeLicenseController.text.toUpperCase(),
          'docUrl': storeLicense == null ? '' : storeLicense.toString()
        },
        'drugLicense': {
          'drugLicenseNumber': drugLicenseController.text.toUpperCase(),
          'documentId':
              storeDrugLicense == null ? '' : storeDrugLicense.toString(),
          'expiryDate': finalDrugExpiryDate,
        },
        'slots': slotsListMap,
        'storeAddressDetailRequest': [
          {
            'addressType': 'shop',
            'addressLine1': storeLocationController.text,
            'landMark': landmarkController.text.toUpperCase(),
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
          }
        ],
        'imageUrl': {
          'bannerImageId': storeBackImage,
          'profileImageId': storeFrontImage
        },
        'drugLicenseAddress': documentController.text.toUpperCase(),
        'registeredPharmacistName': pharmaNameController.text.toUpperCase(),
        'boarded': loginId,
        "state": stateController.text.toUpperCase(),
        'pinCode': pincodeController.text
      };
      log('register log -> ${jsonEncode(bodyMap)}');
      print("bodyMap>>>>>>>>>>>>>>>>>>$bodyMap");
      final response = await http.post(
        Uri.parse(API.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(
          "log current check register post url -> ${API.register} ++++++++response+++++++++$responseBody");

      if (response.statusCode == 200 && responseBody['status'] == true) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        print(responseBody);
        return responseBody;

        // Get.to(() => MobileNoScreen(), arguments: phoneController.text);

        print("sucsecc");

        return responseBody;
      } else {
        CommonSnackBar.showError(responseBody['message'].toString());
        // responseBody['message'].to String().showError();
      }
    } on TimeoutException catch (e) {
      print("1");
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on SocketException catch (e) {
      print("2");
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on Error catch (e) {
      print("3");
      debugPrint(e.toString());
      rethrow;
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
  }

  getDeliverySlots() async {
    try {
      final response = await http.get(Uri.parse(API.deliverySlots),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);
      print("response>>>>>>>$response");
      print("responseBody>>>$responseBody");

      if (response.statusCode == 200) {
        deliverySlotsList = deliverySlotsModelFromJson(response.body);
        for (DeliverySlotsModel i in deliverySlotsList) {
          i.isChecked = true;
          update();
        }
      } else {
        CommonSnackBar.showError(responseBody['error'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> selectBannerImage(
      ImageSource imageSource, bool isBack, String? type) async {
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);
    if (image != null) {
      print(
          'SIZE OF gallery IMAGE :${(await image.readAsBytes()).lengthInBytes / 1024 / 1024}');
      if ((await image.readAsBytes()).lengthInBytes / 1024 / 1024 < 2) {
        Get.back();
        if (type != null) {
          if (type == 'gst') {
            gstNumber = await uploadProfilePhoto(image.path);
            print(gstNumber);
          } else if (type == 'store') {
            storeLicense = await uploadProfilePhoto(image.path);
          } else if (type == 'drug') {
            storeDrugLicense = await uploadProfilePhoto(image.path);
          }
        } else {
          if (isBack) {
            storeBackImage = await uploadProfilePhoto(image.path);
            print(storeBackImage);
          } else {
            storeFrontImage = await uploadProfilePhoto(image.path);
          }
        }
      } else {
        CommonSnackBar.showError('Please upload less than 1 MB.!');
      }
    }
    refresh();
    update();
  }

  Future<void> selectFileImage({
    List<String>? types,
    FileType fileTYpe = FileType.custom,
    bool isCropNeed = false,
    String? type,
  }) async {
    //implementing pdf
    FilePickerResult? result;

    if (Platform.isAndroid) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: types ?? const ['jpg', 'jpeg', 'png', 'pdf'],
      );
    } else {
      print('printing types -> $types');
      if (types == null) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          // allowedExtensions: types ?? const ['jpg', 'jpeg', 'png', 'pdf'],
        );
      } else {
        if (types.contains('pdf') && types.length == 1) {
          result = await FilePicker.platform
              .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        } else {
          result = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );
        }
      }
    }

    if (result == null) {
      // User canceled the picker
      return null;
    }

    File file = File(result.files.single.path!);

    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    logs('SIZE OF gallery IMAGE :${fileSizeInMB}}');

    if (fileSizeInMB > 3) {
      logs('File size is greater than 3 MB');
      ("File size must be less than 3 MB").showError();
      return null;
    }

    //implementing pdf ends here

    if (file != null) {
      print(
          'SIZE OF gallery IMAGE :${(await file.readAsBytes()).lengthInBytes / 1024 / 1024}');
      if ((await file.readAsBytes()).lengthInBytes / 1024 / 1024 < 2) {
        Get.back();
        if (type != null) {
          if (type == 'gst') {
            gstNumber = await uploadProfilePhoto(file.path);
            print(gstNumber);
          } else if (type == 'store') {
            storeLicense = await uploadProfilePhoto(file.path);
          } else if (type == 'drug') {
            storeDrugLicense = await uploadProfilePhoto(file.path);
          }
        } else {
          // if (isBack) {
          //   storeBackImage = await uploadProfilePhoto(image.path);
          //   print(storeBackImage);
          // } else {
          //   storeFrontImage = await uploadProfilePhoto(image.path);
          // }
        }
      } else {
        CommonSnackBar.showError('Please upload less than 1 MB.!');
      }
    }
    refresh();
    update();
  }

  Future<dynamic> uploadProfilePhoto(filepath) async {
    try {
      // Uri? requestedUri = Uri.tryParse(API.uploadImageURL);
      // print("res>>>>>>>>${API.uploadImageURL}");
      Uri? requestedUri =
          Uri.tryParse("http://devapi.thelocal.co.in/b2b/api-auth/image");
      print("res>>>>>>>>${"http://devapi.thelocal.co.in/b2b/api-auth/image"}");

      var request = http.MultipartRequest('POST', requestedUri!);
      request.files.add(await http.MultipartFile.fromPath('image', filepath!,
          contentType: MediaType.parse('image/jpeg')));
      Map<String, String> headers = {'Content-Type': 'application/json'};

      headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(headers);

      StreamedResponse res = await request.send();
      print("res>>>>>>>>$res");

      final responseData = await http.Response.fromStream(res);
      print("profilePhotoResponse>>>>>>>>${responseData.body}");
      Map<String, dynamic> responseMap = jsonDecode(responseData.body);
      print("profilePhotoResponse>>>>>>>>$responseMap");

      if (responseMap != null &&
          responseMap.containsKey('imgId') &&
          responseMap['imgId'] != "" &&
          responseMap["imgId"] != null) {
        return responseMap['imgId'].toString();
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    }
  }
}

class MapController extends GetxController {
  bool isLoading = true;
  Map<String, dynamic> bodyMap = {};
  Position? position;
  final Set<Marker> markers = {};
  Placemark? address;
  var initialCameraPosition =
      const CameraPosition(target: LatLng(0.0, 0.0), zoom: 35.0).obs;
  var mapController = Rx<GoogleMapController?>(null);
  final TextEditingController addressSearchController = TextEditingController();
  Future<void> fetchCoordinates(String address) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyA9hGUqzqQpDf2bTFZEaVTb24JPW3xhz6w';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        LatLng latLng = LatLng(location['lat'], location['lng']);
        manageMarker(latLng);
      }
    }
  }

  Future<void> getCurrentLocation({String? latitude, String? longitude}) async {
    isLoading = true;
    refresh();
    bool isAllowed = await LocationService.instance.checkLocationPermission();
    if (isAllowed) {
      print('else in get is not called');
      if (bodyMap.isEmpty) {
        position = await LocationService.instance.getCurrentLocation();
        logs("position$position");
        if (latitude != null &&
            longitude != null &&
            latitude.isNotEmpty &&
            longitude.isNotEmpty) {
          manageMarker(LatLng(double.parse(latitude), double.parse(longitude)));
        } else {
          manageMarker(LatLng(position!.latitude, position!.longitude));
        }
      } else {
        logs(
            "lalitude:${LatLng(double.parse(bodyMap['latitude']), double.parse(bodyMap['longitude']))}");

        if (latitude != null &&
            longitude != null &&
            latitude.isNotEmpty &&
            longitude.isNotEmpty) {
          manageMarker(LatLng(double.parse(latitude), double.parse(longitude)));
        } else {
          manageMarker(LatLng(double.parse(bodyMap['latitude']),
              double.parse(bodyMap['longitude'])));
        }
      }
    } else {
      print('else in get is called');
      getCurrentLocation();
    }
    isLoading = false;
    refresh();
  }

  var addressLineArray = <String>[].obs;

  Future<void> manageMarker(LatLng argument) async {
    print(
        'check latlng going in manage marker lat -> ${argument.latitude} lng - ${argument.longitude}');
    markers.clear();
    markers.add(
      Marker(
          markerId: const MarkerId('locationId'),
          icon: BitmapDescriptor.defaultMarker,
          position: argument),
    );
    refresh();
    List<Placemark> addresses =
        await placemarkFromCoordinates(argument.latitude, argument.longitude);
    address = addresses.first;

    if (address!.name != null && address!.name!.isNotEmpty) {
      addressLineArray.add(address!.name!);
    }

    if (address!.thoroughfare != null && address!.thoroughfare!.isNotEmpty) {
      addressLineArray.add(address!.thoroughfare!);
    }

    if (address!.subLocality != null && address!.subLocality!.isNotEmpty) {
      addressLineArray.add(address!.subLocality!);
    }

    if (address!.locality != null && address!.locality!.isNotEmpty) {
      addressLineArray.add(address!.locality!);
    }

    if (address!.country != null && address!.country!.isNotEmpty) {
      addressLineArray.add(address!.country!);
    }

    if (mapController.value != null) {
      mapController.value!.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(argument.latitude, argument.longitude), 35));
    }
    refresh();
  }
}
