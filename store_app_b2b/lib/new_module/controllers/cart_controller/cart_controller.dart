// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mysaaa/app/utils/app_utils.dart';

// import 'package:mysaaa/constant/app_api_type_constants.dart';
// import 'package:mysaaa/controllers/address_controller/address_controller.dart';
// import 'package:mysaaa/controllers/global_controller/global_controller.dart';
// import 'package:mysaaa/models/cart/cart_response_model.dart';
// import 'package:mysaaa/models/check_out_model.dart';
// import 'package:mysaaa/screens/order_module/order_placed_screen.dart';
// import 'package:mysaaa/services/api_service.dart';
// import 'package:mysaaa/services/apiresponse.dart';
// import 'package:mysaaa/services/payloads.dart';
// import 'package:mysaaa/services/rest_service.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:toastification/toastification.dart';

// class CartController extends GetxController implements APiResponseFlow {
//   var medicinesCart = Rx<CartResponseModel?>(null);
//   final isMedicinesCartLoading = false.obs;
//   var beforeCheckoutData = Rx<BeforeCheckOutModel?>(null);

//   final isBeforeCheckoutLoading = false.obs;
//   final isAfterCheckoutLoading = false.obs;

//   late Razorpay razorpay;

//   //upload prescription related
//   final isUploadPrescriptionLoading = false.obs;

//   //main cart screen related
//   final activeMainCartTab = 0.obs;

//   //cart info screen related
//   final activeInfoTab = 0.obs;

//   //prescription related
//   var prescriptionUrls = <String>[].obs;
//   var isPrescriptionNeeded = false.obs;
//   var isAllAreRequiredPrescription = true.obs;

//   //consult doctor form
//   TextEditingController patientNameController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController relationController = TextEditingController();
//   String? selectedGender;

//   @override
//   Future<void> onInit() async {
//     razorpay = Razorpay();
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     super.onInit();
//   }

//   void addImageUrl(String url) {
//     prescriptionUrls.add(url);
//   }

//   List<Map<String, String>> createPrescriptionObjects(List<String> urls) {
//     return urls.map((url) {
//       return {'imageId': url, 'prescriptionId': ''};
//     }).toList();
//   }

//   /// ---- CONTINUE WITHOUT PRESCRIPTION STARTS HERE ---- ///

//   var isContinueWithoutPrescriptionLoading = false.obs;

//   Future<void> continueWithoutPrescription() async {
//     try {
//       isContinueWithoutPrescriptionLoading.value = true;

//       String userId = await getUserId();

//       Map<String, dynamic> map = Payloads().continuewWithoutPrescription(
//         cartId: medicinesCart.value!.data!.storeVo![0].cartId ?? '',
//         storeId: "AL-R202306-001",
//         userId: userId,
//       );

//       await RestServices.instance.putRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           apiType: ApiTypes.continueWithoutPrescription);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isContinueWithoutPrescriptionLoading.value = false;
//     }
//   }

//   Future<void> continueWithoutPrescriptionOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     Map<String, dynamic> response = data as Map<String, dynamic>;

//     logs("continue is success");

//     if (response.containsKey("status") && response["status"]) {
//       isAllAreRequiredPrescription.value = false;
//       GlobalController gbc = Get.put(GlobalController());
//       gbc.getAppWideCart();
//       getUserCart();
//     }

//     // response
//     isContinueWithoutPrescriptionLoading.value = false;
//   }

//   Future<void> continueWithoutPrescriptionOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isContinueWithoutPrescriptionLoading.value = false;
//   }

//   /// ---- CONTINUE WITHOUT PRESCRIPTION API ENDS HERE ---- ///

//   /// ---- CONSULT DOCTOR API STARTS HERE ---- ///

//   void cleanUpConsultForm() {
//     patientNameController.text = '';
//     mobileController.text = "";
//     ageController.text = "";
//     relationController.text = '';
//   }

//   void checkValidationForPatientDetails() {
//     String name = patientNameController.text;
//     String mobile = mobileController.text;
//     String age = ageController.text;
//     String relation = relationController.text;
//     if (name.isEmpty && mobile.isEmpty && age.isEmpty && relation.isEmpty) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Please enter details');
//     } else if (name.isEmpty) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Please enter name');
//     } else if (mobile.isEmpty) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Please enter mobile');
//     } else if (mobile.length != 10) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Mobile number must be 10 digits');
//     } else if (age.isEmpty) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Please enter age');
//     } else if (selectedGender == null) {
//       toastification.dismissAll();
//       customFailureToast(content: 'Please select gender');
//     }
//     // else if (relation.isEmpty && forRelation) {
//     //   toastification.dismissAll();
//     //   customFailureToast(content: 'Please enter relation');
//     // }
//     else {
//       consultDoctorApi();
//     }
//   }

//   Future<void> consultDoctorApi({bool isDelete = false}) async {
//     try {
//       isUploadPrescriptionLoading.value = true;

//       String userId = await getUserId();

//       Map<String, dynamic> map = Payloads().consultDoctorPayload(
//         isDelete: isDelete,
//         cartId: medicinesCart.value!.data!.storeVo![0].cartId ?? '',
//         storeId: "AL-R202306-001",
//         userId: userId,
//         age: isDelete ? 0 : int.parse(ageController.text),
//         gender: selectedGender ?? '',
//         name: patientNameController.text,
//         phoneNumber: mobileController.text,
//         relation: relationController.text,
//       );

//       logs("logsing form body -> ${map["body"]}");

//       await RestServices.instance.putRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           info: {"isDelete": isDelete},
//           apiType: ApiTypes.consultDoctor);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isUploadPrescriptionLoading.value = false;
//     }
//   }

//   Future<void> consultDoctorApiOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     getUserCart();
//     isUploadPrescriptionLoading.value = false;
//     cleanUpConsultForm();

//     if (!info["isDelete"]) {
//       Get.back();
//       Get.back();

//       customSuccessToast(content: "Opted for consultation");
//     } else {
//       customSuccessToast(content: "Consultation Deleted Successfully");
//     }

//     logs("cont with response -> $data");
//   }

//   Future<void> consultDoctorApiOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isUploadPrescriptionLoading.value = false;
//   }

//   /// ---- CONSULT DOCTOR API ENDS HERE ---- ///

//   /// ---- PRESCRIPTION UPLOAD API STARTS HERE ---- ///
//   Future<void> uploadPrescription() async {
//     try {
//       isUploadPrescriptionLoading.value = true;

//       String userId = await getUserId();
//       var prescriptionObjects = createPrescriptionObjects(prescriptionUrls);

//       Map<String, dynamic> map = Payloads().uploadPrescriptionPayload(
//         cartId: medicinesCart.value!.data!.storeVo![0].cartId ?? '',
//         storeId: "AL-R202306-001",
//         userId: userId,
//         prescList: prescriptionObjects,
//       );

//       await RestServices.instance.putRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           apiType: ApiTypes.uploadPrescription);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isUploadPrescriptionLoading.value = false;
//     }
//   }

//   Future<void> uploadPrescriptionOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     getUserCart();
//     isUploadPrescriptionLoading.value = false;

//     logs("cont with response -> $data");
//   }

//   Future<void> uploadPrescriptionOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isUploadPrescriptionLoading.value = false;
//   }

//   /// ---- PRESCRIPTION UPLOAD API ENDS HERE ---- ///

//   /// ---- PRESCRIPTION DELETE API STARTS HERE ---- ///
//   Future<void> deletePrescription(
//       {String endpoint = "", required int index}) async {
//     try {
//       isUploadPrescriptionLoading.value = true;

//       String prescId = medicinesCart
//               .value!.data!.storeVo![0].prescList![index].prescriptionId ??
//           "";

//       Map<String, dynamic> map = Payloads().deletePrescriptionPayload(
//         cartId: medicinesCart.value!.data!.storeVo![0].cartId ?? '',
//         prescId: prescId,
//       );

//       await RestServices.instance.deleteRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           info: {
//             "index": index,
//           },
//           apiType: ApiTypes.deletePrescription);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isUploadPrescriptionLoading.value = false;
//     }
//   }

//   Future<void> deletePrescriptionOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     isUploadPrescriptionLoading.value = false;
//     int index = info["index"];
//     prescriptionUrls.removeAt(index);
//   }

//   Future<void> deletePrescriptionOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isUploadPrescriptionLoading.value = false;
//   }

//   /// ---- PRESCRIPTION DELETE API ENDS HERE ---- ///

//   /// ---- PRESCRIPTION ALL DELETE API STARTS HERE ---- ///

//   var isDeleteAllCartLoading = false.obs;
//   Future<void> deleteAllCart({String endpoint = ""}) async {
//     try {
//       isDeleteAllCartLoading.value = true;

//       String userId = await getUserId();

//       Map<String, dynamic> map = Payloads().deleteMedicineCart(
//         cartId: medicinesCart.value!.data!.storeVo![0].cartId ?? '',
//         userId: userId,
//         storeId: "AL-R202306-001",
//       );

//       await RestServices.instance.deleteRestCall(
//           body: {},
//           endpoint: map['url'],
//           flow: this,
//           info: {},
//           apiType: ApiTypes.deleteAllCart);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isDeleteAllCartLoading.value = false;
//     }
//   }

//   Future<void> deleteAllCartOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     isDeleteAllCartLoading.value = false;
//     getUserCart();
//     GlobalController globalController = Get.put(GlobalController());
//     globalController.getAppWideCart();
//   }

//   Future<void> deleteAllCartOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isDeleteAllCartLoading.value = false;
//   }

//   /// ---- PRESCRIPTION ALL DELETE API ENDS HERE ---- ///

//   /// ---- GET USER CART API STARTS HERE ---- ///
//   Future<void> getUserCart(
//       {String endpoint = "", bool isCartApiCallNeed = false}) async {
//     try {
//       isMedicinesCartLoading.value = true;
//       String userId = await getUserId();
//       await RestServices.instance.getRestCall<CartResponseModel>(
//         fromJson: (json) {
//           return cartResponseModelFromJson(json);
//         },
//         endpoint: endpoint.isNotEmpty
//             ? endpoint
//             : Payloads().getUserCart(userId: userId),
//         flow: this,
//         info: {"isCartApiCallNeed": isCartApiCallNeed},
//         apiType: ApiTypes.getUserCart,
//       );
//     } catch (e) {
//       isMedicinesCartLoading.value = false;
//       toastification.dismissAll();
//       //customFailureToast(content: e.toString());
//     }
//   }

//   bool areAllPrescriptionsRequired(List<SingleCartItemModel> items) {
//     for (var item in items) {
//       logs("logsing in condition -> ${item.prescriptionIsRequired}");
//       if (item.prescriptionIsRequired!) {
//         return false;
//       }
//     }
//     return true;
//   }

//   Future<void> getUserCartOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     CartResponseModel cartResponse = data as CartResponseModel;
//     prescriptionUrls.value = [];
//     isPrescriptionNeeded.value = false;
//     bool isCartApiCallNeed = info["isCartApiCallNeed"];
//     // isAllAreRequiredPrescription.value = false;
//     if (cartResponse.data != null &&
//         cartResponse.data!.storeVo != null &&
//         cartResponse.data!.storeVo!.isNotEmpty &&
//         cartResponse.data!.storeVo![0].items != null &&
//         cartResponse.data!.storeVo![0].items!.isNotEmpty) {
//       medicinesCart.value = cartResponse;

//       // isAllAreRequiredPrescription.value

//       logs(
//           "logsing in condition isall are true -> ${isAllAreRequiredPrescription.value}");

//       for (var item in cartResponse.data!.storeVo![0].items!) {
//         // if (item.prescriptionIsRequired != null) {
//         logs(
//             'all check before -> ${isAllAreRequiredPrescription.value} ${item.prescriptionIsRequired}');
//         if (item.prescriptionIsRequired == false ||
//             item.prescriptionIsRequired == null) {
//           isAllAreRequiredPrescription.value = false;
//         }
//         logs(
//             'all check after -> ${isAllAreRequiredPrescription.value} ${item.prescriptionIsRequired}');
//         // }

//         if (item.prescriptionIsRequired != null &&
//             item.prescriptionIsRequired!) {
//           isPrescriptionNeeded.value = true;
//         }
//       }

//       if (cartResponse.data!.storeVo![0].prescList != null &&
//           cartResponse.data!.storeVo![0].prescList!.isNotEmpty) {
//         for (var presc in cartResponse.data!.storeVo![0].prescList!) {
//           prescriptionUrls.add(presc.imageId ?? '');
//         }

//         for (var item in cartResponse.data!.storeVo![0].items!) {
//           if (item.prescriptionIsRequired != null &&
//               item.prescriptionIsRequired!) {
//             isPrescriptionNeeded.value = true;
//           }
//         }
//       }
//     } else {
//       medicinesCart.value = null;
//     }
//     logs('log in getcartuser -> isCartchage -> ${isCartApiCallNeed}');
//     if (isCartApiCallNeed) {
//       // GlobalCO
//       GlobalController globalController = Get.find();
//       logs(
//           'log in getcartuser -> isCartchage before -> ${globalController.isCartChangeLoading.value}');
//       globalController.isCartChangeLoading.value = false;
//       logs(
//           'log in getcartuser -> isCartchage after -> ${globalController.isCartChangeLoading.value}');
//     }

//     isMedicinesCartLoading.value = false;
//   }

//   Future<void> getUserCartOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     isMedicinesCartLoading.value = false;
//   }

//   /// ---- GET USER CART API ENDS HERE ---- ///

//   /// ---- CART BEFORE CHECKOUT STARTS HERE ---- ///
//   Future<void> cartBeforeCheckout() async {
//     try {
//       isBeforeCheckoutLoading.value = true;

//       List<String> productIds = [];

//       if (medicinesCart.value != null &&
//           medicinesCart.value!.data != null &&
//           medicinesCart.value!.data!.storeVo != null &&
//           medicinesCart.value!.data!.storeVo!.isNotEmpty &&
//           medicinesCart.value!.data!.storeVo![0].items != null) {
//         // Loop over the items
//         for (var item in medicinesCart.value!.data!.storeVo![0].items!) {
//           // Add the productId to the new list
//           productIds.add(item.productId ?? "");
//         }
//       } else {
//         logs("Some of the necessary fields are null or empty");
//       }

//       String userId = await getUserId();

//       Map<String, dynamic> map = Payloads().cartBeforeCheckout(
//         rewards: false,
//         cashback: false,
//         userId: userId,
//         cartId: [
//           {
//             "storeId": "AL-R202306-001",
//             "productId": productIds,
//           }
//         ],
//       );

//       await RestServices.instance.postRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           apiType: ApiTypes.beforeCheckout);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isBeforeCheckoutLoading.value = false;
//     } catch (e) {
//       isBeforeCheckoutLoading.value = false;
//     }
//   }

//   Future<void> cartBeforeCheckoutOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     Map<String, dynamic> response = data as Map<String, dynamic>;

//     beforeCheckoutData.value =
//         beforeCheckOutModelFromJson(jsonEncode(response["data"]));

//     getRazorPayDataApi(response["data"]["toBePaid"], "", API.razorpayKey);

//     // cartAfterCheckout();
//   }

//   Future<void> cartBeforeCheckoutOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {}

//   /// ---- CART BEFORE CHECKOUT ENDS HERE ---- ///

//   /// ---- CART AFTER CHECKOUT STARTS HERE ---- ///
//   Future<void> cartAfterCheckout(
//       {required PaymentSuccessResponse response}) async {
//     try {
//       AddressController addressController = Get.put(AddressController());

//       isAfterCheckoutLoading.value = true;

//       List<String> productIds = [];

//       if (medicinesCart.value != null &&
//           medicinesCart.value!.data != null &&
//           medicinesCart.value!.data!.storeVo != null &&
//           medicinesCart.value!.data!.storeVo!.isNotEmpty &&
//           medicinesCart.value!.data!.storeVo![0].items != null) {
//         // Loop over the items
//         for (var item in medicinesCart.value!.data!.storeVo![0].items!) {
//           // Add the productId to the new list
//           productIds.add(item.productId ?? "");
//         }
//       } else {
//         logs("Some of the necessary fields are null or empty");
//       }

//       String fcm = await getFcmId();

//       Map<String, dynamic> map = Payloads().cartAfterCheckout(
//         id: beforeCheckoutData.value!.id ?? "",
//         paidAmount: beforeCheckoutData.value!.toBePaid!.toString(),
//         toBePaid: beforeCheckoutData.value!.toBePaid!,
//         transactionId: response.paymentId.toString(),
//         transactionStatus: "$response",
//         userName: await getUserName(),
//         userId: await getUserId(),
//         checkoutItems: [
//           {
//             "storeId": "AL-R202306-001",
//             "productId": productIds,
//           }
//         ],
//         delivery: {
//           "mobileNumber":
//               addressController.selectedAddress.value!.address![0].mobileNumber,
//           "name": addressController.selectedAddress.value!.address![0].name,
//           "addresslineMobileOne": addressController
//               .selectedAddress.value!.address![0].addresslineMobileOne,
//           "addresslineMobileTwo": addressController
//               .selectedAddress.value!.address![0].addresslineMobileTwo,
//           "addressLine1":
//               addressController.selectedAddress.value!.address![0].addressLine1,
//           "addressType":
//               addressController.selectedAddress.value!.address![0].addressType,
//           "latitude":
//               addressController.selectedAddress.value!.address![0].latitude,
//           "longitude":
//               addressController.selectedAddress.value!.address![0].longitude,
//           "landMark":
//               addressController.selectedAddress.value!.address![0].landMark
//         },
//         deliveryDate: "22072024",
//         expressDelivery: false,
//         expressDeliveryCharges: 0,
//         fcmToken: fcm,
//         mobileNumber: await getUserNumber(),
//         paymentMode: "online",
//         slot: "09:00 AM : 11:00 AM",
//         walletAmount: 0,
//         walletTransactionId: null,
//         barcode: "123",
//       );

//       await RestServices.instance.postRestCall(
//           body: map["body"],
//           endpoint: map['url'],
//           flow: this,
//           apiType: ApiTypes.afterCheckout);
//     } on SocketException catch (e) {
//       logs('Catch exception in sendOtp --> ${e.message}');
//       isAfterCheckoutLoading.value = false;
//     } catch (e) {
//       isAfterCheckoutLoading.value = false;
//     }
//   }

//   Future<void> cartAfterCheckoutOnSuccess<T>(
//       T? data, String apiType, Map<String, dynamic> info) async {
//     Map<String, dynamic> response = data as Map<String, dynamic>;

//     final GlobalController globalController = Get.put(GlobalController());
//     globalController.cartCountList.value = [];
//     getUserCart();
//     Get.offAll(() => OrderPlacedScreen());
//   }

//   Future<void> cartAfterCheckoutOnFailure(
//       String message, String apiType, Map<String, dynamic> info) async {
//     toastification.dismissAll();
//     customFailureToast(content: message);
//   }

//   /// ---- CART AFTER CHECKOUT ENDS HERE ---- ///

//   /// ---- RAZORPAY TRANSACTION RELATED STARTS HERE ---- ///
//   Future<dynamic> getRazorPayDataApi(num amount, String? orderId, Key) async {
//     return openCheckout(amount, orderId, Key);
//     // Get.to(() => const PaymentPlacedScreen());
//   }

//   void openCheckout(num price, String? orderId, Key) async {
//     // String userId =
//     //     await SharPreferences.getString(SharPreferences.loginId) ?? '';

//     // String storeName =
//     //     await SharPreferences.getString(SharPreferences.storeName) ?? '';

//     // final PackageInfo info = await PackageInfo.fromPlatform();

//     var options = {
//       'key': Key,
//       'amount': price * 100,
//       "id": orderId,

//       // 'order_id': selectItem['orderId'],
//       'name': 'Acintyo Retailer Buy',
//       'description': orderId,
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       // 'prefill': {'contact': '$orderId', 'email': '$orderId'},
//       'external': {
//         'wallets': ['paytm']
//       },
//       "notes": {
//         "order_id": orderId,
//         // "store_name": storeName,
//         // "store_id": userId,
//         // "app_name": info.appName,
//         // "app_id": info.packageName,
//       }
//     };

//     logs("logsing opencheckout pay now options ---> $options");

//     try {
//       razorpay.open(options);
//     } catch (e) {
//       logs('Error: $e');
//     }
//   }

//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     logs('Success Response orderId:- ${response.orderId}');
//     logs('Success Response paymentId:- ${response.paymentId}');
//     logs('Success Response signature:- ${response.signature}');
//     logs('Success Response subject:- ${response.obs.subject.stream}');

//     logs("====razor pay response $response");

//     // logs(
//     //     "logsing amount in controller ---> ${amountEnterController.value.text.trim()}");

//     cartAfterCheckout(response: response);

//     // Map<String, dynamic> bodyParams = {
//     //   "orderId": selectItem?.orderId ?? "",
//     //   "orderAmount": num.parse(amountEnterController.value.text.trim()),
//     //   "paymentId": response.paymentId.toString(),
//     //   "paidDate":
//     //       DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
//     //   "paidAmount": num.parse(amountEnterController.value.text.trim()),
//     //   "billedAmount": selectItem?.billedAmount ?? "",
//     //   "storeId": selectItem?.storeId ?? "",
//     //   "trasactionStatus": "$response",
//     //   "payerId": selectItem?.payerId ?? "",
//     //   "paymentMode": "Online",
//     //   "paymentType": "CR"
//     // };

//     /*Fluttertoast.showToast(
//         msg: "SUCCESS: " + response.paymentId!,
//         toastLength: Toast.LENGTH_SHORT); */
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     logs('Error Response: $response');
//     /* Fluttertoast.showToast(
//         msg: "ERROR: " + response.code.toString() + " - " + response.message!,
//         toastLength: Toast.LENGTH_SHORT); */
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     logs('External SDK Response: $response');
//     /* Fluttertoast.showToast(
//         msg: "EXTERNAL_WALLET: " + response.walletName!,
//         toastLength: Toast.LENGTH_SHORT); */
//   }

//   /// ---- RAZORPAY TRANSATION RELATED ENDS HERE

//   @override
//   void onFailure(String message, String apiType, Map<String, dynamic> info) {
//     if (apiType == ApiTypes.getUserCart) {
//       getUserCartOnFailure(message, apiType, info);
//     }

//     if (apiType == ApiTypes.afterCheckout) {
//       cartAfterCheckoutOnFailure(message, apiType, info);
//     }

//     if (apiType == ApiTypes.deletePrescription) {
//       deletePrescriptionOnFailure(message, apiType, info);
//     }

//     if (apiType == ApiTypes.uploadPrescription) {
//       uploadPrescriptionOnFailure(message, apiType, info);
//     }

//     if (apiType == ApiTypes.deleteAllCart) {
//       deleteAllCartOnFailure(message, apiType, info);
//     }

//     if (apiType == ApiTypes.continueWithoutPrescription) {
//       continueWithoutPrescriptionOnFailure(message, apiType, info);
//     }
//   }

//   @override
//   void onSuccess<T>(T? data, String apiType, Map<String, dynamic> info) {
//     if (apiType == ApiTypes.getUserCart) {
//       getUserCartOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.beforeCheckout) {
//       cartBeforeCheckoutOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.afterCheckout) {
//       cartAfterCheckoutOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.deleteAllCart) {
//       deleteAllCartOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.uploadPrescription) {
//       uploadPrescriptionOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.consultDoctor) {
//       consultDoctorApiOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.deletePrescription) {
//       deletePrescriptionOnSuccess(data, apiType, info);
//     }

//     if (apiType == ApiTypes.continueWithoutPrescription) {
//       continueWithoutPrescriptionOnSuccess(data, apiType, info);
//     }
//   }

//   @override
//   void onTokenExpired(
//       String apiType, String endPoint, Map<String, dynamic> info) {
//     if (apiType == ApiTypes.getUserCart) {
//       getUserCart(endpoint: endPoint);
//     }
//   }
// }
