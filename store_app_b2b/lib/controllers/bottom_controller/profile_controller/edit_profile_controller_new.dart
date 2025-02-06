import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/delivery_slots_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/utils/string_extensions_new.dart';

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var isButtonLoading = false.obs;
  final ImagePicker imagePicker = ImagePicker();
  String userId = "";

  /// Edit Profile Screen
  RxInt selectedBusinessType = 0.obs;
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
  TextEditingController pharmaNameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();
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
  FocusNode registeredNameFocus = FocusNode();
  FocusNode documentFocus = FocusNode();
  FocusNode landmarkFocus = FocusNode();
  FocusNode storeLocationFocus = FocusNode();
  FocusNode dealsInFocus = FocusNode();
  FocusNode popularFocus = FocusNode();
  FocusNode storeAddressFocus = FocusNode();
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
    userId = await SharPreferences.getString(SharPreferences.loginId);
    print(">>>>>>>>>>>>>>>>>>>>>>>>$userId");
    isLoading.value = false;
  }

  getCategory() async {
    try {
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

  Future<dynamic> getProfileDataApi() async {
    isLoading.value = true;
    deliverySlotsList.clear();
    if (userId.isNotEmpty) {
      try {
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(API.profile + "/$userId"),
            headers: headers);
        log("===>>>>${response.body}");
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          profileData = responseBody;
          if (responseBody != "null") {
            storeBackImage = responseBody['imageUrl']['bannerImageId'] ?? "";
            storeFrontImage = responseBody['imageUrl']['profileImageId'] ?? "";

            ownerNameController.text = responseBody['ownerName'] ?? "";
            storeNameController.text = responseBody['storeName'] ?? "";
            phoneController.text = responseBody['phoneNumber'] ?? "";
            emailController.text = responseBody['email'] ?? "";
            addressController.text =
                responseBody['storeAddressDetailRequest'][0]['addressLine1'];
            dealsInController.text = responseBody['dealsIn'] ?? "";
            popularController.text = responseBody['popularIn'] ?? "";
            gstController.text = responseBody['gst']['gstNumber'] ?? "";
            gstNumber = responseBody['gst']['docUrl'] ?? "";
            storeLicenseController.text =
                responseBody['storeLicense']['storeLicense'] ?? "";
            storeLicense = responseBody['storeLicense']['docUrl'] ?? "";
            drugLicenseController.text =
                responseBody['drugLicense']['drugLicenseNumber'] ?? "";
            storeDrugLicense = responseBody['drugLicense']['documentId'] ?? "";

            deliverySlotsList.addAll(List.from(responseBody['slots'])
                .map<DeliverySlotsModel>(
                    (item) => DeliverySlotsModel.fromJson(item))
                .toList());

            selectedBusinessType.value =
                responseBody['businessType'] == "Retailer" ? 0 : 1;
            selectBusiness = responseBody['storeCategory'] ?? "";
            selectBusinessId = responseBody["storeCategoryId"] ?? "";
            // deliverySlotsList = List.from(responseBody['slots']);
            pharmaNameController.text =
                responseBody['registeredPharmacistName'] ?? "";
            documentController.text = responseBody['drugLicenseAddress'] ?? "";
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
          CommonSnackBar.showError('Something went wrong.');
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
    String loginId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    log("profileData==>> $profileData");
    Map<String, dynamic> bodyMap = {
      "id": loginId,
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "password": profileData['password'],
      "otp": profileData['otp'],
      "storeName": storeNameController.text,
      "businessType": selectedBusinessType.value,
      "storeCategory": selectBusiness,
      "storeCategoryId": selectBusinessId,
      "ownerName": ownerNameController.text,
      "isDeleted": profileData['isDeleted'],
      "isActive": profileData['isActive'],
      "createdAt": profileData['createdAt'],
      "createdBy": profileData['createdBy'],
      "modifiedBy": profileData['modifiedBy'],
      "modifiedDate": "2023-05-27T20:27:13.492Z",
      "dealsIn": dealsInController.text,
      "popularIn": popularController.text,
      "storeNumber": profileData['storeNumber'],
      "openTime": storeOpeningController.text,
      "closeTime": storeClosingController.text,
      "deliveryStrength": deliveryStrengthController.text,
      "applicationStatus": profileData['applicationStatus'],
      "applicationStatusDate": profileData['applicationStatusDate'],
      "boarded": profileData['boarded'],
      "retailerBirthday": profileData['retailerBirthday'],
      "retailerMarriageDay": weddingAniversaryController.text,
      "retailerChildOneBirthDay": childOneController.text,
      "retailerChildTwoBirthDay": childTwoController.text,
      "retailerMessage": messageController.text,
      "storeRating": profileData['storeRating'],
      "storeLiveStatus": profileData['storeLiveStatus'],
      "storeDisplayid": profileData['storeDisplayid'],
      "profileUpdateEnbale": profileData['profileUpdateEnbale'],
      'gst': {
        'gstNumber': gstController.text,
        'docUrl': gstNumber == null ? '' : gstNumber.toString()
      },
      'storeLicense': {
        'storeLicense': storeLicenseController.text,
        'docUrl': storeLicense == null ? '' : storeLicense.toString()
      },
      'drugLicense': {
        'drugLicenseNumber': drugLicenseController.text,
        'documentId':
            storeDrugLicense == null ? '' : storeDrugLicense.toString()
      },
      "deliveryType": profileData['deliveryType'],
      'slots': slotsListMap,
      "storeAddressDetailRequest": [
        {
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
      "drugLicenseAddress": documentController.text,
      "reason": profileData['reason'],
      "gstVerifed": profileData['gstVerifed'],
      "storeLicenseVerifed": profileData['storeLicenseVerifed'],
      "drugLicenseVerifed": profileData['drugLicenseVerifed'],
      "registeredPharmacistName": pharmaNameController.text
    };
    print("bodyMAp====>>>>$bodyMap");
    if (loginId.isNotEmpty) {
      try {
        isButtonLoading.value = true;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.put(
          Uri.parse(API.editProfile),
          headers: headers,
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
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
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
      Uri? requestedUri = Uri.tryParse(API.uploadImageURL);
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
}
