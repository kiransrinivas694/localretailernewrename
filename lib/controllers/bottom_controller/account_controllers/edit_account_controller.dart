import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/controllers/home_controller.dart';
import 'package:b2c/helper/firebase_gettoken_backup.dart';
import 'package:b2c/model/delivery_slots_model.dart';
import 'package:b2c/screens/auth/app_process_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/otp_edit_screen.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:b2c/utils/validation_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/service/api_service.dart';

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var isButtonLoading = false.obs;
  final ImagePicker imagePicker = ImagePicker();
  String userId = "";

  /// Edit Profile Screen
  RxString selectedBusinessType = "Retailer".obs;
  String businessType = "";
  String selectBusiness = "";
  String selectBusinessId = "";
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
  TextEditingController drugLicenseExpiryController = TextEditingController();
  TextEditingController pharmaNameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController dealsInController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController popularController = TextEditingController();
  TextEditingController storeOpeningController = TextEditingController();
  TextEditingController storeClosingController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weddingAniversaryController = TextEditingController();
  TextEditingController retailerBirthdateController = TextEditingController();
  TextEditingController childOneController = TextEditingController();
  TextEditingController childTwoController = TextEditingController();
  TextEditingController deliveryStrengthController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String otp = "";

  List<DeliverySlotsModel> deliverySlotsList = [];
  List businessCategoryList = [];

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
  FocusNode stateFocus = FocusNode();
  FocusNode pincodeFocus = FocusNode();
  FocusNode storeOpeningFocus = FocusNode();
  FocusNode storeClosingFocus = FocusNode();

  String? gstNumber;
  String? storeLicense;
  String? storeDrugLicense;

  String? storeBackImage;
  String? storeFrontImage;

  String? latitude;
  String? longitude;

  var profileData = {};

  Future<dynamic> getUserId() async {
    isLoading.value = true;
    userId = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        "";
    print(">>>>>>>>>>>>>>>>>>>>>>>>$userId");
    isLoading.value = false;
  }

  getCategory() async {
    try {
      log('GetCategory --> ${ApiConfig.getCategory}');
      final response = await http.get(Uri.parse(ApiConfig.getCategory),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);
      print("response>>>>>>>$response");
      print("responseBody>>>$responseBody");

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        businessCategoryList = responseBody;
      } else {
        // CommonSnackBar.showError(responseBody['error'].toString());
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

  Future<dynamic> editValidation(screenType) async {
    if (storeFrontImage == null) {
      'Please select store profile image'.showError();
      return;
    }

    if (storeBackImage == null) {
      'Please select store back image'.showError();
      return;
    }
    if (selectBusiness == "") {
      'Please select business type'.showError();
      return;
    }
    // if (ValidationUtils.instance.validateEmptyController(userNameController)) {
    //   'Username can\'t be empty'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(userNameFocusNode);
    //   });
    //   return;
    // }
    if (ValidationUtils.instance.validateEmptyController(ownerNameController)) {
      'Enter The Owner Name'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(ownerNameFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(storeNameController)) {
      'Enter The Store Name'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNameFocus);
      });
      return;
    }
    if (ValidationUtils.instance
        .validateEmptyController(storeNumberController)) {
      'Enter The Store Number'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNumberFocus);
      });
      return;
    }
    if (phoneController.text.isNotEmpty) {
      if (ValidationUtils.instance.lengthValidator(phoneController, 10)) {
        'Enter The Mobile Number'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(phoneFocusNode);
        });
        return;
      }
    }

    if (ValidationUtils.instance.validateEmptyController(emailController)) {
      'Enter The Email'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(emailFocus);
      });
      return;
    }
    if (!ValidationUtils.instance
        .regexValidator(emailController, ValidationUtils.emailRegExp)) {
      'Enter The Valid Email '.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(emailFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(addressController)) {
      'Enter The Address'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeAddressFocus);
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
    // if (ValidationUtils.instance.validateEmptyController(gstController)) {
    //   'Enter The GST Numbers'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(gstFocus);
    //   });
    //   return;
    // }

    if (storeLicenseController.text.isNotEmpty) {
      if (storeLicenseController.text.length < 10) {
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

    // if (ValidationUtils.instance
    //     .validateEmptyController(storeLicenseController)) {
    //   'Enter The Store License'.showError();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
    //   });
    //   return;
    // }

    if (selectBusiness == "Medical") {
      if (ValidationUtils.instance
          .validateEmptyController(drugLicenseController)) {
        'Enter The Drug licence'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        });
        return;
      }
      if (storeDrugLicense == null) {
        'Please Select Store Drug Licence Image'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        });
        return;
      }
      if (ValidationUtils.instance
          .validateEmptyController(pharmaNameController)) {
        'Enter The Registered Pharmacist Name'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(registeredNameFocus);
        });
        return;
      }
    }

    if (ValidationUtils.instance
        .validateEmptyController(storeOpeningController)) {
      'Enter The Store Opening Time'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeOpeningFocus);
      });
      return;
    }
    if (ValidationUtils.instance
        .validateEmptyController(storeClosingController)) {
      'Enter The Store Closing Time'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeClosingFocus);
      });
      return;
    }

    // bool isStoreNumberVerified = await verifyStoreNumber();

    // if (isStoreNumberVerified) {
    //   return;
    // }
    if (initialEmail != emailController.text) {
      bool isEmaiNumberExists = await verifyEmailOtp();

      if (isEmaiNumberExists) {
        return;
      }
    }

    log('Form Submission Done');
    // 'Form Submission Done'.showError();
    // return;

    if (screenType == 'reject') {
      await editProfilePostDataApi().then((value) {
        if (value != null) {
          Get.offAll(AppProcessScreen());
        }
      });
    } else {
      if (storeNumberController.text != profileData['storeNumber']) {
        print(
            "printing storeNumberCOntroller ---> ${storeNumberController.text}");
        print(
            "printing profileData storeNumber ---> ${profileData['storeNumber']}");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          checkNumberStatusApi();
        });
      } else {
        print(
            "printing storeNumberController 2---> ${storeNumberController.text}");
        print(
            "printing profileData storeNumber 2---> ${profileData['storeNumber']}");
        await editProfilePostDataApi().then((value) {
          if (value != null) {
            Get.back();
          }
        });
      }
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
        if (responseMap['status']) {
          'Email already exist'.showError();
        }
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
    return false;
  }

  Future<dynamic> checkNumberStatusApi() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.checkNumber +
            "?phoneNumber=${storeNumberController.value.text}&role=Retailer"),
        /* headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }*/
      );
      log("===>>>>${ApiConfig.checkNumber + "?phoneNumber=${storeNumberController.value.text}&role=Retailer"}",
          name: 'CHECK NUMBER API');
      log("===>>>>${response.body}", name: 'CHECK NUMBER API');
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty) {
          if ((responseBody['response'] ?? false)) {
            CommonSnackBar.showError(
                'Already Number exists, Provide Other Number');
          } else {
            print(
                "printing storeNumberController before going to otp screen ---> ${storeNumberController.value.text}");
            Get.to(
                () => OTPEditScreen(mobile: storeNumberController.value.text));
          }
          log((!(responseBody['response'] ?? false)).toString(),
              name: 'responseBody.isNotEmpty');
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  String initialStoreNumber = "";
  String initialEmail = "";

  Future<dynamic> getProfileDataApi() async {
    userId = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        "";
    if (userId.isNotEmpty) {
      isLoading.value = true;
      deliverySlotsList.clear();
      try {
        log('printing getPRofileData Url -->${ApiConfig.profile + "/$userId"}');
        final response = await http.get(
          Uri.parse(ApiConfig.profile.trimLeft() + "/$userId"),
          /* headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            }*/
        );

        log("===>>>>${response.body}");

        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          GetHelperController.categoryID.value =
              responseBody['storeCategoryId'] ?? '';
          GetHelperController.categoryName.value =
              responseBody['storeCategory'] ?? '';
          log(GetHelperController.categoryID.value,
              name: 'storeCategoryId GetHelperController');
          profileData = responseBody;
          print("res --> ${responseBody}");
          if (responseBody != "null") {
            print(">>>>>>>>>>>>>>>>>>>>>>>>${responseBody}");
            print(
                "responseBody['drugLicense'] >>>>>>>>>>>>>>>>>>>>>>>>${responseBody['drugLicense']}");
            storeBackImage = responseBody['imageUrl']['bannerImageId'] ?? "";
            storeFrontImage = responseBody['imageUrl']['profileImageId'] ?? "";

            ownerNameController.text = responseBody['ownerName'] ?? "";
            storeNameController.text = responseBody['storeName'] ?? "";
            storeNumberController.text = responseBody['storeNumber'] ?? "";
            initialStoreNumber = responseBody['storeNumber'] ?? "";
            initialEmail = responseBody['email'] ?? "";
            GetHelperController.storeName.value =
                responseBody['storeName'] ?? '';
            appBarTitle.value = responseBody['storeName'] ?? '';

            phoneController.text = responseBody['phoneNumber'] ?? "";
            emailController.text = responseBody['email'] ?? "";
            stateController.text = responseBody["state"] ?? '';
            pincodeController.text = responseBody["pinCode"] ?? '';
            addressController.text =
                responseBody['storeAddressDetailRequest'][0]['addressLine1'];
            dealsInController.text = responseBody['dealsIn'] ?? "";
            popularController.text = responseBody['popularIn'] ?? "";
            gstController.text =
                (responseBody['gst']['gstNumber'] ?? "").toUpperCase() ==
                        "NO GST"
                    ? ""
                    : responseBody['gst']['gstNumber'];
            gstNumber = responseBody['gst']['docUrl'] ?? "";
            storeLicenseController.text =
                (responseBody['storeLicense']['storeLicense'] ?? "")
                            .toUpperCase() ==
                        "NO STORE LICENSE"
                    ? ""
                    : responseBody['storeLicense']['storeLicense'];
            storeLicense = responseBody['storeLicense']['docUrl'] ?? "";
            drugLicenseController.text =
                responseBody['drugLicense']['drugLicenseNumber'] ?? "";
            drugLicenseExpiryController.text =
                responseBody["drugLicense"]["expiryDate"] ?? "";
            storeDrugLicense = responseBody['drugLicense']['documentId'] ?? "";
            latitude =
                responseBody['storeAddressDetailRequest'][0]['latitude'] ?? "";
            longitude =
                responseBody['storeAddressDetailRequest'][0]['longitude'] ?? "";
            log("working at 10");
            deliverySlotsList.addAll(List.from(responseBody['slots'])
                .map<DeliverySlotsModel>(
                    (item) => DeliverySlotsModel.fromJson(item))
                .toList());
            log("working at 11");
            selectedBusinessType.value = responseBody['businessType'];
            selectBusiness = responseBody['storeCategory'] ?? "";
            print("selectBusiness>>>>>>>>>>>>>>>$selectBusiness");
            selectBusinessId = responseBody["storeCategoryId"] ?? "";
            // deliverySlotsList = List.from(responseBody['slots']);
            pharmaNameController.text =
                responseBody['registeredPharmacistName'] ?? "";
            documentController.text = responseBody['drugLicenseAddress'] ?? "";
            retailerBirthdateController.text =
                profileData['retailerBirthday'] ?? '';
            weddingAniversaryController.text =
                responseBody['retailerMarriageDay'] ?? "";

            childOneController.text =
                responseBody['retailerChildOneBirthDay'] ?? "";
            childTwoController.text =
                responseBody['retailerChildTwoBirthDay'] ?? "";
            storeOpeningController.text = responseBody['openTime'] ?? "";
            storeClosingController.text = responseBody['closeTime'] ?? "";
            deliveryStrengthController.text =
                responseBody['deliveryStrength'] ?? "";
            messageController.text = responseBody['retailerMessage'] ?? "";
            print(deliverySlotsList);
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
          // CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> editProfilePostDataApi() async {
    List<Map<String, dynamic>> slotsListMap = [];
    for (DeliverySlotsModel element in deliverySlotsList) {
      slotsListMap.add(element.toJson());
    }

    log('log bodymap of slotslistmap - ${jsonEncode(deliverySlotsList)}');

    // String FcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    String FcmToken = await getFirebaseToken();

    Map<String, dynamic> bodyMap = {
      "id": await PreferencesHelper()
              .getPreferencesStringData(PreferencesHelper.storeID) ??
          "",
      "fcmToken": FcmToken,
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "password": profileData['password'],
      "otp": profileData['otp'],
      "storeName": storeNameController.text.toUpperCase(),
      "businessType": "Retailer" /*selectedBusinessType.value*/,
      "storeCategory": selectBusiness,
      "storeCategoryId": selectBusinessId,
      "ownerName": ownerNameController.text.toUpperCase(),
      "isDeleted": profileData['isDeleted'],
      "isActive": profileData['isActive'],
      "createdAt": profileData['createdAt'],
      "createdBy": profileData['createdBy'],
      "modifiedBy": profileData['modifiedBy'],
      "modifiedDate": "2023-05-27T20:27:13.492Z",
      "dealsIn": dealsInController.text.toUpperCase(),
      "popularIn": popularController.text.toUpperCase(),
      "storeNumber": storeNumberController.text,
      "openTime": storeOpeningController.text,
      "closeTime": storeClosingController.text,
      "deliveryStrength": deliveryStrengthController.text,
      "applicationStatus": profileData['applicationStatus'] == "Rejected"
          ? "Pending"
          : profileData['applicationStatus'],
      "applicationStatusDate": profileData['applicationStatusDate'],
      "boarded": profileData['boarded'],
      "retailerBirthday": retailerBirthdateController.text,
      "retailerMarriageDay": weddingAniversaryController.text,
      "retailerChildOneBirthDay": childOneController.text,
      "retailerChildTwoBirthDay": childTwoController.text,
      "retailerMessage": messageController.text.toUpperCase(),
      "storeRating": profileData['storeRating'],
      "storeLiveStatus": profileData['storeLiveStatus'],
      "storeDisplayid": profileData['storeDisplayid'],
      "profileUpdateEnbale": profileData['profileUpdateEnbale'],
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
        'expiryDate': drugLicenseExpiryController.text,
      },
      "deliveryType": profileData['deliveryType'],
      'slots': slotsListMap,
      "storeAddressDetailRequest": [
        {
          "id": profileData["storeAddressDetailRequest"] is List &&
                  profileData["storeAddressDetailRequest"]!.isNotEmpty
              ? profileData["storeAddressDetailRequest"]![0]["id"] ?? ""
              : "",
          "mobileNumber": profileData['mobileNumber'] ?? "",
          "name": profileData['name'] ?? "",
          "addresslineMobileOne": profileData['addresslineMobileOne'],
          "addresslineMobileTwo": profileData['addresslineMobileTwo'],
          "addressType": profileData['addressType'] ?? "",
          "alterNateMobileNumber": profileData['alterNateMobileNumber'],
          "emailId": profileData['emailId'],
          "pinCode": profileData['pinCode'],
          'addressLine1': addressController.text,
          "addressLine2": profileData['addressLine2'],
          'landMark': profileData['landMark'],
          "city": profileData['city'],
          "region": profileData['region'],
          "state": profileData['state'],
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          "geoLocation": {
            "x": profileData['x'],
            "y": profileData['y'],
            "type": profileData['type'],
            "coordinates": profileData['coordinates'],
          }
        }
      ],
      "imageUrl": {
        'bannerImageId': storeBackImage,
        'profileImageId': storeFrontImage
      },
      "drugLicenseAddress": documentController.text.toUpperCase(),
      "reason": profileData['reason'],
      "gstVerifed": profileData['gstVerifed'],
      "storeLicenseVerifed": profileData['storeLicenseVerifed'],
      "drugLicenseVerifed": profileData['drugLicenseVerifed'],
      "registeredPharmacistName": pharmaNameController.text.toUpperCase(),
      "state": stateController.text,
      "pinCode": pincodeController.text,
    };
    logs("updateStore bodyMap --> ${bodyMap}");
    logs(
        "logging updateStore addressLine1 , addressLine 2 , lat , lng bodyMap --> ${bodyMap["storeAddressDetailRequest"]}");
    log("updateStore bodyMap --> ${bodyMap}");

    print("bodyMAp====>>>>$bodyMap");

    try {
      isButtonLoading.value = true;
      final response = await http.put(
        Uri.parse(ApiConfig.editProfile),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(bodyMap),
      );
      print("===>>>>${response.body}");
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody != "null") {
          getProfileDataApi();
          return responseBody;
        }
        isButtonLoading.value = false;
      } else {
        isButtonLoading.value = false;
        CommonSnackBar.showError(responseBody['error']);
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
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
    }
    refresh();
    update();
  }

  Future<dynamic> uploadProfilePhoto(filepath) async {
    try {
      Uri? requestedUri = Uri.tryParse(ApiConfig.uploadImageURL);
      print("profilePhotoResponse uri>>>>>>>>$requestedUri");

      var request = http.MultipartRequest('POST', requestedUri!);
      request.files.add(await http.MultipartFile.fromPath('image', filepath!,
          contentType: MediaType.parse('image/jpeg')));
      Map<String, String> headers = {'Content-Type': 'application/json'};

      headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(headers);

      StreamedResponse res = await request.send();
      print("res>>>>>>>>$res");

      final responseData = await http.Response.fromStream(res);
      Map<String, dynamic> responseMap = jsonDecode(responseData.body);
      print("profilePhotoResponse>>>>>>>>$responseMap");

      if (responseMap != null) {
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

  //// EDIT OTP Controller
  Timer? timer;
  RxInt timerValue = 59.obs;
  bool? isVerified;

  void manageTimer() {
    timerValue = 59.obs;
    // !storeVerified ? sendOtp() : sendOwnerOtp();
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      timerValue--;
      update();
      if (timerValue <= 0) timer!.cancel();
    });
  }

  Future<dynamic> getOtp(flag, {number = ""}) async {
    try {
      print(
          "printing getOtp call --->${ApiConfig.sendOtp} + ${"/$flag?phoneNumber=$number"}");
      final response = await http.post(
        Uri.parse(ApiConfig.sendOtp +
            "/$flag?phoneNumber=${number == "" ? phoneController.text : number}"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        return responseBody;
      } else {
        CommonSnackBar.showError(responseBody['message'].toString());
        // responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> verifyOtp({number = ""}) async {
    if (otp == "") {
      CommonSnackBar.showError("Please enter otp");
    } else {
      try {
        print(
            "printing verfiyOtp Number ---> ${ApiConfig.verifyOtp + "?otp=$otp&phoneNumber=${number == "" ? phoneController.text : number}"}");
        final response = await http.get(
          Uri.parse(ApiConfig.verifyOtp +
              "?otp=$otp&phoneNumber=${number == "" ? phoneController.text : number}"),
          headers: <String, String>{'Content-Type': 'application/json'},
        );
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);

        if (response.statusCode == 200) {
          if (responseBody["type"] == "success") {
            isVerified = true;
            update();
            return responseBody;
          } else {
            isVerified = false;
            update();
          }
          // otpValue.value = responseBody['data']['otp'];
          // responseBody['message'].showError();

          return responseBody;
        } else {
          CommonSnackBar.showError(responseBody['message'].toString());
          // responseBody['message'].toString().showError();
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        // e.message.toString().showError();
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        // e.message.toString().showError();
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
