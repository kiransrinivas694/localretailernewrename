import 'dart:io';

import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/helper/firebase_gettoken_backup.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:store_app_b2b/new_module/constant/app_api_type_constants.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/cart_diagnostictests_model.dart';

import 'package:store_app_b2b/new_module/model/cart/labtest_models/booking_test_details.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/lab_test_status_model.dart';
import 'package:store_app_b2b/new_module/model/lucid/diagnostic_userdetails_model.dart';
import 'package:store_app_b2b/new_module/model/lucid/find_location_model.dart';
import 'package:store_app_b2b/new_module/services/new_apiresponse.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service.dart';
import 'package:store_app_b2b/new_module/services/payloads.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart'
    as store_app_b2b_shar;

class CartLabtestController extends GetxController implements APiResponseFlow {
  var activeTestCartTab = 0.obs;
  var diagnosticCartData = Rx<CartDiagnosticTestsModel?>(null);
  var diagnosticCartTests = <CartTest>[].obs;
  var diagnosticHomeTests = <CartTest>[].obs;
  var isDiagnosticTestCartLoading = false.obs;

  var labTestDetails = <BasicTestStatus>[].obs;
  var islabTestDetailsLoading = false.obs;
  var islabMoreTestDetailsLoading = false.obs;
  RxInt labTestDetailsPageSize = 8.obs;
  RxInt labTestDetailsTotalPages = 0.obs;
  RxInt labTestDetailsCurrentPage = 0.obs;

  void clearLabTestDetails() {
    labTestDetails.clear();
    islabTestDetailsLoading.value = false;
    islabMoreTestDetailsLoading.value = false;
    labTestDetailsCurrentPage.value = 0;
    labTestDetailsTotalPages.value = 0;
  }

  void clearRescheduleDetails() {
    rescheduleTime.clear();
    rescheduleComment.clear();
    displayedRescheduleTime = '';
  }

  TextEditingController rescheduleTime = TextEditingController();
  TextEditingController rescheduleComment = TextEditingController();
  String displayedRescheduleTime = '';
  final ThemeController themeController = Get.find();
  bool validation() {
    if (rescheduleTime.text.isEmpty) {
      logs("${rescheduleTime.text.isEmpty}");

      customFailureToast(content: "Date of Appointment is required");
      return false;
    }
    return true;
  }

  Future<void> getDiagnosticCartData(
      {String endpoint = "", required String homeCollection}) async {
    String userId = await getUserId();

    try {
      isDiagnosticTestCartLoading.value = true;
      await RestServices.instance.getRestCall<CartDiagnosticTestsModel>(
        fromJson: (json) {
          return cartDiagnosticTestsModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getCartTests(userId: userId, hv: homeCollection),
        flow: this,
        info: {'homeCollection': homeCollection},
        apiType: ApiTypes.getCartTests,
      );
    } catch (e) {
      logs('printing error ${e.toString()}');
      isDiagnosticTestCartLoading.value = false;
    }
  }

//get test user Details//
  var isDiagnosticUSerDetailsLoading = false.obs;
  var testUserDetails = Rx<BasicUserDetails?>(null);
  Future<void> getTestUserDetails({
    required String isHomeCollection,
    String endpoint = "",
  }) async {
    String userId = await getUserId();
    testUserDetails.value = null;
    try {
      isDiagnosticUSerDetailsLoading.value = true;

      await RestServices.instance.getRestCall<DiagnosticUserDetailsModel>(
        fromJson: (json) {
          return diagnosticUserDetailsModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getDiagnosticUserDetails(
                userId: userId, isHomeCollection: isHomeCollection),
        flow: this,
        apiType: ApiTypes.getTestUserDetails,
      );
    } catch (e) {
      logs('printing error ${e.toString()}');
      isDiagnosticUSerDetailsLoading.value = false;
    }
  }

  Future<void> cancelCart(
      {required String status, required String cartId}) async {
    try {
      Map<String, dynamic> map = Payloads().cancelOrReschedulePayload(
        cartId: cartId,
        status: status,
        date: '',
        comment: '',
      );
      await RestServices.instance.putRestCall(
        body: map["body"],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.cancelCart,
      );
    } on SocketException catch (e) {
      logs('printing error ${e.toString()}');
      logs('Catch exception in submitLucidTest --> ${e.message}');
    }
  }

  int completedIndex = -1;
  RxString testId = ''.obs;
  RxBool rebook = false.obs;
  RxList<BasicLocationModel> locationList = <BasicLocationModel>[].obs;
  RxBool isRebookLoading = false.obs;
  Future<void> rebookTest(
      {String endPoint = '', required PaymentSuccessResponse response}) async {
    SampleCollectionController controller =
        Get.put(SampleCollectionController());
    GlobalMainController globalController = Get.put(GlobalMainController());

    String userId = await getUserId();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(now);
    try {
      isRebookLoading.value = true;
      String branchId = "";
      RxList<BasicLocationModel> locList =
          Get.put(SampleCollectionController()).locationList;
      for (var item in locList) {
        print('rebook branch name -> ${controller.selectedLocation}');
        if (item.branchName == controller.selectedLocation) {
          branchId = item.id ?? '';
          break;
        }
      }

      Map<String, dynamic> body = {
        "userId": userId,
        'relation': controller.selectedRelation,
        "firstName": controller.firstNameController.text,
        'lastName': controller.lastNameController.text,
        "age": int.parse(controller.ageController.text),
        "mobileNumber": controller.mobileNumberController.text,
        "city": controller.selectedCity!,
        "gender": controller.selectedGender!,
        "location": controller.selectedLocation!,
        "comments": controller.descriptionController.text,
        "address": controller.addressController.text,
        "appointmentDate": controller.appointmentController.text,
        "bookingDate": formattedDate,
        "branchId": branchId,
        "paymentId": response.paymentId.toString(),
        "paymentStatus": '$response',
        "paidAmount": (labTestDetails[completedIndex].totalPaidAmount ?? 0),
        'homeCollecitonCharges':
            labTestDetails[completedIndex].homeCollecitonCharges,
        'latitude': controller.latitude,
        'longitude': controller.longitude,
      };

      await RestServices.instance.putRestCall(
          body: body,
          endpoint:
              endPoint.isNotEmpty ? endPoint : Payloads().rebook(testId.value),
          flow: this,
          apiType: ApiTypes.rebookTest);
    } on SocketException catch (e) {
      logs('Catch exception in sendOtp --> ${e.message}');
    }
    isRebookLoading.value = false;
  }

  late Razorpay razorpay;

  @override
  Future<void> onInit() async {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logs('Success Response orderId:- ${response.orderId}');
    logs('Success Response paymentId:- ${response.paymentId}');
    logs('Success Response signature:- ${response.signature}');
    logs('Success Response subject:- ${response.obs.subject.stream}');

    rebookTest(
      response: response,
    );

    logs("====razor pay response $response");
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
      'amount': (price * 100).floor(),
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

  Future<void> rescheduleDate(
      {required String appointDate,
      required String upCommingId,
      required String comment}) async {
    try {
      Map<String, dynamic> map = Payloads().cancelOrReschedulePayload(
        cartId: upCommingId,
        status: '',
        date: appointDate,
        comment: comment,
      );
      await RestServices.instance.putRestCall(
        body: map["body"],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.rescheduleDate,
      );
    } on SocketException catch (e) {
      logs('Catch exception in submitLucidTest --> ${e.message}');
    }
  }

  var isTestDeletingLoading = false.obs;
  Future<void> deleteCartTest(
      {required String? serviceCd, required String? hv}) async {
    logs('servicecd-->$serviceCd ishc-->$hv');
    try {
      isTestDeletingLoading.value = true;
      Map<String, dynamic> map = Payloads().deleteLabTest(
          userId: await getUserId(), serviceCd: serviceCd!, hv: hv!);
      await RestServices.instance.deleteRestCall(
        body: map[" "],
        endpoint: map['url'],
        flow: this,
        info: {'homeCollection': hv},
        apiType: ApiTypes.deleteTest,
      );
    } on SocketException catch (e) {
      isTestDeletingLoading.value = false;
      logs('Catch exception in submitLucidTest --> ${e.message}');
    }
  }

  var isTestDeletingAllLoading = false.obs;
  Future<void> deleteAllCartTest(
      {required String cartId, required String isHomeCollection}) async {
    try {
      isTestDeletingAllLoading.value = true;
      Map<String, dynamic> map = Payloads()
          .deleteAllLabTest(cartId: cartId, isHomeCollection: isHomeCollection);
      await RestServices.instance.deleteRestCall(
        body: map[" "],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.deleteAllTest,
      );
    } on SocketException catch (e) {
      isTestDeletingAllLoading.value = false;
      logs('Catch exception in submitLucidTest --> ${e.message}');
    }
  }

  var bookedTestData = Rx<BookedTestData?>(null);
  RxString bookedId = ''.obs;
  RxBool isBookingDetailsLoading = false.obs;
  Future<void> getBookedTestDetailsById({String endpoint = ""}) async {
    String userId = await getUserId();
    bookedTestData.value = null;
    try {
      isBookingDetailsLoading.value = true;
      await RestServices.instance.getRestCall<BookingTestDetails>(
        fromJson: (json) {
          return bookingTestDetailsFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getBookedDetailsById(userId, bookedId.value),
        flow: this,
        apiType: ApiTypes.getBookedTestDetails,
      );
    } catch (e) {
      isBookingDetailsLoading.value = false;

      // customFailureToast(content: e.toString());
      logs("logs error -> ${e.toString()}");
    }
    update();
  }

  void getBookedTestDetailsOnSucess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    BookingTestDetails modelData = data as BookingTestDetails;

    if (modelData.data != null) {
      bookedTestData.value = modelData.data!;
    }
    isBookingDetailsLoading.value = false;
  }

  Future<void> getLucidUserUpcomingStatus({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
    required int status,
  }) async {
    String userId = await getUserId();
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    if (!loadMore) clearLabTestDetails();
    try {
      if (finalLoadMore) {
        if (labTestDetailsCurrentPage.value >= labTestDetailsTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        islabMoreTestDetailsLoading.value = true;
      } else {
        islabTestDetailsLoading.value = true;
      }

      await RestServices.instance.getRestCall<LabTestStatusModel>(
        fromJson: (json) {
          return labTestStatusModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getLucidUserUpcomingStatus(
                page: labTestDetailsCurrentPage.value,
                size: labTestDetailsPageSize.value,
                status: status,
                userId: userId,
              ),
        flow: this,
        info: {
          "loadMore": finalLoadMore,
        },
        apiType: ApiTypes.getLucidUserUpcomingStatus,
      );
    } catch (e) {
      if (finalLoadMore) {
        islabMoreTestDetailsLoading.value = false;
      } else {
        islabTestDetailsLoading.value = false;
      }
    }
  }

  void getLucidUserIdAndStatusOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) {
    LabTestStatusModel modelData = data as LabTestStatusModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        labTestDetails.addAll(modelData.data!.content!);
        islabMoreTestDetailsLoading.value = false;
      } else {
        labTestDetails.value = modelData.data!.content!;

        islabTestDetailsLoading.value = false;
      }

      labTestDetailsCurrentPage.value = modelData.data!.number! + 1;
      labTestDetailsTotalPages.value = modelData.data!.totalPages ?? 0;

      return;
    }

    if (info["loadMore"]) {
      islabMoreTestDetailsLoading.value = false;
    } else {
      islabTestDetailsLoading.value = false;
    }
  }

  void getLucidUserIdAndStatusOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    customFailureToast(content: message);
    if (info["loadMore"]) {
      islabMoreTestDetailsLoading.value = false;
    } else {
      islabTestDetailsLoading.value = false;
    }
  }

  RxBool isDiagnosticCheckOutLoading = false.obs;
  RxString patientId = "".obs;
  RxString homeCollection = "".obs;
  Future<void> postDiagnosticPayment(
      {required PaymentSuccessResponse response}) async {
    isDiagnosticCheckOutLoading.value = true;
    final GlobalMainController globalController =
        Get.put(GlobalMainController());
    try {
      String fcmToken = await getFirebaseToken();
      String id = patientId.value;
      String companyName =
          await SharPreferences.getString(SharPreferences.storeName);

      String storeNumber = await store_app_b2b_shar.SharPreferences.getString(
          SharPreferences.storeNumber);
      print(
          "storeNumber is$storeNumber-----${SharPreferences.getString(SharPreferences.phone)}");
      Map<String, dynamic> map = Payloads().postDiagnosticTestPayment(
        patientId: id,
        paymentId: response.paymentId.toString(),
        paidAmount: (diagnosticCartData.value?.data?.totalAmount ?? 0) +
            (homeCollection.value == "1"
                ? globalController.nonProfessionalCharges.value
                : 0),
        paymentStatus: "$response",
        homeCollecitonCharges: homeCollection.value == "1"
            ? globalController.nonProfessionalCharges.value
            : 0,
        fcmToken: fcmToken,
        isHomeCollection: homeCollection.value,
        companyName: companyName,
        companyReferralCode: "",
        companylogo: "",
        storeNumber: storeNumber,
      );
      logs("Response Bodey-->${map["body"]}");

      await RestServices.instance.postRestCall(
        body: map["body"],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.diagnosticCheckOut,
      );
      logs("Response Bodey-->${map["body"]}");
    } on SocketException catch (e) {
      isDiagnosticCheckOutLoading.value = false;
      logs('Catch exception in addCart --> ${e.message}');
    }
  }

  @override
  void onFailure(String message, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getCartTests) {
      isDiagnosticTestCartLoading.value = false;
    }
    if (apiType == ApiTypes.diagnosticCheckOut) {
      customFailureToast(content: "Please Fill Your Details");
      isDiagnosticCheckOutLoading.value = false;
    }
    if (apiType == ApiTypes.getTestUserDetails) {
      isDiagnosticUSerDetailsLoading.value = false;
    }

    if (apiType == ApiTypes.getBookedTestDetails) {
      isBookingDetailsLoading.value = false;
    }

    if (apiType == ApiTypes.deleteTest) {
      isTestDeletingLoading.value = false;
    }
    if (apiType == ApiTypes.deleteAllTest) {
      isTestDeletingAllLoading.value = false;
    }
    if (apiType == ApiTypes.rebookTest) {
      isRebookLoading.value = false;
    }
  }

  @override
  void onSuccess<T>(T? data, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getCartTests) {
      CartDiagnosticTestsModel modelData = data as CartDiagnosticTestsModel;
      String homeCollection = info['homeCollection'];
      if (modelData.data != null &&
          modelData.data!.lucidTest != null &&
          modelData.data!.lucidTest!.isNotEmpty) {
        diagnosticCartData.value = modelData;
        homeCollection == "0"
            ? diagnosticCartTests.value = modelData.data!.lucidTest!
            : diagnosticHomeTests.value = modelData.data!.lucidTest!;
      } else if (modelData.data != null &&
          modelData.data!.lucidTest != null &&
          modelData.data!.lucidTest!.isEmpty) {
        diagnosticCartData.value = null;
        homeCollection == "0"
            ? diagnosticCartTests.value = []
            : diagnosticHomeTests.value = [];
      } else {
        diagnosticCartData.value = null;
        homeCollection == "0"
            ? diagnosticCartTests.value = []
            : diagnosticHomeTests.value = [];
      }
      diagnosticCartData.refresh();
      diagnosticCartTests.refresh();
      diagnosticHomeTests.refresh();
      isDiagnosticTestCartLoading.value = false;
    }
    if (apiType == ApiTypes.getTestUserDetails) {
      DiagnosticUserDetailsModel modelData = data as DiagnosticUserDetailsModel;
      if (modelData.data != null) {
        testUserDetails.value = modelData.data;
      }
      isDiagnosticUSerDetailsLoading.value = false;
    }
    if (apiType == ApiTypes.diagnosticCheckOut) {
      SampleCollectionController sampleController =
          Get.put(SampleCollectionController());
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        sampleController.showSuccessDialog();
      } else {
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while adding to cart');
      }
    }
    if (apiType == ApiTypes.rebookTest) {
      SampleCollectionController controller =
          Get.put(SampleCollectionController());
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        controller.showSuccessDialog();
      } else {
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while adding to cart');
      }
    }

    if (apiType == ApiTypes.deleteTest) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        String homeCollection = info['homeCollection'];
        customSuccessToast(
            content: "your test was deleted from cart",
            header: "Deleted From cart");

        logs('request code$homeCollection ishc-->');

        if (activeTestCartTab.value == 0) {
          if (homeCollection == '0') {
            getDiagnosticCartData(homeCollection: '0');
          } else {
            getDiagnosticCartData(homeCollection: '1');
          }
        } else if (homeCollection == '0') {
          getDiagnosticCartData(homeCollection: '0');
        } else {
          getDiagnosticCartData(homeCollection: '1');
        }

        //getLucidCartData();
      } else {
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while deleting from cart');
      }
      isTestDeletingLoading.value = false;
    }

    if (apiType == ApiTypes.deleteAllTest) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        customSuccessToast(
            content: "your test was deleted Successfully",
            header: "Deleted From cart");
        if (activeTestCartTab.value == 0) {
          getDiagnosticCartData(homeCollection: "0");
          getTestUserDetails(isHomeCollection: "0");
        } else {
          getDiagnosticCartData(homeCollection: "1");
          getTestUserDetails(isHomeCollection: "1");
        }
      } else {
        logs("error in delete all");
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while deleting from cart');
      }
      isTestDeletingAllLoading.value = false;
    }

    if (apiType == ApiTypes.rescheduleDate) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        customSuccessToast(
            content: "Your Appointment is rescheduled. ",
            header: "Appointment is rescheduled ");
        getLucidUserUpcomingStatus(status: 0);
      } else {
        customFailureToast(
            content: response["message"] ??
                'Something went wrong while deleting from cart');
      }
    }

    if (apiType == ApiTypes.getLucidUserUpcomingStatus) {
      getLucidUserIdAndStatusOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.getBookedTestDetails) {
      getBookedTestDetailsOnSucess(data, apiType, info);
    }

    if (apiType == ApiTypes.cancelCart) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        logs("response body -->${response["body"]}");
        customSuccessToast(
            content: "your Appointment is Cancelled", header: "Cancel");
        getLucidUserUpcomingStatus(status: 0);
      } else {
        customFailureToast(content: "Something went wrong");
      }
    }
  }

  @override
  void onTokenExpired(
      String apiType, String endPoint, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getLucidUserUpcomingStatus) {
      getLucidUserUpcomingStatus(
        status: 0,
        endpoint: endPoint,
        retryInfo: info,
      );
    }
    if (apiType == ApiTypes.getBookedTestDetails) {
      getBookedTestDetailsById(endpoint: endPoint);
    }
    if (apiType == ApiTypes.getCartTests) {
      getDiagnosticCartData(homeCollection: "");
    }
    if (apiType == ApiTypes.getTestUserDetails) {
      getTestUserDetails(endpoint: endPoint, isHomeCollection: "");
    }
  }
}
