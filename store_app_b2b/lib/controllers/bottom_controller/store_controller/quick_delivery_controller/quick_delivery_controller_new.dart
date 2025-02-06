import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/quick_prodcut_model_new.dart';
import 'package:store_app_b2b/model/quick_product_history_model_new.dart';
import 'package:store_app_b2b/model/quick_suppliers_model_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_place_payment_screen/quick_place_payment_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class QuickDeliveryController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController quickDeliveryTabController;
  final selectStoreId = "".obs;
  final selectStoreName = "".obs;
  final orderSummerySupplierNameSelect = "".obs;
  final orderSummerySupplierIdSelect = "".obs;
  double riderRating = 0.0;

  final RxList<QuickSuppliersModel> suppliersDialogList =
      <QuickSuppliersModel>[].obs;
  QuickSuppliersModel? selectedSupplier;

  QuickProductListModel quickProductListModel = QuickProductListModel();

  QuickProductHistoryModel quickProductHistoryModel =
      QuickProductHistoryModel();
  RxList<Content> historyProductList = <Content>[].obs;

  RxBool? isShowAddProductButton;

  /// Add quick delivery product
  final productNameController = TextEditingController().obs;
  final manufacturerController = TextEditingController().obs;
  final dosageController = TextEditingController().obs;
  final qtyController = TextEditingController().obs;
  final freeQtyController = TextEditingController().obs;
  RxList<QuickItem> quickDeliveryProductList = <QuickItem>[].obs;

  var focusNode = FocusNode();

  RxBool isLoading = false.obs;

  late Razorpay placeOrderRazorpay;
  late Razorpay orderHistoryRazorpay;

  String? historyProductId;
  num? historyProductPrice;

  @override
  void onInit() {
    quickDeliveryTabController = TabController(vsync: this, length: 2);
    placeOrderRazorpay = Razorpay();
    orderHistoryRazorpay = Razorpay();

    /// Place Order
    placeOrderRazorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePlaceOrderPaymentSuccess);
    placeOrderRazorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    placeOrderRazorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    /// Order History
    orderHistoryRazorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handleOrderHistoryPaymentSuccess);
    orderHistoryRazorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    orderHistoryRazorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  changeRiderRating(double rating) {
    riderRating = rating;
    update();
  }

  compareSelectedSupplierTime() {
    isShowAddProductButton = false.obs;
    int currentHrs = DateTime.now().hour;
    int currentMin = DateTime.now().minute;
    int currentTime = int.parse(
        '${currentHrs}${(currentMin < 10) ? '0$currentMin' : currentMin}');
    int openTimeStr = int.parse(
        '${selectedSupplier!.storeOpenTime!.split(':').first}${selectedSupplier!.storeOpenTime!.split(':').last}');
    int closeTimeStr = int.parse(
        '${selectedSupplier!.storeCloseTime!.split(':').first}${selectedSupplier!.storeCloseTime!.split(':').last}');
    if (currentTime >= openTimeStr && currentTime <= closeTimeStr) {
      isShowAddProductButton!.value = true;
    } else {
      isShowAddProductButton!.value = false;
    }
  }

  Future<dynamic> getQuickSuppliersDialogListApi() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      isLoading.value = true;
      try {
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        String url =
            '${API.getQuickSuppliers}?businessType=Supplier&categoryId=${API.generalMedicineCategoryId}&userId=$userId&page=0&size=100';
        log('getQuickSuppliersDialogListApi url --->$url');
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          print('supplier response ---> ${response.body}');
          print('DateTime ${DateTime.now()}');
          suppliersDialogList.value = List<QuickSuppliersModel>.from(json
              .decode(response.body)
              .map((x) => QuickSuppliersModel.fromJson(x)));
          isLoading.value = false;
          return jsonDecode(response.body);
        } else {
          CommonSnackBar.showError('Something went wrong.');
          isLoading.value = false;
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
        CommonSnackBar.showError("Something went wrong");
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  void setSelectedStoreValue(
      {required String storeName, required String storeId}) {
    if (storeName.isNotEmpty && storeId.isNotEmpty) {
      selectStoreName.value = storeName;
      selectStoreId.value = storeId;
      selectedSupplier = suppliersDialogList
          .firstWhere((element) => element.storeName == storeName);
      compareSelectedSupplierTime();
    }
    update();
  }

  addQuickDeliveryProductOnTap(BuildContext context) {
    if (productNameController.value.text.isEmpty) {
      CommonSnackBar.showToast('Please enter product name', context,
          showTickMark: false, width: double.infinity);
    } else if (qtyController.value.text.isEmpty) {
      CommonSnackBar.showToast('Please enter quantity', context,
          showTickMark: false, width: 200);
    } else if (freeQtyController.value.text.isEmpty) {
      CommonSnackBar.showToast('Please enter free quantity', context,
          showTickMark: false, width: 230);
    } else {
      if (quickDeliveryProductList.isEmpty) {
        addFirstQuickDeliveryProductAPI(context);
      } else if (quickDeliveryProductList.length < 10) {
        addMoreQuickDeliveryProductAPI(context);
      } else {
        CommonSnackBar.showToast('You can add only 10 products', context,
            width: double.infinity, showTickMark: false);
      }
    }
  }

  clearValue() {
    productNameController.value.clear();
    manufacturerController.value.clear();
    qtyController.value.clear();
    dosageController.value.clear();
    freeQtyController.value.clear();
  }

  addFirstQuickDeliveryProductAPI(BuildContext context) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      String userName =
          await SharPreferences.getString(SharPreferences.storeName) ?? "";
      try {
        isLoading.value = true;
        Map<String, dynamic> productMap = {
          "userId": userId,
          "userName": userName,
          "storeId": selectStoreId.value,
          "storeName": selectStoreName.value,
          "items": [
            {
              "productName": productNameController.value.text,
              "manufacturer": manufacturerController.value.text,
              "quantity": qtyController.value.text,
              "freeQuantity": freeQtyController.value.text,
              "dosage": dosageController.value.text,
              "totalQuantity": int.parse(qtyController.value.text) +
                  int.parse(freeQtyController.value.text)
            }
          ]
        };
        String url = '${API.addFirstQuickProductToCart}';
        log('addFirstQuickDeliveryProductAPI url ---> $url');
        log('productMap ---> $productMap');
        final token = await SharPreferences.getToken();

        final headers = {
          'accept': '*/*',
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.post(Uri.parse(url),
            body: jsonEncode(productMap), headers: headers);

        print(
            "printing respose in addFirstQuickDeliveryProductAPI ---> $response");
        print(
            "printing respose body in addFirstQuickDeliveryProductAPI ---> ${response.body}");

        if (response.statusCode == 200) {
          quickProductListModel = quickProductListModelFromJson(response.body);
          quickDeliveryProductList.add(quickProductListModel.quickItems.first);
          getQuickCartDetailsAPI();
          clearValue();
          FocusScope.of(context).requestFocus(focusNode);
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    update();
  }

  addMoreQuickDeliveryProductAPI(BuildContext context) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> productMap = {
          "productName": productNameController.value.text,
          "manufacturer": manufacturerController.value.text,
          "quantity": qtyController.value.text,
          "freeQuantity": freeQtyController.value.text,
          "dosage": dosageController.value.text,
          "totalQuantity": int.parse(qtyController.value.text) +
              int.parse(freeQtyController.value.text)
        };
        String url =
            '${API.addMoreQuickProductToCart}/${quickProductListModel.id ?? ''}/items';
        log('addMoreQuickDeliveryProductAPI url ---> $url');
        log("addMoreQuickDeliveryProductAPI bodyMap ---> ${jsonEncode(productMap)}");

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': '*/*',
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        final response = await http.put(Uri.parse(url),
            body: jsonEncode(productMap), headers: headers);
        if (response.statusCode == 200) {
          getQuickCartDetailsAPI();
          clearValue();
          FocusScope.of(context).requestFocus(focusNode);
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    update();
  }

  getQuickCartDetailsAPI() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      isLoading.value = true;
      try {
        String url =
            '${API.getQuickCartDetails}/${quickProductListModel.id ?? ''}';
        log('getQuickCartDetailsAPI url --->$url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          quickProductListModel = quickProductListModelFromJson(response.body);
          quickDeliveryProductList.value = quickProductListModel.quickItems;
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    update();
  }

  deleteCartAPI() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      isLoading.value = true;
      try {
        String url = '${API.deleteQuickCart}/${quickProductListModel.id ?? ''}';

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': "*/*",
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.delete(Uri.parse(url), headers: headers);
        log('deleteCartAPI url ---> $url');
        if (response.statusCode == 200) {
          quickProductListModel = QuickProductListModel();
          quickDeliveryProductList.clear();
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    update();
  }

  deleteCartItemAPI(String itemId) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;
        String url =
            '${API.deleteQuickCart}/${quickProductListModel.id ?? ''}/items/$itemId';

        final token = await SharPreferences.getToken();

        final headers = {"accept": "*/*"};

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.delete(Uri.parse(url), headers: headers);
        log('deleteCartItemAPI url ---> $url');
        if (response.statusCode == 200) {
          getQuickCartDetailsAPI();
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    update();
  }

  getProductHistory(
      {required int page,
      required int size,
      bool isLoad = true,
      bool clearList = false}) async {
    //clearList is added because...when we confirm order delivered we need to refresh the list...so i added parameter clearList.

    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      if (isLoad) {
        isLoading.value = true;
      }

      if (clearList) {
        historyProductList.value = [];
      }
      try {
        String url =
            '${API.getQuickProductHistory}/$userId?page=$page&size=$size';
        log('getProductHistory url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          quickProductHistoryModel =
              quickProductHistoryModelFromJson(response.body);

          historyProductList.addAll(quickProductHistoryModel.content);
          log('historyProductList length ---> ${historyProductList.length}');
          if (isLoad) {
            isLoading.value = false;
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      if (isLoad) {
        isLoading.value = false;
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<void> quickProductCheckOut(
      {required String productId,
      required String transId,
      required String paidAmount}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      try {
        String url = '${API.quickProductCheckOut}/$productId/checkOut';
        Map<String, dynamic> body = {
          "transId": transId,
          "paidDelivaryAmount": paidAmount,
          "transStatus": "sucess"
        };

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': "*/*",
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        log('quick delivery check out url ,  body , headers ---> $url ${body} $headers');

        final response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        log('quickProductCheckOut url ---> $url');
        log('quickProductCheckOut response ---> ${response.body}');
        if (response.statusCode == 200) {
          selectedSupplier = null;
          selectStoreName.value = "";
          selectStoreId.value = "";
          historyProductId = null;
          historyProductPrice = null;
          Get.to(() => QuickPaymentPlacedScreen(
                message: 'Your Payment has been Received',
              ));
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<void> historyProductCheckOut(
      {required String productId,
      required String transId,
      required String paidAmount}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      try {
        String url = '${API.quickProductCheckOut}/$productId/payment';
        Map<String, dynamic> body = {
          "transId": transId,
          "paidAmount": paidAmount,
          "transStatus": "sucess"
        };

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': "*/*",
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        log('historyProductCheckOut url ---> $url');
        log('historyProductCheckOut body ---> $body');
        log('response ---> ${response.body}');
        if (response.statusCode == 200) {
          Map<String, dynamic> resMap = jsonDecode(response.body);
          if (resMap.containsKey("status") && resMap["status"] == true) {
            Get.to(() => const QuickPaymentPlacedScreen(
                  message: 'Your Payment has been Received',
                  showStatusButton: false,
                ));
          } else {
            CommonSnackBar.showError('Something went wrong.');
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<void> orderConfirmDelivery(
      {required cartId, required int page, required int size}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      isLoading.value = true;
      Get.back();
      try {
        String url =
            '${API.quickProductCheckOut}/$cartId/confirmDelivery/Y/rating/${riderRating.toString()}';
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        final response = await http.put(
          Uri.parse(url),
          headers: headers,
        );
        log('orderConfirmDelivery url ---> $url');

        log('orderConfirmDelivery response ---> ${response.body}');
        if (response.statusCode == 200) {
          getProductHistory(page: 0, size: size, clearList: true);
          CommonSnackBar.showError('${jsonDecode(response.body)["message"]}');
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
      update();
      // } else if (!Get.isDialogOpen!) {
      //   Get.dialog(const LoginDialog());
      // }
    }
  }

  void openBuyProductCheckout() async {
    var options = {
      'key': ApiConfig.razorpayKey,
      'amount': (quickProductListModel.totalPayble!) * 100,
      "id": quickProductListModel.id,
      'name': 'Acintyo Retailer Buy',
      // 'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      placeOrderRazorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void openPayHistoryProductCheckout(num price, String productId) async {
    historyProductId = productId;
    historyProductPrice = price;
    var options = {
      'key': ApiConfig.razorpayKey,
      'amount': price * 100,
      "id": productId,
      'name': 'Acintyo Retailer Buy',
      // 'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      orderHistoryRazorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePlaceOrderPaymentSuccess(
      PaymentSuccessResponse response) async {
    print('Success Response orderId:- ${response.orderId}');
    print('Success Response paymentId:- ${response.paymentId}');
    print('Success Response signature:- ${response.signature}');
    print('Success Response subject:- ${response.obs.subject.stream}');

    print("====razor pay response $response");
    quickProductCheckOut(
        productId: quickProductListModel.id ?? '',
        transId: response.paymentId ?? '',
        paidAmount: '${quickProductListModel.totalPayble}');
  }

  Future<void> _handleOrderHistoryPaymentSuccess(
      PaymentSuccessResponse response) async {
    print('Success Response orderId:- ${response.orderId}');
    print('Success Response paymentId:- ${response.paymentId}');
    print('Success Response signature:- ${response.signature}');
    print('Success Response subject:- ${response.obs.subject.stream}');

    print("====razor pay response $response");
    historyProductCheckOut(
        productId: historyProductId ?? '',
        transId: response.paymentId ?? '',
        paidAmount: '${historyProductPrice ?? 0}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
  }
}
