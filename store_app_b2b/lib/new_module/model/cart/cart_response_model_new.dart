import 'dart:convert';

CartResponseModel cartResponseModelFromJson(String str) =>
    CartResponseModel.fromJson(json.decode(str));

String cartResponseModelToJson(CartResponseModel data) =>
    json.encode(data.toJson());

class CartResponseModel {
  bool? status;
  String? message;
  CartDataObject? data;

  CartResponseModel({this.status, this.message, this.data});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CartDataObject.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class CartDataObject {
  num? totalPrice;
  num? totalDelivaryCharges;
  num? serviceCharges;
  num? taxOnServiceCharges;
  String? userId;
  List<StoreVo>? storeVo;

  CartDataObject({
    this.totalPrice,
    this.totalDelivaryCharges,
    this.serviceCharges,
    this.taxOnServiceCharges,
    this.userId,
    this.storeVo,
  });

  factory CartDataObject.fromJson(Map<String, dynamic> json) => CartDataObject(
        totalPrice: json['totalPrice'] as num?,
        totalDelivaryCharges: json['totalDelivaryCharges'] as num?,
        serviceCharges: json['serviceCharges'] as num?,
        taxOnServiceCharges: json['taxOnServiceCharges'] as num?,
        userId: json['userId'] as String?,
        storeVo: (json['storeVo'] as List<dynamic>?)
            ?.map((e) => StoreVo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'totalPrice': totalPrice,
        'totalDelivaryCharges': totalDelivaryCharges,
        'serviceCharges': serviceCharges,
        'taxOnServiceCharges': taxOnServiceCharges,
        'userId': userId,
        'storeVo': storeVo?.map((e) => e.toJson()).toList(),
      };
}

class StoreVo {
  String? storeId;
  String? cartId;
  String? storeName;
  String? address;
  bool? prescUploaded;
  bool? continueWithoutPrescItems;
  num? totalPriceByStore;
  num? delivaryChargesByStore;
  List<PresctiptionImage>? prescList;
  List<SingleCartItemModel>? items;
  bool? existingCustomer;
  bool? consultDoctor;

  StoreVo({
    this.storeId,
    this.cartId,
    this.storeName,
    this.address,
    this.prescUploaded,
    this.continueWithoutPrescItems,
    this.totalPriceByStore,
    this.delivaryChargesByStore,
    this.items,
    this.existingCustomer,
    this.consultDoctor,
    this.prescList,
  });

  factory StoreVo.fromJson(Map<String, dynamic> json) => StoreVo(
        storeId: json['storeId'] as String?,
        cartId: json['cartId'] as String?,
        storeName: json['storeName'] as String?,
        address: json['address'] as String?,
        prescUploaded: json['prescUploaded'] as bool?,
        continueWithoutPrescItems: json['continueWithoutPrescItems'] as bool?,
        totalPriceByStore: json['totalPriceByStore'] as num?,
        delivaryChargesByStore: json['delivaryChargesByStore'] as num?,
        items: (json['items'] as List<dynamic>?)
            ?.map(
                (e) => SingleCartItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        existingCustomer: json['existingCustomer'] as bool?,
        consultDoctor: json['consultDoctor'] as bool?,
        prescList: (json['prescList'] as List<dynamic>?)
            ?.map((e) => PresctiptionImage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'cartId': cartId,
        'storeName': storeName,
        'address': address,
        'prescUploaded': prescUploaded,
        'continueWithoutPrescItems': continueWithoutPrescItems,
        'totalPriceByStore': totalPriceByStore,
        'delivaryChargesByStore': delivaryChargesByStore,
        'items': items?.map((e) => e.toJson()).toList(),
        'existingCustomer': existingCustomer,
        'prescList': prescList?.map((e) => e.toJson()).toList(),
        'consultDoctor': consultDoctor,
      };
}

class PresctiptionImage {
  String? prescriptionId;
  String? imageId;

  PresctiptionImage({
    this.prescriptionId,
    this.imageId,
  });

  factory PresctiptionImage.fromJson(Map<String, dynamic> json) =>
      PresctiptionImage(
        imageId: json['imageId'] as String?,
        prescriptionId: json['prescriptionId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'prescriptionId': prescriptionId,
        'imageId': imageId,
      };
}

class SingleCartItemModel {
  String? userId;
  String? cartId;
  String? storeId;
  String? skuId;
  String? productId;
  String? productName;
  num? quantity;
  String? measure;
  num? price;
  String? productUrl;
  dynamic storeName;
  String? tabletsPerStrip;
  String? categoryName;
  num? mrp;
  dynamic discountType;
  dynamic discount;
  bool? prescriptionIsRequired;

  SingleCartItemModel({
    this.userId,
    this.cartId,
    this.storeId,
    this.skuId,
    this.productId,
    this.productName,
    this.quantity,
    this.measure,
    this.price,
    this.productUrl,
    this.storeName,
    this.tabletsPerStrip,
    this.categoryName,
    this.mrp,
    this.discountType,
    this.discount,
    this.prescriptionIsRequired,
  });

  factory SingleCartItemModel.fromJson(Map<String, dynamic> json) =>
      SingleCartItemModel(
        userId: json['userId'] as String?,
        cartId: json['cartId'] as String?,
        storeId: json['storeId'] as String?,
        skuId: json['skuId'] as String?,
        productId: json['productId'] as String?,
        productName: json['productName'] as String?,
        quantity: json['quantity'] as num?,
        measure: json['measure'] as String?,
        price: json['price'] as num?,
        productUrl: json['productUrl'] as String?,
        storeName: json['storeName'] as dynamic,
        tabletsPerStrip: json['tabletsPerStrip'] as String?,
        categoryName: json['categoryName'] as String?,
        mrp: json['mrp'] as num?,
        discountType: json['discountType'] as dynamic,
        discount: json['discount'] as dynamic,
        prescriptionIsRequired: json['prescriptionIsRequired'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'cartId': cartId,
        'storeId': storeId,
        'skuId': skuId,
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'measure': measure,
        'price': price,
        'productUrl': productUrl,
        'storeName': storeName,
        'tabletsPerStrip': tabletsPerStrip,
        'categoryName': categoryName,
        'mrp': mrp,
        'discountType': discountType,
        'discount': discount,
        'prescriptionIsRequired': prescriptionIsRequired,
      };
}
