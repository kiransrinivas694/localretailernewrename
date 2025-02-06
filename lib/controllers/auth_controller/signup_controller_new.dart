import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar_new.dart';
import 'package:b2c/model/delivery_slots_model_new.dart';
import 'package:b2c/screens/auth/otp_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_2_screen_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/service/location_service_new.dart';
import 'package:b2c/utils/shar_preferences_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:b2c/utils/validation_utils_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignupController extends GetxController {
  final isLoading = false.obs;
  final ImagePicker imagePicker = ImagePicker();
  int selectedOnboardIndex = 0;

  final password = false.obs;
  final confirmPassword = false.obs;
  RxString selectedBusinessType = "Retailer".obs;
  String businessType = "";
  String selectBusiness = "";
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

  List<DeliverySlotsModel> deliverySlotsList = <DeliverySlotsModel>[].obs;
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

  /// end point : api-auth/store/m/register
  /// base url : https://dev.acintyotechapi.com/

  getCategory() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getCategory),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);

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

  registerUser() async {
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
    if (ValidationUtils.instance.lengthValidator(storeNumberController, 10)) {
      'Store number should contain 10 digits'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeNumberFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(ownerNameController)) {
      'Enter The Owner Name'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(ownerNameFocus);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(phoneController)) {
      'Phone number can\'t be empty'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(phoneFocusNode);
      });
      return;
    }
    if (ValidationUtils.instance.lengthValidator(phoneController, 10)) {
      'Phone number should have 10 digits'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(phoneFocusNode);
      });
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(passwordController)) {
      'Enter The Valid Password'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(passwordFocus);
      });
      return;
    }
    if (ValidationUtils.instance
        .validateEmptyController(confirmPasswordController)) {
      'Enter The Confirm Password'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(confirmPasswordFocus);
      });
      return;
    }
    if (passwordController.text.toString() !=
        confirmPasswordController.text.toString()) {
      'Enter Password Or Confirm Password Not Match'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(passwordFocus);
      });
      return;
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
    if (ValidationUtils.instance
        .validateEmptyController(storeLicenseController)) {
      'Enter The Store License'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
      });
      return;
    }

    if (selectBusinessStatus.value == "Y") {
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
    // Get.to(() => MobileNoScreen(), arguments: phoneController.text);
    Get.to(() => SignUp2Screen());
  }

  registerTowUser() async {
    if (ValidationUtils.instance
        .validateEmptyController(storeLocationController)) {
      'Enter The Location Address'.showError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(Get.context!).requestFocus(storeAddressFocus);
      });
      return;
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

    Get.to(() =>
        OTPScreen(type: "register", mobile: phoneController.text.toString()));
  }

  Future<dynamic> registerPost() async {
    isLoading(true);
    try {
      List<Map<String, dynamic>> slotsListMap = [];
      for (DeliverySlotsModel element in deliverySlotsList) {
        slotsListMap.add(element.toJson());
      }
      Map<String, dynamic> bodyMap = {
        "otp": otp,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'password': passwordController.text,
        'storeName': storeNameController.text,
        'businessType': "Retailer" /*selectedBusinessType.value*/,
        'storeCategory': selectBusiness,
        'storeCategoryId': selectBusinessId,
        'ownerName': ownerNameController.text,
        'storeNumber': storeNumberController.text,
        'openTime': storeOpeningController.text,
        'closeTime': storeClosingController.text,
        "dealsIn": dealsInController.text,
        "popularIn": dealsInController.text,
        'deliveryStrength': deliveryStrengthController.text,
        'retailerBirthday': birthDateController.text,
        'retailerMarriageDay': weddingAniversaryController.text,
        'retailerChildOneBirthDay': childOneController.text,
        'retailerChildTwoBirthDay': childTwoController.text,
        'retailerMessage': messageController.text,
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
        'slots': slotsListMap,
        'storeAddressDetailRequest': [
          {
            'addressType': 'shop',
            'addressLine1': storeLocationController.text,
            'landMark': landmarkController.text,
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
          }
        ],
        'imageUrl': {
          'bannerImageId': storeBackImage,
          'profileImageId': storeFrontImage
        },
        'drugLicenseAddress': documentController.text,
        'registeredPharmacistName': pharmaNameController.text,
        'boarded': await SharPreferences.getString(SharPreferences.loginId)
      };
      log(bodyMap.toString(), name: 'REGISTER PARAMS');
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("++++++++response+++++++++$responseBody");

      if (response.statusCode == 200 && responseBody['status'] == true) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        print(responseBody);
        isLoading(false);

        return responseBody;

        // Get.to(() => MobileNoScreen(), arguments: phoneController.text);

        print("sucsecc");

        return responseBody;
      } else {
        isLoading(false);
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
  }

  getDeliverySlots() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.deliverySlots),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);
      print("response>>>>>>>$response");
      print("responseBody>>>$responseBody");

      if (response.statusCode == 200) {
        deliverySlotsList = deliverySlotsModelFromJson(response.body);
        for (int i = 0; i < deliverySlotsList.length; i++) {
          // deliverySlotsList[i].isChecked = true;
          print(deliverySlotsList[i].isChecked);
        }
        update();
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
    log("logging image");
    log("$image");
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

class MapController extends GetxController {
  bool isLoading = true;
  Map<String, dynamic> bodyMap = {};
  Position? position;
  final Set<Marker> markers = {};
  Placemark? address;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    refresh();
    bool isAllowed = await LocationService.instance.checkLocationPermission();
    if (isAllowed) {
      if (bodyMap.isEmpty) {
        position = await LocationService.instance.getCurrentLocation();
        manageMarker(LatLng(position!.latitude, position!.longitude));
        update();
      } else {
        manageMarker(LatLng(double.parse(bodyMap['latitude']),
            double.parse(bodyMap['longitude'])));
      }
    } else {
      getCurrentLocation();
    }
    isLoading = false;
    refresh();
  }

  Future<void> manageMarker(LatLng argument) async {
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
    refresh();
  }
}
