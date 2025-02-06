import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/model/delivery_boy_list_model.dart';
import 'package:b2c/model/emp_model.dart';
import 'package:b2c/screens/bottom_tap_bar_screen.dart';
import 'package:b2c/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../components/login_dialog.dart';

class DeliveryController extends GetxController {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAltMobile = TextEditingController();
  TextEditingController txtCity = TextEditingController();
  TextEditingController txtDeliveryArea = TextEditingController();
  TextEditingController txtVNumber = TextEditingController();
  TextEditingController txtAadhaar = TextEditingController();
  TextEditingController txtLicenceNumber = TextEditingController();
  TextEditingController txtLicenceExp = TextEditingController();
  TextEditingController txtDateOfBirth = TextEditingController();
  TextEditingController txtJoinDate = TextEditingController();
  TextEditingController txtAccountName = TextEditingController();
  TextEditingController txtBankName = TextEditingController();
  TextEditingController txtAccountNumber = TextEditingController();
  TextEditingController txtBranchName = TextEditingController();
  TextEditingController txtIFSCCode = TextEditingController();
  TextEditingController txtPanNumber = TextEditingController();
  TextEditingController txtDepositeAmt = TextEditingController();
  TextEditingController txtAssetGiven = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  String? profileImage;
  String? aadharCardURL;
  String? panCardURL;
  String? drivingLicenseNumberURL;
  RxBool isLoading = false.obs;
  EmployeeModel? employeeModel;
  List<Content> content = [];

  Future<void> getRiders() async {
    try {
      final String? response = await getRestCall();
      if (response != null && response!.isNotEmpty) {
        DliveryBoyListModel deli = dliveryBoyListModelFromJson(response);
        content = deli.content;
        log('message --> ${content.length}');
        update();
      }
    } on SocketException catch (e) {
      log('Socket --> ${e.message}');
    }
  }

  Future<void> selectProfileImage(ImageSource imageSource) async {
    Get.back();
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      profileImage = image.path;
      update();
    }
  }

  Future<void> selectAdharImage(ImageSource imageSource) async {
    Get.back();
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      aadharCardURL = image.path;
      log('image.path ---> ${image.path}');
      update();
    }
  }

  Future<void> selectPanImage(ImageSource imageSource) async {
    Get.back();
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      panCardURL = image.path;
      update();
    }
  }

  Future<void> selectDrivingImage(ImageSource imageSource) async {
    Get.back();
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      drivingLicenseNumberURL = image.path;
      update();
    }
  }

  Future<void> saveProfile() async {
    // try {

    if (GetHelperController.storeID.value.isNotEmpty) {
      isLoading = true.obs;
      update();
      Map<String, dynamic> bodyMap = {
        "firstName": txtFirstName.text,
        "lastName": txtLastName.text,
        "email": txtEmail.text,
        "password": txtPassword.text,
        "phoneNumber": txtMobile.text,
        "alterNativephoneNumber": txtAltMobile.text,
        "aadharCard": txtAadhaar.text,
        "aadharCardURL":
            await multiPartRestCall(keyName: 'image', fileName: aadharCardURL!),
        "drivingLicenseNumber": txtLicenceNumber.text,
        "drivingLicenseNumberURL": await multiPartRestCall(
            keyName: 'image', fileName: drivingLicenseNumberURL!),
        "drivingLicenseExpiry": txtLicenceExp.text,
        "delivaryArea": txtDeliveryArea.text,
        "city": txtCity.text,
        "panCard": txtPanNumber.text,
        "panCardURL":
            await multiPartRestCall(keyName: 'image', fileName: panCardURL!),
        "vechicleNumber": txtVNumber.text,
        "bankAccountName": txtAccountName.text,
        "bankName": txtBankName.text,
        "bankAccountNumber": txtAccountNumber.text,
        "ifsccode": txtIFSCCode.text,
        "bankBranch": txtBranchName.text,
        "userImageId":
            await multiPartRestCall(keyName: 'image', fileName: profileImage!),
        "amountDeposited": txtDepositeAmt.text,
        "storeId": GetHelperController.storeID.value,
        "applicationVerified": true,
        "profileUpdateEnable": true,
        "assetsGiven": txtAssetGiven.text,
        "joinDate": txtJoinDate.text,
        "dateOfBirth": txtDateOfBirth.text,
        "isDeleted": "N",
        "isActive": "Y",
        "grade": "A"
      };
      log('Body map --> $bodyMap');
      await postRestCall(body: bodyMap);
      isLoading = false.obs;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<String?>? multiPartRestCall({
    required String? keyName,
    required String? fileName,
    String? keyName2,
    String? fileName2,
  }) async {
    String? responseData;
    try {
      String requestUrl = '${ApiConfig.baseUrl}api-auth/image';
      Uri? requestedUri = Uri.tryParse(requestUrl);

      http.MultipartRequest request =
          http.MultipartRequest('POST', requestedUri!);
      var headers = {
        'Accept': '*',
        'Accept-Language': 'gu-IN,gu;q=0.9,en-US;q=0.8,en;q=0.7',
        'Connection': 'keep-alive',
        'DNT': '1',
        'Origin': 'http://137.59.201.109:81',
        'Referer': 'http://137.59.201.109:81/',
      };
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath(keyName!, fileName!));
      if (keyName2 != null && fileName2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath(keyName2, fileName2));
      }
      http.StreamedResponse responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          Map<String, dynamic> responseMap = jsonDecode(responseData);
          return responseMap['imgId'];
        case 500:
        case 502:
        case 400:
        case 404:
          log('${response.statusCode}');
          break;
        case 401:
          log('401 : ${response.body}');
          break;
        default:
          log('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      log('PlatformException in multiPartRestCall --> ${e.message}');
    }
    return responseData;
  }

  Future<String?>? postRestCall({required Map<String, dynamic>? body}) async {
    String? responseData;

    try {
      String requestUrl = '${ApiConfig.baseUrl}api-auth/rider/register';
      Uri? requestedUri = Uri.tryParse(requestUrl);

      log('Body map --> $body');
      var headers = {
        'Accept': 'application/json',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
      };
      http.Response response = await http.post(requestedUri!,
          body: jsonEncode(body), headers: headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          log('ResponseData --> $responseData');
          Get.offAll(() => const HomeScreen(), transition: Transition.size);
          CommonSnackBar.showError("Rider Added Successfully");
          break;
        case 400:
        case 410:
        case 500:
          responseData = response.body;
          log('ResponseData --> $responseData');
          Get.offAll(() => const HomeScreen(), transition: Transition.size);
          CommonSnackBar.showError("Something went wrong");
          Get.snackbar('${jsonDecode(responseData)['message']}', '');
          break;
        case 502:
        case 404:
          log('${response.statusCode}');
          CommonSnackBar.showError("Something went wrong");
          // Get.snackbar('${jsonDecode(response.body)['error']}', '');
          break;
        case 401:
          log('401 : ${response.body}');
          break;
        default:
          log('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      log('PlatformException in postRestCall --> ${e.message}');
    }
    return responseData;
  }

  Future<String?>? getRestCall() async {
    String? responseData;
    if (GetHelperController.storeID.value.isNotEmpty) {
      try {
        String storeId = GetHelperController.storeID.value;
        String requestUrl =
            '${ApiConfig.baseUrl}api-auth/emp/store/getAllRiders/$storeId?page=0&size=10';
        Uri? requestedUri = Uri.tryParse(requestUrl);
        print("getRiders url ---> $requestUrl");
        var headers = {'Content-Type': 'application/json'};
        http.Response response =
            await http.get(requestedUri!, headers: headers);

        switch (response.statusCode) {
          case 200:
          case 201:
          case 400:
            responseData = response.body;
            break;
          case 404:
          case 500:
          case 502:
            log('${response.statusCode}');
            break;
          case 401:
            log('401 : ${response.body}');
            break;
          default:
            log('${response.statusCode} : ${response.body}');
            break;
        }
      } on PlatformException catch (e) {
        log('PlatformException in getRestCall --> ${e.message}');
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    return responseData;
  }
}
