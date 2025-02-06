import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/favourite_item_model_new.dart';
import 'package:store_app_b2b/model/product_details_model_new.dart';
import 'package:store_app_b2b/model/search_products_model_new.dart';
import 'package:store_app_b2b/model/search_supplier_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class NrBuyController extends GetxController with GetTickerProviderStateMixin {
  final isLoading = false.obs;
  final isSupplierTabLoading = false.obs;
  final isAddToFavLoading = false.obs;
  final isSaveFavLoading = false.obs;
  String partialOrLaterDelivery = "";
  late TabController productTabController;
  late TabController unlistedTabController;
  List<RxNum> finalQTYList = [];
  List<RxNum> freeQTYList = [];
  List<RxNum> buyQTYList = [];
  List<RxInt> qtyList = [];
  RxList<TextEditingController> qtyTextControllerList =
      <TextEditingController>[].obs;
  // RxList<FocusNode> qtyTextControllerFocusNodeList = <FocusNode>[].obs;
  final searchController = TextEditingController().obs;

  final suppliersSelect = "".obs;
  final suppliersId = "".obs;
  var userId = "".obs;
  var categoryId = "".obs;

  ///  by Product
  final isAddCartLoading = false.obs;
  final RxList<SearchProducts> byProductList = <SearchProducts>[].obs;
  final getFavoriteNameList = [].obs;
  final favouriteNameController = TextEditingController().obs;

  final qtyAddToCartController = TextEditingController().obs;
  final supplierQtyAddToCartController = TextEditingController().obs;
  final supplierFreeQtyAddToCartController = TextEditingController().obs;
  final freeAddToCart = 0.obs;

  final favouriteSelect = "".obs;

  // Find More Product
  final isFindLoading = false.obs;
  final isButtonFindLoading = false.obs;
  final ImagePicker imagePicker = ImagePicker();
  final uploadImage = "".obs;
  final productNameController = TextEditingController().obs;
  final manufacturerController = TextEditingController().obs;
  final mrpController = TextEditingController().obs;
  final commentController = TextEditingController().obs;
  final qtyController = TextEditingController().obs;
  final freeQtyController = TextEditingController().obs;
  final suppliersFindId = "".obs;
  final suppliersFindNameSelect = "".obs;
  final unlistedProductList = [].obs;
  RxList<TextEditingController> updateFreeQtyControllerList =
      <TextEditingController>[].obs;
  RxList<TextEditingController> updateQtyControllerList =
      <TextEditingController>[].obs;
  List<RxBool> isUpdateFreeQTY = <RxBool>[].obs;
  List<RxBool> isUpdateQTY = <RxBool>[].obs;

  ///Favourite
  final RxList<FavouriteItemModel> getFavouriteList =
      <FavouriteItemModel>[].obs;

  /// Suppliers
  final searchSupplierController = TextEditingController().obs;
  final suppliersDialogList = [].obs;
  final suppliersList = [].obs;
  final RxList<SearchSupplier> bySuppliersList = <SearchSupplier>[].obs;

  @override
  void onInit() {
    productTabController = TabController(vsync: this, length: 2);
    unlistedTabController = TabController(vsync: this, length: 2);
    getUserId();

    super.onInit();
  }

  @override
  void onClose() {
    productTabController.dispose();
    super.onClose();
  }

  Future<dynamic> getUserId() async {
    userId.value =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    categoryId.value =
        await SharPreferences.getString(SharPreferences.storeCategoryId) ?? "";
  }

  /// Buy
  Future<dynamic> getBuyByProductDataApi(String search,
      {bool showLoading = true,
      required String categoryId,
      String? storeIdMain}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    update();
    try {
      String storeId =
          await SharPreferences.getString(SharPreferences.supplierId) ?? '';
      // "ACIN100066";
      // String categoryId =
      //     await SharPreferences.getString(SharPreferences.storeCategoryId) ??
      '';
      String url =
          // 'http://137.59.201.34:8090/api-product/product/b2b/text/m/supplier/category/3d1592c3-60fa-4f5e-9229-2ba36bcca886';
          // '${API.getBuyProduct}/$search/supplier/category/$categoryId';
          '${API.getBuyProduct}/store/${storeIdMain ?? storeId}/category/$categoryId?search=$search';
      logs('getBuyProduct Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200 &&
          (search == searchController.value.text ||
              (searchController.value.text == "" && search == "a"))) {
        log('ByProduct Response ---> ${response.body} ');

        byProductList.value = searchProductsFromJson(response.body);
        qtyList = List.generate(byProductList.length, (index) => 0.obs);
        qtyTextControllerList = RxList.generate(
            byProductList.length, (index) => TextEditingController());
        // qtyTextControllerFocusNodeList =
        //     RxList.generate(byProductList.length, (index) => FocusNode());
        freeQTYList = byProductList.map((element) {
          return RxNum(0.0);
        }).toList();

        finalQTYList = byProductList
            .map((element) => RxNum(element.finalQty ?? 0.0))
            .toList();
        buyQTYList = byProductList.map((element) => RxNum(0)).toList();
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    if (showLoading) {
      isLoading.value = false;
    }
    update();
    print(freeQTYList);
  }

  Future<dynamic> getBuyBySuppliersDataApi(
      {String? search,
      String? supplierId,
      bool showLoading = false,
      String categoryId = ""}) async {
    if (showLoading) {
      isSupplierTabLoading.value = true;
    }

    update();
    try {
      String? categoryIdFinal = categoryId == ""
          ? await SharPreferences.getString(SharPreferences.storeCategoryId) ??
              ""
          : categoryId;
      String url =
          '${API.getBuySupplier}/$search/supplier/$supplierId/category/$categoryIdFinal';
      //http://137.59.201.34:8085/api-product/product/b2b/text/m/supplier/AL-S202308-768/category/3d1592c3-60fa-4f5e-9229-2ba36bcca886
      logs('supplierId --> $supplierId');
      logs('supplierId url --> $url');
      print('supplierId url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print(
          "printing search text from controller ---> ${searchController.value.text}");

      if (response.statusCode == 200 &&
          (search == searchSupplierController.value.text ||
              (searchSupplierController.value.text == "" && search == "a"))) {
        log('Response --> ${response.body}');
        bySuppliersList.value = searchSupplierFromJson(response.body);
        qtyList = List.generate(bySuppliersList.length, (index) => 0.obs);
        qtyTextControllerList = RxList.generate(
            bySuppliersList.length, (index) => TextEditingController());
        freeQTYList = bySuppliersList.map((element) => RxNum(0.0)).toList();
        finalQTYList = bySuppliersList
            .map((element) => RxNum(element.finalQuantity ?? 0.0))
            .toList();
        buyQTYList = bySuppliersList.map((element) => RxNum(0)).toList();
        // } else {
        //   CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    // isLoading.value = false;
    isSupplierTabLoading.value = false;
    update();
  }

  Future<dynamic> checkProductQuantityAvailable(
      {required storeId, required skuId}) async {
    if (userId.value.isNotEmpty) {
      try {
        String url =
            "${API.checkProductQuantityAvailable}/store/${storeId}/sku/$skuId";
        logs('checkProductQuantityAvailable Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        print(response.body);

        if (response.statusCode == 200) {
          print(
              ">>>>>checkProductQuantityAvailable response>>>${jsonDecode(response.body)}");

          return jsonDecode(response.body);
        } else {
          isAddCartLoading.value = false;
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
  }

  Future<dynamic> checkProductAvailableInCart(
      {required String cartId,
      required String skuId,
      required String storeId}) async {
    if (userId.value.isNotEmpty) {
      try {
        // isAddCartLoading.value = true;

        String url =
            "${API.nrCheckProductAvailableInCart}/store/${storeId}/user/${userId.value}/skuId/$skuId/check";
        logs('checkProductAvailableInCart Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        print(response.body);

        if (response.statusCode == 200) {
          print(
              ">>>>>checkProductAvailableInCart response>>>${jsonDecode(response.body)}");
          // isAddCartLoading.value = false;
          // return response.body;
          return jsonDecode(response.body);
        } else {
          isAddCartLoading.value = false;
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
  }

  Future<dynamic> getAddToCartApi(var bodyMap, String? storeId) async {
    logs('add to cart Url --> ${userId.value}');
    if (userId.value.isNotEmpty) {
      try {
        isAddCartLoading.value = true;
        String url = "${API.getNrAddToCart}/${userId.value}/store/$storeId";
        logs('add to cart Url --> $url ${jsonEncode(bodyMap)}');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(bodyMap));
        print("response body cart post data${response}");

        if (response.statusCode == 200) {
          logs("cart response code${response.body}");
          print(">>>>>add to cart>>>${jsonDecode(response.body)}");
          isAddCartLoading.value = false;
          return response.body;
        } else {
          isAddCartLoading.value = false;
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
    isAddCartLoading.value = false;
  }

  Future<dynamic> getSchemeQty(
      {required String schemeId,
      required String schemeName,
      required num addBuyQty,
      required num addFreeQty,
      required num finalQty,
      required int quantity,
      required int index}) async {
    try {
      print(API.getSchemeQty);
      Map<String, dynamic> jsonMap = {
        "schemeId": schemeId,
        "schemeName": schemeName,
        "buyQuantity": addBuyQty,
        "freeQuantity": addFreeQty,
        "finalQuantity": finalQty,
        "quantity": quantity
      };
      logs('getSchemeQty map ---> $jsonMap');
      final response = await http.post(Uri.parse(API.getSchemeQty),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization':
            //     await SharPreferences.getString(SharPreferences.accessToken) ??
            //         ""
          },
          body: jsonEncode(jsonMap));
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        freeQTYList[index].value = data['freeQuantity'];
        finalQTYList[index].value = data['finalQuantity'];
        buyQTYList[index].value = data['buyQuantity'];
        log("buyQuantity ---> ${data["buyQuantity"]}");
        update();
        return data;
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

  Future<dynamic> getAddFavoriteApi(Map<String, dynamic> bodyMap) async {
    try {
      isSaveFavLoading.value = true;
      logs('Url --> ${API.getAddFavorite}');
      logs('bodyMap --> ${jsonEncode(bodyMap)}');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(API.getAddFavorite),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print(response.body);
      isSaveFavLoading.value = false;
      if (response.statusCode == 200) {
        print("Fav product response >>>>>>>>${jsonDecode(response.body)}");
        isSaveFavLoading.value = false;
        return response.body;
      } else {
        isSaveFavLoading.value = false;
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

  Future<dynamic> getDeleteFavoriteApi(String? id) async {
    try {
      isSaveFavLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http
          .delete(Uri.parse("${API.getDeleteFavourite}/$id"), headers: headers);
      print(response.body);
      isSaveFavLoading.value = false;
      if (response.statusCode == 200) {
        print(">>>>>>>>${jsonDecode(response.body)}");
        isSaveFavLoading.value = false;
        return response.body;
      } else {
        isSaveFavLoading.value = false;
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

  Future<dynamic> getDeleteFavoriteItemApi(
      String? favListId, String? itemId) async {
    try {
      isSaveFavLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.delete(
          Uri.parse(
              "${API.getDeleteFavouriteListItem}/$favListId/item/$itemId"),
          headers: headers);
      print(response.body);
      isSaveFavLoading.value = false;
      if (response.statusCode == 200) {
        print("getDeleteFavoriteItemApi >>>>>>>>${jsonDecode(response.body)}");
        isSaveFavLoading.value = false;
        getFavouriteProductDataApi();
        return response.body;
      } else {
        isSaveFavLoading.value = false;
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

  Future<dynamic> getQtyUpdateFavoriteItemApi(
      Map<String, dynamic> bodyMap) async {
    try {
      print(API.getUpdateQtyFavoriteItem);

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(Uri.parse(API.getUpdateQtyFavoriteItem),
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

  Future<dynamic> getAddFavListToCart(String favListId) async {
    try {
      logs(
          'Mov fav list to cart Url ---> ${API.getAddFavListToCart}$favListId');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
          Uri.parse('${API.getAddFavListToCart}$favListId'),
          headers: headers);
      logs(response.body);
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

  Future<dynamic> getFavoriteNameDataApi() async {
    if (userId.value.isNotEmpty) {
      try {
        isAddToFavLoading.value = true;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getFavoriteNameList}/${userId.value}"),
            headers: headers);
        print(response.body);
        isAddToFavLoading.value = false;
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          getFavoriteNameList.value = jsonDecode(response.body);
          isAddToFavLoading.value = false;
          return jsonDecode(response.body);
        } else {
          isAddToFavLoading.value = false;
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

  Future<void> selectImage(ImageSource imageSource) async {
    final XFile? image = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);
    if (image != null) {
      Get.back();
      uploadImage.value = await uploadProfilePhoto(image.path);
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

      if (responseMap.isNotEmpty) {
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

  Future<dynamic> getProductSubmitApi(Map<String, dynamic> bodyMap) async {
    try {
      isButtonFindLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(Uri.parse(API.getAddFindProduct),
          headers: headers, body: jsonEncode(bodyMap));
      print(response.body);
      if (response.statusCode == 200) {
        print(">>>>>>>>${jsonDecode(response.body)}");
        isButtonFindLoading.value = false;
        return response.body;
      } else {
        isButtonFindLoading.value = false;
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

  Future<dynamic> getProductQtyUpdateApi(Map<String, dynamic> bodyMap) async {
    try {
      isButtonFindLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(Uri.parse(API.getAddFindProduct),
          headers: headers, body: jsonEncode(bodyMap));
      print(response.body);
      if (response.statusCode == 200) {
        print(">>>>>>>>${jsonDecode(response.body)}");
        isButtonFindLoading.value = false;
        return response.body;
      } else {
        isButtonFindLoading.value = false;
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

  Future<dynamic> getProductFindApiList() async {
    if (userId.isNotEmpty) {
      try {
        isFindLoading.value = true;
        final url = "${API.getUnverifiedProducts}/${userId.value}";
        print('getProductFindApiList url ---> $url');
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          isFindLoading.value = false;
          unlistedProductList.value = jsonDecode(response.body);
          updateFreeQtyControllerList.value = unlistedProductList
              .map((element) =>
                  TextEditingController(text: '${element['freeQuantity']}'))
              .toList();
          updateQtyControllerList.value = unlistedProductList
              .map((element) =>
                  TextEditingController(text: '${element['quantity']}'))
              .toList();
          isUpdateFreeQTY =
              unlistedProductList.map((element) => false.obs).toList();
          isUpdateQTY =
              unlistedProductList.map((element) => false.obs).toList();
          return jsonDecode(response.body);
        } else {
          isFindLoading.value = false;
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

  Future<dynamic> getUnlistedPlacedProductList() async {
    if (userId.isNotEmpty) {
      try {
        isFindLoading.value = true;
        final url = "${API.getUnListedProductsPlaced}/${userId.value}/placed";
        print('getProductFindApiList url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        unlistedProductList.clear();
        updateFreeQtyControllerList.clear();
        updateQtyControllerList.clear();
        isUpdateFreeQTY.clear();
        isUpdateQTY.clear();
        print(response.body);
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          isFindLoading.value = false;
          unlistedProductList.value = jsonDecode(response.body);
          updateFreeQtyControllerList.value = unlistedProductList
              .map((element) =>
                  TextEditingController(text: '${element['freeQuantity']}'))
              .toList();
          updateQtyControllerList.value = unlistedProductList
              .map((element) =>
                  TextEditingController(text: '${element['quantity']}'))
              .toList();
          isUpdateFreeQTY =
              unlistedProductList.map((element) => false.obs).toList();
          isUpdateQTY =
              unlistedProductList.map((element) => false.obs).toList();
          return jsonDecode(response.body);
        } else {
          isFindLoading.value = false;
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

  Future<dynamic> getDeleteFindProductApi(String? id) async {
    if (userId.value.isNotEmpty) {
      try {
        isSaveFavLoading.value = true;

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
        isSaveFavLoading.value = false;
        if (response.statusCode == 200) {
          print(">>>>>>>>${jsonDecode(response.body)}");
          var data = jsonDecode(response.body);
          isSaveFavLoading.value = false;
          return jsonDecode(response.body);
        } else {
          isSaveFavLoading.value = false;
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

  /// Favourite
  Future<dynamic> getFavouriteProductDataApi() async {
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getFavoriteList}/${userId.value}"),
            headers: headers);
        logs('fav url --> ${API.getFavoriteList}/${userId.value}');
        isLoading.value = false;
        print(">>>>>>>>${jsonDecode(response.body)}");
        if (response.statusCode == 200) {
          getFavouriteList.value = favouriteItemModelFromJson(response.body);

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
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  /// Suppliers
  Future<dynamic> getSuppliersDialogListApi() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;

        logs('getSuppliersDialogListApi --> ${API.linkedSuppliers}/$userId');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse("${API.linkedSuppliers}/$userId"),
          headers: headers,
        );
        print(response.body);
        isLoading.value = false;
        if (response.statusCode == 200) {
          suppliersDialogList.value = jsonDecode(response.body);
          print(">>>>>>>>${jsonDecode(response.body).length}");
          isLoading.value = false;
          return jsonDecode(response.body);
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

  Future<dynamic> getSuppliersDataListApi(
      {String? search, String? supplierId}) async {
    try {
      suppliersList.clear();
      print(
          "${API.getBuySupplier}/$search/supplier/$supplierId/category/${categoryId.value}");
      isLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
          Uri.parse(
              "${API.getBuySupplier}/$search/supplier/$supplierId/category/${categoryId.value}"),
          headers: headers);

      isLoading.value = false;
      if (response.statusCode == 200) {
        suppliersList.value = jsonDecode(response.body);
        print(">>>>>>>>${jsonDecode(response.body)}");

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

  Future<void> onSupplierQuantityChange(
      String value, String? schemeName) async {
    try {
      isLoading.value = true;
      update();
      final String url = API.getSchemeQtyCal;
      Map<String, dynamic> bodyMap = {
        'schemName': schemeName ?? '',
        'buyQuatity': value,
        'freeQuanity': '0'
      };
      logs('Url --> $url');
      logs('bodyMap --> $bodyMap');
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(bodyMap),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        supplierQtyAddToCartController.value.text =
            responseMap['buyQuatity'].toString();
        supplierFreeQtyAddToCartController.value.text =
            responseMap['freeQuanity'].toString();
      } else {
        logs('response.statusCode --> ${response.statusCode}');
        logs('response.statusCode --> ${response.body}');
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      logs('Catch exception in onSupplierQuantityChange --> ${e.message}');
      CommonSnackBar.showError(e.message);
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message);
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    isLoading.value = false;
    update();
  }

  Future<ProductDetailsModel?> getProductDetailsApi(
      {required String productId, required String storeId}) async {
    try {
      isLoading.value = true;
      String url = "${API.getProductDetails}/$productId/store/$storeId";
      logs('product details url ---> $url');
      final response = await http.get(
        Uri.parse("$url"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      logs('product details response ---> ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);

        ProductDetailsModel detailsModel = ProductDetailsModel(
            manufacturer: responseMap['manufacturer'],
            price: responseMap['price'][storeId]['price'],
            quantity: responseMap['price'][storeId]['quantity'],
            discount: responseMap['price'][storeId]['discount'],
            pricePtr: responseMap['price'][storeId]['ptr'],
            priceIsActive: responseMap['price'][storeId]['isActive'],
            priceMrp: responseMap['price'][storeId]['mrp'],
            discountType: responseMap['price'][storeId]['discountType'],
            startDate: responseMap['price'][storeId]['startDate'],
            endDate: responseMap['price'][storeId]['endDate'],
            storeName: responseMap['price'][storeId]['storeName'],
            id: responseMap['id'],
            productName: responseMap['productName'],
            specs: responseMap['specs'],
            productDescription: responseMap['productDescription'],
            category: responseMap['category'],
            categoryId: responseMap['categoryId'],
            subCategoryId: responseMap['subCategoryId'],
            subCategory: responseMap['subCategory'],
            note: responseMap['note'],
            benefits: responseMap['benefits'],
            imageIds: List<ImageId>.from(
                responseMap['imageIds'].map((x) => ImageId.fromJson(x))),
            alternative: responseMap['alternative'],
            weight: responseMap['weight'],
            dimentions: responseMap['dimentions'],
            brandName: responseMap['brandName'],
            brandId: responseMap['brandId'],
            isActive: responseMap['isActive'],
            isEnabled: responseMap['isEnabled'],
            sideEffects: responseMap['sideEffects'],
            howToUse: responseMap['howToUse'],
            productSearch: responseMap['productSearch'],
            isApproved: responseMap['isApproved'],
            medicneType: responseMap['medicneType'],
            tabletsPerStrip: responseMap['tabletsPerStrip'],
            createdAt: (responseMap["createdAt"] == null)
                ? null
                : DateTime.parse(responseMap["createdAt"]),
            updatedAt: (responseMap["updatedAt"] == null)
                ? null
                : DateTime.parse(responseMap["updatedAt"]),
            createdBy: responseMap['createdBy'],
            updatedBy: responseMap['updatedBy'],
            sku: responseMap['sku'],
            mrp: responseMap['price'][storeId]['mrp'],
            ptr: responseMap['ptr'],
            brandNameLogo: responseMap['brandNameLogo'],
            cgst: responseMap['cgst'],
            finalPrice: responseMap['finalPrice'],
            gst: responseMap['gst'],
            hsn: responseMap['hsn'],
            margProductId: responseMap['margProductId'],
            medicalProudct: responseMap['medicalProudct'],
            packingType: responseMap['packingType'],
            parentProductId: responseMap['parentProductId'],
            prescriptionIsRequired: responseMap['prescriptionIsRequired'],
            productSearchWithoutSpaces:
                responseMap['productSearchWithoutSpaces'],
            proudctRequestBy: responseMap['proudctRequestBy'],
            proudctThumbnail: responseMap['proudctThumbnail'],
            rid: responseMap['rid'],
            sgst: responseMap['sgst'],
            priceWithGst: responseMap["priceWithGst"],
            stockAvailable: responseMap["stockAvailable"]);
        logs('product details --> ${detailsModel.toJson()}');
        //productDetails.value = jsonDecode(response.body);
        isLoading.value = false;
        update();
        return detailsModel;
      } else {
        isLoading.value = false;
        update();
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      logs('Catch exception in onSupplierQuantityChange --> ${e.message}');
      CommonSnackBar.showError(e.message);
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message);
    }
    isLoading.value = false;
    update();
    return null;
  }
}
