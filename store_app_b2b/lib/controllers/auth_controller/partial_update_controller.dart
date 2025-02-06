import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_platform_interface/src/types/image_source.dart';
import 'package:store_app_b2b/utils/string_extensions.dart';
import 'package:store_app_b2b/utils/validation_utils.dart';

class PartialUpdateController extends GetxController {
  TextEditingController gstController = TextEditingController();
  FocusNode gstFocus = FocusNode();
  String gstUrl = "";

  TextEditingController storeLicenseController = TextEditingController();
  FocusNode storeLicenseFocus = FocusNode();
  String storeLicenseUrl = "";

  TextEditingController drugLicenseController = TextEditingController();
  FocusNode drugLicenseFocus = FocusNode();
  String drugLicenseUrl = "";

  TextEditingController durgLicenseExpiryController = TextEditingController();
  FocusNode drugLicenseExpiryFocus = FocusNode();

  TextEditingController pharmaNameController = TextEditingController();
  FocusNode registeredNameFocus = FocusNode();

  //validation
  Future<void> validate(List<String> types) async {
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

    if (types.contains('gst')) {
      if (!isValidGst(gstController.text) && gstController.text.isNotEmpty) {
        'Gst number format is not valid (Eg. 22AAAAA0000A1Z5)'.showError();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        // });
        return;
      }

      if (gstController.text.isNotEmpty && gstUrl == "") {
        'Please upload gst image'.showError();
        return;
      }
    }

    if (types.contains('store')) {
      if (ValidationUtils.instance
          .validateEmptyController(storeLicenseController)) {
        'Store License can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(storeLicenseFocus);
        });
        return;
      }

      if (storeLicenseController.text.isNotEmpty && storeLicenseUrl == "") {
        'Please upload store license image'.showError();
        return;
      }
    }

    if (types.contains('drug')) {
      if (ValidationUtils.instance
          .validateEmptyController(drugLicenseController)) {
        'Drug license can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(drugLicenseFocus);
        });
        return;
      }

      if (drugLicenseUrl == "") {
        'Please upload drug license image'.showError();
        return;
      }

      if (durgLicenseExpiryController.text.isEmpty) {
        'Drug license expiry date can\'t be empty'.showError();
      }

      if (ValidationUtils.instance
          .validateEmptyController(pharmaNameController)) {
        'Registered pharmacist name can\'t be empty'.showError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(Get.context!).requestFocus(registeredNameFocus);
        });
        return;
      }
    }

    'Success'.showError();
  }

  //upload photo
  final ImagePicker imagePicker = ImagePicker();

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
            gstUrl = await uploadProfilePhoto(image.path);
            print("gsturl -. $gstUrl");
          } else if (type == 'store') {
            storeLicenseUrl = await uploadProfilePhoto(image.path);
          } else if (type == 'drug') {
            drugLicenseUrl = await uploadProfilePhoto(image.path);
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
