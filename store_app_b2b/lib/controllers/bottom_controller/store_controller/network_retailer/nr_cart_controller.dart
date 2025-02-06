import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/cart_grb_model/cart_grb_model.dart';
import 'package:store_app_b2b/model/cart_model.dart';
import 'package:store_app_b2b/model/grb_cart_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class NrCartController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final isLoading = false.obs;
  final isChecked = false.obs;

  var userId = "".obs;

  final unverifiedProductList = [].obs;
  final isPlaceOrderLoading = false.obs;

  //Awareness Banners
  int currentBanner = 0;
  int previousCurrentBanner = 0;

  setAwarenessBanner() {
    currentBanner = currentBanner + 1;
    previousCurrentBanner = currentBanner - 1;
    update();
  }

  CartListModel? cartListModel;
  List<CartListModel> laterDeliveryData = [];
  bool isLaterDeliveryLoading = false;

  final productTotal = 0.obs;
  final grbTotalLength = 0.obs;
  String cartId = "";
  final itemViewTotal = 0.obs;
  RxInt verifyProductLength = 0.obs;
  List<RxDouble> finalQTYList = [];
  List<RxDouble> freeQTYList = [];
  List<RxDouble> buyQTYList = [];
  List<TextEditingController> qtyTextControllerList = [];
  List<RxBool> isEditableQTYList = [];

  @override
  Future<void> onInit() async {
    // tabController = TabController(vsync: this, length: 4);
    // super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onDispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<dynamic> getUserId() async {
    userId.value =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    logs('cart User id ---> ${userId.value}');
  }

  // Later Delivery
  Future<dynamic> getLaterDeliveryDataApi() async {
    if (userId.value.isNotEmpty) {
      try {
        // isLoading.value = true;
        isLaterDeliveryLoading = true;
        laterDeliveryData.clear();
        update();
        logs(
            'getLaterDeliveryDataApi message --> ${"${API.getLaterDeliveryData}/${userId.value}"}');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getLaterDeliveryData}/${userId.value}"),
            headers: headers);
        logs('getLaterDeliveryDataApi response ---> ${response.body}');
        if (response.statusCode == 200) {
          // paymentRequestList.value = jsonDecode(response.body);
          print("Verify product >>>>>>>>${jsonDecode(response.body)}");
          dynamic responseData = jsonDecode(response.body);

          print("prinitng laterDeliveryData responseData -> ${responseData}");

          final List<dynamic> jsonList = json.decode(response.body);

          // Convert each item in the JSON list into a CartListModel object
          laterDeliveryData = fullCartListModelFromJson(response.body);

          // responseData.map((e) {
          //   // laterDeliveryData.add(cartListModelFromJson(responseData[e]));
          //   print("printing in loop --> ${responseData[e]["userId"]} $e");
          // });

          print(
              "printing length in laterDeliveryData call -> ${laterDeliveryData.length}");

          // log('cartListModel ---> ${laterDeliveryData!.toJson()}');
          // productTotal.value = 0;
          // verifyProductLength.value = cartListModel!.storeVo.length;

          // cartListModel?.storeVo.forEach((element) {
          // productTotal.value += element.items.length;
          // });
          update();

          logs('Product total --> $productTotal');

          // var data = jsonDecode(response.body);
          // if (data['storeVo'].length != 0) {}
          // for (int i = 0; i < data.length; i++) {
          //   print("product length>>>>>>>>>>${data["storeVo"][i]['items'].length}");
          //   productTotal.value = data["storeVo"][i]['items'].length + productTotal.value;
          // }
          // isLoading.value = false;
        } else {
          // isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isLaterDeliveryLoading = false;
      update();
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog(
    //     message: "getVerifiedProductDataApi()",
    //   ));
    // }
  }

  /// Verified Product

  Future<dynamic> getVerifiedProductDataApi() async {
    logs('cart User id after cart called ${userId.value}');
    if (userId.value.isNotEmpty) {
      try {
        isLoading.value = true;
        logs(
            'getVerifiedProductDataApi message --> ${"${API.getNrVerfiedProduct}/${userId.value}"}');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getNrVerfiedProduct}/${userId.value}"),
            headers: headers);
        logs('getVerifiedProduct response ---> ${response.body}');
        if (response.statusCode == 200) {
          // paymentRequestList.value = jsonDecode(response.body);
          print("Verify product >>>>>>>>${jsonDecode(response.body)}");
          cartListModel = cartListModelFromJson(response.body);
          log('cartListModel ---> ${cartListModel!.toJson()}');
          productTotal.value = 0;
          verifyProductLength.value = cartListModel!.storeVo.length;

          if (cartListModel?.storeVo.length != 0) {
            cartId = cartListModel?.storeVo[0].cartId ?? "";
          } else {
            cartId = "";
          }

          cartListModel?.storeVo.forEach((element) {
            productTotal.value += element.items.length;
          });
          update();

          logs('Product total --> $productTotal');

          // var data = jsonDecode(response.body);
          // if (data['storeVo'].length != 0) {}
          // for (int i = 0; i < data.length; i++) {
          //   print("product length>>>>>>>>>>${data["storeVo"][i]['items'].length}");
          //   productTotal.value = data["storeVo"][i]['items'].length + productTotal.value;
          // }
          isLoading.value = false;
        } else {
          isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isLoading.value = false;
      update();
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog(
    //     message: "getVerifiedProductDataApi()",
    //   ));
    // }
  }

  Future<dynamic> getQtyPlushAddToCartApi(Map<String, dynamic> bodyMap) async {
    try {
      print("getQtyPlushAddToCartApi -> ${API.getNrUpdateQtyAddToCart}");

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(Uri.parse(API.getNrUpdateQtyAddToCart),
          headers: headers, body: jsonEncode(bodyMap));
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
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
  }

  Future<dynamic> getPlaceOrderApi(Map<String, dynamic> bodyMap) async {
    try {
      isPlaceOrderLoading.value = true;
      print('getPlaceOrder --> ${API.getNrPlaceOrder}');
      print('bodyMap --> $bodyMap');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(API.getNrPlaceOrder),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print(response.body);
      if (response.statusCode == 200) {
        isPlaceOrderLoading.value = false;
        return jsonDecode(response.body);
      } else {
        CommonSnackBar.showError('Something went wrong.');
        isPlaceOrderLoading.value = false;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      print('error check from  on Error-> ${e.toString()}');
      debugPrint(e.toString());
    }
    isPlaceOrderLoading.value = false;
  }

  Future<dynamic> getConfirmOrderApi(Map<String, dynamic> bodyMap) async {
    try {
      // isPlaceOrderLoading.value = true;
      print("printing checkout url ---> ${API.getNrConfirmOrder}");
      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(API.getNrConfirmOrder),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print(
          "printing checkout response ---> ${response.body} ${response.statusCode}");
      if (response.statusCode == 200) {
        isPlaceOrderLoading.value = false;
        print(">>>???????????${response.body}");
        return response.body;
      } else {
        CommonSnackBar.showError('Something went wrong.');
        isPlaceOrderLoading.value = false;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    isPlaceOrderLoading.value = false;
  }

  void totalPriceGet(List<Item> item) {
    itemViewTotal.value = 0;
    num currentValue = 0;
    for (int i = 0; i < item.length; i++) {
      log("logging each item buyQuantity value");
      log('${item[i].buyQuantity}');

      print((item[i].price ?? 0) * item[i].buyQuantity);
      currentValue = num.parse(
          (((item[i].price ?? 0) * item[i].buyQuantity) + currentValue)
              .toString());
      // .round();
    }

    itemViewTotal.value = num.parse(currentValue.toStringAsFixed(2)).round();
    log("logging after update to know order total value - ${itemViewTotal}");
    log("logging after update to know current order total value - ${itemViewTotal}");
  }

  /// UnVerified Product
  Future<dynamic> getProductFindApiList() async {
    if (userId.value.isNotEmpty) {
      try {
        isLoading.value = true;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse("${API.getUnverifiedProducts}/${userId.value}"),
          headers: headers,
        );
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          isLoading.value = false;
          unverifiedProductList.value = jsonDecode(response.body);
          update();
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
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog(
    //     message: "getProductFindApiList()",
    //   ));
    // }
    isLoading.value = false;
  }

  Future<dynamic> getSchemeQty({
    required String schemeId,
    required String schemeName,
    required num addBuyQty,
    required num addFreeQty,
    required num addFinalQty,
    required num quantity,
    required int index,
  }) async {
    try {
      print(API.getSchemeQty);
      Map<String, dynamic> jsonMap = {
        "schemeId": schemeId,
        "schemeName": schemeName,
        "buyQuantity": addBuyQty,
        "freeQuantity": addFreeQty,
        "finalQuantity": addFinalQty,
        "quantity": quantity,
      };
      logs('getSchemeQty map ---> $jsonMap');
      final response = await http.post(Uri.parse(API.getSchemeQty),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            //Authorization':
            //    '  await SharPreferences.getString(SharPreferences.accessToken) ??
            //         ""
          },
          body: jsonEncode(jsonMap));
      logs('Get scheme url --> ${API.getSchemeQty}');
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        freeQTYList[index].value = data['freeQuantity'];
        finalQTYList[index].value = data['finalQuantity'];
        buyQTYList[index].value = data['buyQuantity'];
        return response.body;
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
  }

  Future<dynamic> getStoreWiseDeleteProductApi({required int index}) async {
    if (userId.value.isNotEmpty) {
      try {
        String? cartId = cartListModel!.storeVo[index].cartId;
        String? storeId = cartListModel!.storeVo[index].storeId;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        logs(
            'cartId --> ${cartId}\n storeId --> ${storeId} \n userId --> $userId');
        final response = await http.delete(
            Uri.parse(
                "${API.getNrStoreWiseDeleteProduct}/$cartId/store/$storeId/user/${userId.value}"),
            headers: headers);
        logs(
            'Url --> ${API.getNrStoreWiseDeleteProduct}/$cartId/store/$storeId/user/${userId.value}');
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          var data = jsonDecode(response.body);
          getVerifiedProductDataApi();
          return jsonDecode(response.body);
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
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog(
        message: "getStoreWiseDeleteProductApi",
      ));
    }

    update();
  }

  Future<dynamic> getSingleItemDeleteFromCartApi(
      {required String storeId,
      required String skuId,
      required String cartId,
      required int index}) async {
    if (userId.value.isNotEmpty) {
      try {
        logs(
            'cartId --> ${cartId}\n storeId --> ${storeId} \n userId --> $userId');
        // String url = '${API.getSingleItemDeleteFromCart}/$cartId/store/$storeId/user/${userId.value}/skuId/$skuId';
        // logs('url ---> $url');
        logs(
            'getSingleItemDeleteFromCartApi url ---> ${API.getNrSingleItemDeleteFromCart}/$cartId/store/$storeId/user/${userId.value}/skuId/$skuId');
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.delete(
            Uri.parse(
                "${API.getNrSingleItemDeleteFromCart}/$cartId/store/$storeId/user/${userId.value}/skuId/$skuId"),
            headers: headers);
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          var data = jsonDecode(response.body);
          getVerifiedProductDataApi().then((value) {
            qtyTextControllerList.removeAt(index);

            freeQTYList.removeAt(index);
            buyQTYList.removeAt(index);
            finalQTYList.removeAt(index);
            isEditableQTYList.removeAt(index);
            update();
          });
          // qtyTextControllerList.removeAt(index);

          // // update();

          // freeQTYList.removeAt(index);
          // buyQTYList.removeAt(index);
          // finalQTYList.removeAt(index);
          // isEditableQTYList.removeAt(index);
          // update();
          // Get.back();
          return jsonDecode(response.body);
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
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog(
        message: "getSingleItemDeleteFromCartApi",
      ));
    }
  }

  Future<dynamic> getUnverifiedPlaceOrder() async {
    try {
      logs('url ---> ${API.getUnverifiedPlaceOrder}/$userId');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(
          Uri.parse('${API.getUnverifiedPlaceOrder}/$userId'),
          headers: headers);
      logs('delete response ---> ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
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
  }

  Future<dynamic> getDeleteFindProductApi(String? id) async {
    if (userId.value.isNotEmpty) {
      try {
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.delete(
            Uri.parse(
                "${API.getDeleteFindProduct}/userId/${userId.value}/id/$id"),
            headers: headers);
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          var data = jsonDecode(response.body);
          return jsonDecode(response.body);
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
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog(
        message: "getDeleteFindProductApi",
      ));
    }
  }

//   //GRB Cart Belongings Starts From Here
//   final isGrbLoading = false.obs;
//   CartGrbModel? grbCartDetails;

//   TextEditingController buyQuantityDialogController = TextEditingController();
//   TextEditingController freeQuantityDialogController = TextEditingController();

//   final grbUpdateLoading = false.obs;
//   num totalGrbAmount = 0;

// // http://devapi.thelocal.co.in/b2b/api-oms/grbOrders/user/AL-R202401-169/recenet/store/AL-S202309-756
//   Future<dynamic> getGRBCart() async {
//     if (userId.value.isNotEmpty) {
//       try {
//         totalGrbAmount = 0;
//         isGrbLoading.value = true;
//         grbCartDetails = null;
//         update();
//         var url = "${API.getCartGrb}/${userId.value}";
//         logs('getGRBCart url --> $url');
//         final response = await http.get(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             // 'Authorization': await SharPreferences.getString(SharPreferences.accessToken) ?? ""
//           },
//         );
//         logs('getGRBCart response ---> ${response.body}');
//         if (response.statusCode == 200) {
//           // paymentRequestList.value = jsonDecode(response.body);
//           print("getGRBCart product >>>>>>>>${jsonDecode(response.body)}");
//           grbCartDetails = cartGrbModelFromJson(response.body);

//           grbTotalLength.value = 0;
//           if (grbCartDetails != null &&
//               grbCartDetails!.storeVo != null &&
//               grbCartDetails!.storeVo!.isNotEmpty &&
//               grbCartDetails!.storeVo![0].items != null)
//             for (GrbItemModel i in grbCartDetails!.storeVo![0].items!) {
//               log('grbCartModel ${i.netRate} ---> ${i.buyQuantity}');
//               grbTotalLength.value += 1;
//               if (i.netRate != null && i.buyQuantity != null) {
//                 totalGrbAmount += i.netRate! * i.buyQuantity!;
//               }
//             }
//           log('grbCartModel ${totalGrbAmount} ---> ${cartListModel!.toJson()}');
//           // productTotal.value = 0;
//           // verifyProductLength.value = cartListModel!.storeVo.length;

//           // if (cartListModel?.storeVo.length != 0) {
//           //   cartId = cartListModel?.storeVo[0].cartId ?? "";
//           // } else {
//           //   cartId = "";
//           // }

//           // cartListModel?.storeVo.forEach((element) {
//           //   productTotal.value += element.items.length;
//           // });
//           update();

//           logs('Product total --> $productTotal');

//           isGrbLoading.value = false;
//         } else {
//           isGrbLoading.value = false;
//           CommonSnackBar.showError('Something went wrong.');
//         }
//       } on TimeoutException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       } on SocketException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       }
//       isGrbLoading.value = false;
//       update();
//     }
//     // } else if (!Get.isDialogOpen!) {
//     //   Get.dialog(const LoginDialog(
//     //     message: "getVerifiedProductDataApi()",
//     //   ));
//     // }
//   }

//   //edit grb cart
//   Future<dynamic> addGrbOrderToCart(var bodyMap) async {
//     print("printing grb order body map -> $bodyMap");

//     // if (userId.value.isNotEmpty) {
//     try {
//       grbUpdateLoading.value = true;
//       String url = "${API.addGrbOrderToCart}";
//       logs('addGrbOrderToCart Url --> $url');
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'Authorization': await SharPreferences.getString(SharPreferences.accessToken) ?? ""
//         },
//         body: jsonEncode(bodyMap),
//       );
//       print(response.body);

//       if (response.statusCode == 200) {
//         print(">>>>>add to cart>>>${jsonDecode(response.body)}");
//         grbUpdateLoading.value = false;
//         Map<String, dynamic> responseMap = jsonDecode(response.body);
//         if (responseMap["status"]) {
//           return responseMap["status"];
//         }

//         CommonSnackBar.showError(responseMap["message"]);
//         return responseMap["status"];
//       } else {
//         grbUpdateLoading.value = false;
//         CommonSnackBar.showError('Something went wrong.');
//       }
//     } on TimeoutException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on SocketException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on Error catch (e) {
//       debugPrint(e.toString());
//     }

//     grbUpdateLoading.value = false;

//     // } else if (!Get.isDialogOpen!) {
//     //   Get.dialog(const LoginDialog());
//     // }
//   }

//   //delete grb single item
//   bool isSingleItemGrbDeleteLoading = false;
//   Future<dynamic> singleItemDeleteFromGrbCart({
//     required String storeId,
//     required String itemId,
//     required String orderId,
//     required String cartId,
//   }) async {
//     if (userId.value.isNotEmpty) {
//       try {
//         isSingleItemGrbDeleteLoading = true;
//         update();
//         logs(
//             'cartId --> ${cartId}\n storeId --> ${storeId} \n userId --> $userId');
//         // String url = '${API.getSingleItemDeleteFromCart}/$cartId/store/$storeId/user/${userId.value}/skuId/$skuId';
//         // logs('url ---> $url');
//         var url =
//             "${API.singleItemDeleteFromGrbCart}/$cartId/store/$storeId/order/${orderId}/itemId/$itemId";
//         logs('singleItemDeleteFromGrbCart url ---> ${url}');
//         final response = await http.delete(Uri.parse(url));
//         print(response.body);
//         if (response.statusCode == 200) {
//           print(">>>>>>>>${jsonDecode(response.body)}");
//           var data = jsonDecode(response.body);
//           // getVerifiedProductDataApi().then((value) {
//           //   qtyTextControllerList.removeAt(index);

//           //   freeQTYList.removeAt(index);
//           //   buyQTYList.removeAt(index);
//           //   finalQTYList.removeAt(index);
//           //   isEditableQTYList.removeAt(index);
//           //   update();
//           // });
//           // qtyTextControllerList.removeAt(index);

//           // // update();

//           // freeQTYList.removeAt(index);
//           // buyQTYList.removeAt(index);
//           // finalQTYList.removeAt(index);
//           // isEditableQTYList.removeAt(index);
//           // update();
//           // Get.back();
//           // return jsonDecode(response.body);
//           getGRBCart();
//         } else {
//           CommonSnackBar.showError('Something went wrong.');
//         }
//       } on TimeoutException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       } on SocketException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       } on Error catch (e) {
//         debugPrint(e.toString());
//       }

//       isSingleItemGrbDeleteLoading = false;
//       update();
//     } else if (!Get.isDialogOpen!) {
//       Get.dialog(const LoginDialog(
//         message: "getSingleItemDeleteFromCartApi",
//       ));
//     }
//   }

//   //delete grb single item
//   bool isDeleteGrbLoading = false;

//   Future<void> deleteGrbCart({
//     required String cartId,
//   }) async {
//     if (userId.value.isNotEmpty) {
//       try {
//         // String url = '${API.getSingleItemDeleteFromCart}/$cartId/store/$storeId/user/${userId.value}/skuId/$skuId';
//         // logs('url ---> $url');
//         isDeleteGrbLoading = true;
//         update();
//         var url = "${API.singleItemDeleteFromGrbCart}/$cartId";
//         logs('singleItemDeleteFromGrbCart url ---> ${url}');
//         final response = await http.delete(Uri.parse(url));
//         print(response.body);
//         if (response.statusCode == 200) {
//           print(">>>>>>>>${jsonDecode(response.body)}");
//           var data = jsonDecode(response.body);
//           getGRBCart();
//         } else {
//           CommonSnackBar.showError('Something went wrong.');
//         }
//       } on TimeoutException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       } on SocketException catch (e) {
//         CommonSnackBar.showError(e.message.toString());
//       } on Error catch (e) {
//         debugPrint(e.toString());
//       }

//       isDeleteGrbLoading = false;
//       update();
//     } else if (!Get.isDialogOpen!) {
//       Get.dialog(const LoginDialog(
//         message: "getSingleItemDeleteFromCartApi",
//       ));
//     }
//   }

//   //generate grb
//   Future<dynamic> generateGrb() async {
//     try {
//       // isPlaceOrderLoading.value = true;

//       String userLoginId =
//           await SharPreferences.getString(SharPreferences.loginId) ?? "";

//       String supplierId =
//           await SharPreferences.getString(SharPreferences.supplierId) ?? "";
//       print(
//           "printing checkout url ---> ${API.generateGrb}/$userLoginId/store/$supplierId}");
//       final response = await http.put(
//         Uri.parse("${API.generateGrb}/$userLoginId/store/$supplierId"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'Authorization':
//           //     await SharPreferences.getString(SharPreferences.accessToken) ??
//           //         ""
//         },
//       );
//       print("printing checkout response ---> ${response.body}");
//       if (response.statusCode == 200) {
//         print(">>>???????????${response.body}");
//         Map<String, dynamic> responseMap = jsonDecode(response.body);
//         if (responseMap["status"]) {
//           getGRBCart();
//           Get.to(() => OrderPlacedScreen(
//                 needPop: true,
//                 message: "GRB Order has been placed",
//               ));
//           return responseMap["status"];
//         }

//         CommonSnackBar.showError(responseMap["message"]);
//         return responseMap["status"];
//       } else {
//         CommonSnackBar.showError('Something went wrong.');
//       }
//     } on TimeoutException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on SocketException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on Error catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   //grb checkout - current
//   bool grbCheckoutLoading = false;

//   Future<dynamic> checkoutGrb() async {
//     print('is null -> ${grbCartDetails == null}');
//     if (grbCartDetails == null) {
//       return;
//     }

//     grbCheckoutLoading = true;
//     update();

//     try {
//       // isPlaceOrderLoading.value = true;

//       // String userLoginId =
//       //     await SharPreferences.getString(SharPreferences.loginId) ?? "";

//       // String supplierId =
//       //     await SharPreferences.getString(SharPreferences.supplierId) ?? "";

//       String url = API.checkoutGrb;

//       Map<String, dynamic> tempBody = {
//         "id": grbCartDetails!.id,
//         "totalPrice": grbCartDetails!.totalPrice,
//         "totalDeliveryCharges": grbCartDetails!.totalDeliveryCharges,
//         "serviceCharges": grbCartDetails!.serviceCharges,
//         "taxOnServiceCharges": grbCartDetails!.taxOnServiceCharges,
//         "userId": grbCartDetails!.userId,
//         "userName": grbCartDetails!.userName,
//         "storeVo": [
//           {
//             "storeId": grbCartDetails!.storeVo![0].storeId,
//             "storeName": grbCartDetails!.storeVo![0].storeName,
//             "address": grbCartDetails!.storeVo![0].address,
//             "prescUploaded": grbCartDetails!.storeVo![0].prescUploaded,
//             "continueWithoutPrescItems":
//                 grbCartDetails!.storeVo![0].continueWithoutPrescItems,
//             "totalPriceByStore": grbCartDetails!.storeVo![0].totalPriceByStore,
//             "deliveryChargesByStore":
//                 grbCartDetails!.storeVo![0].deliveryChargesByStore,
//             "items": grbCartDetails!.storeVo![0].items!
//                 .map((e) => {
//                       "orderId": e.orderId,
//                       "invoiceId": e.invoiceId,
//                       "itemId": e.itemId,
//                       "productId": e.productId,
//                       "productName": e.productName,
//                       "manufacturer": e.manufacturer,
//                       "freeQuantity": e.freeQuantity,
//                       "buyQuantity": e.buyQuantity,
//                       "finalPtr": e.finalPtr,
//                       "mrp": e.mrp,
//                       "skuCode": e.skuCode,
//                       "hsn": e.hsn,
//                       "expiryDate": e.expiryDate,
//                       "checkOutStatus": e.checkOutStatus,
//                       "batchNumber": e.batchNumber,
//                       "returnReason": e.returnReason,
//                       "discount": e.discount,
//                       "sgstPercent": e.sgstPercent,
//                       "cgstPercent": e.cgstPercent,
//                       "orderedQuantity": e.orderedQuantity,
//                       "lineAmount": e.lineAmount,
//                       'netRate': e.netRate,
//                       'skuId': e.skuId,
//                       'schemeName': e.schemeName,
//                       'schemId': e.schemeId,
//                       "confirmQuantity": e.confrimQuantity,
//                     })
//                 .toList(),
//             "consultDoctor": grbCartDetails!.storeVo![0].consultDoctor,
//             "existingCustomer": grbCartDetails!.storeVo![0].existingCustomer
//           }
//         ]
//       };

//       print("printing checkout url ---> $url");
//       log("printing checkout body ---> ${cartGrbModelToJson(grbCartDetails!)}");

//       final response = await http.post(Uri.parse(url),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             // 'Authorization':
//             //     await SharPreferences.getString(SharPreferences.accessToken) ??
//             //         ""
//           },
//           body: jsonEncode(tempBody));
//       print("printing checkout response ---> ${response.body}");
//       if (response.statusCode == 200) {
//         print(">>>???????????${response.body}");
//         Map<String, dynamic> responseMap = jsonDecode(response.body);
//         log('succes');
//         if (responseMap["status"] == true) {
//           getGRBCart();
//           Get.to(() => OrderPlacedScreen(
//                 // needPop: true,
//                 message: "GRB Order has been placed",
//               ));
//           grbCheckoutLoading = false;
//           update();
//           return responseMap["status"];
//         }

//         CommonSnackBar.showError(responseMap["data"] ?? 'Something went wrong');
//         grbCheckoutLoading = false;
//         update();
//         return responseMap["status"];
//       } else {
//         CommonSnackBar.showError('Something went wrong.');
//       }
//     } on TimeoutException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on SocketException catch (e) {
//       CommonSnackBar.showError(e.message.toString());
//     } on Error catch (e) {
//       debugPrint(e.toString());
//     }

//     grbCheckoutLoading = false;
//     update();
//   }
}
