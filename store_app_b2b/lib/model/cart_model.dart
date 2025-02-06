import 'dart:convert';

List<CartListModel> fullCartListModelFromJson(String str) =>
    List<CartListModel>.from(
        json.decode(str).map((x) => CartListModel.fromJson(x)));

CartListModel cartListModelFromJson(String str) =>
    CartListModel.fromJson(json.decode(str));

String cartListModelToJson(CartListModel data) => json.encode(data.toJson());

class CartListModel {
  num? totalPrice;
  num? totalPriceWithGst;
  num? totalDelivaryCharges;
  num? serviceCharges;
  num? taxOnServiceCharges;
  String? userId;
  List<StoreVo> storeVo;

  CartListModel({
    this.totalPrice,
    this.totalDelivaryCharges,
    this.totalPriceWithGst,
    this.serviceCharges,
    this.taxOnServiceCharges,
    this.userId,
    this.storeVo = const <StoreVo>[],
  });

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        totalPrice: json["totalPrice"],
        totalPriceWithGst: json["totalPriceWithGst"],
        totalDelivaryCharges: json["totalDelivaryCharges"]?.toDouble(),
        serviceCharges: json["serviceCharges"]?.toDouble(),
        taxOnServiceCharges: json["taxOnServiceCharges"]?.toDouble(),
        userId: json["userId"],
        storeVo: json["storeVo"] == null
            ? []
            : List<StoreVo>.from(
                json["storeVo"]!.map((x) => StoreVo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalPrice": totalPrice,
        "totalPriceWithGst": totalPriceWithGst,
        "totalDelivaryCharges": totalDelivaryCharges,
        "serviceCharges": serviceCharges,
        "taxOnServiceCharges": taxOnServiceCharges,
        "userId": userId,
        "storeVo": List<dynamic>.from(storeVo.map((x) => x.toJson())),
      };
}

class StoreVo {
  String? storeId;
  String? cartId;
  String? address;
  dynamic storeName;
  bool continueWithoutPrescItems;
  num? totalPriceByStore;
  num? totalPriceByStoreWithGst;
  num? delivaryChargesByStore;
  List<Item> items;
  List<Item> billedItems;
  List<Item> inProgressItems;
  List<Item> billingInProgressItems;
  bool existingCustomer;
  bool prescUploaded;
  bool consultDoctor;

  StoreVo({
    this.storeId,
    this.cartId,
    this.address,
    this.storeName,
    this.continueWithoutPrescItems = false,
    this.totalPriceByStore,
    this.totalPriceByStoreWithGst,
    this.delivaryChargesByStore,
    this.items = const <Item>[],
    this.billedItems = const <Item>[],
    this.inProgressItems = const <Item>[],
    this.billingInProgressItems = const <Item>[],
    this.existingCustomer = false,
    this.prescUploaded = false,
    this.consultDoctor = false,
  });

  factory StoreVo.fromJson(Map<String, dynamic> json) => StoreVo(
        storeId: json["storeId"],
        cartId: json["cartId"],
        address: json["address"],
        storeName: json["storeName"],
        totalPriceByStoreWithGst: json["totalPriceByStoreWithGst"],
        continueWithoutPrescItems: json["continueWithoutPrescItems"],
        totalPriceByStore: json["totalPriceByStore"],
        delivaryChargesByStore: json["delivaryChargesByStore"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        billedItems: json.containsKey("billedItems")
            ? json["billedItems"] == null
                ? []
                : List<Item>.from(
                    json["billedItems"]!.map((x) => Item.fromJson(x)))
            : [],
        inProgressItems: json.containsKey("inProgressItems")
            ? json["inProgressItems"] == null
                ? []
                : List<Item>.from(
                    json["inProgressItems"]!.map((x) => Item.fromJson(x)))
            : [],
        billingInProgressItems: json.containsKey("billingInProgressItems")
            ? json["billingInProgressItems"] == null
                ? []
                : List<Item>.from(json["billingInProgressItems"]!
                    .map((x) => Item.fromJson(x)))
            : [],
        existingCustomer: json["existingCustomer"],
        prescUploaded: json["prescUploaded"],
        consultDoctor: json["consultDoctor"],
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "cartId": cartId,
        "address": address,
        "storeName": storeName,
        "totalPriceByStoreWithGst": totalPriceByStoreWithGst,
        "continueWithoutPrescItems": continueWithoutPrescItems,
        "totalPriceByStore": totalPriceByStore,
        "delivaryChargesByStore": delivaryChargesByStore,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "existingCustomer": existingCustomer,
        "prescUploaded": prescUploaded,
        "consultDoctor": consultDoctor,
      };
}

class Item {
  dynamic userId;
  dynamic cartId;
  dynamic storeId;
  String? skuId;
  String? productId;
  String? productName;
  DateTime? expectedDeliveryDate;
  num quantity;
  num buyQuantity;
  num finalQuantity;
  num freeQuantity;
  String? measure;

  num? price;
  String? productUrl;
  String? storeName;
  String? tabletsPerStrip;
  String? categoryName;
  num? mrp;
  bool prescriptionIsRequired;
  String? schemeId;
  String? schemeName;
  String? stockAvailable;
  num? maxOrderQuantity;
  String? manufacturer;
  String? message;

  Item({
    this.userId,
    this.cartId,
    this.storeId,
    this.skuId,
    this.expectedDeliveryDate,
    this.productId,
    this.productName,
    this.quantity = 0,
    this.buyQuantity = 0,
    this.finalQuantity = 0,
    this.freeQuantity = 0,
    this.measure,
    this.price,
    this.productUrl,
    this.storeName,
    this.tabletsPerStrip,
    this.categoryName,
    this.mrp,
    this.stockAvailable,
    this.prescriptionIsRequired = false,
    this.schemeName,
    this.schemeId,
    this.manufacturer,
    this.message,
    this.maxOrderQuantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        userId: json["userId"],
        cartId: json["cartId"],
        storeId: json["storeId"],
        skuId: json["skuId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        buyQuantity: json["buyQuantity"],
        measure: json["measure"],
        price: json["price"],
        productUrl: json["productUrl"],
        storeName: json["storeName"],
        tabletsPerStrip: json["tabletsPerStrip"],
        categoryName: json["categoryName"],
        mrp: json["mrp"],
        expectedDeliveryDate: json["expectedDeliveryDate"] == null
            ? null
            : DateTime.parse(json["expectedDeliveryDate"]),
        prescriptionIsRequired: json["prescriptionIsRequired"],
        finalQuantity:
            (json["finalQuantity"] == null) ? 0 : json["finalQuantity"],
        freeQuantity: (json["freeQuantity"] == null) ? 0 : json["freeQuantity"],
        schemeId: json["schemeId"],
        stockAvailable: json["stockAvailable"],
        schemeName: json["schemeName"],
        manufacturer: json["manufacturer"],
        message: json["message"],
        maxOrderQuantity: json["maxOrderQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "cartId": cartId,
        "storeId": storeId,
        "skuId": skuId,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "buyQuantity": buyQuantity,
        "measure": measure,
        "price": price,
        "productUrl": productUrl,
        "storeName": storeName,
        "tabletsPerStrip": tabletsPerStrip,
        "categoryName": categoryName,
        "mrp": mrp,
        "prescriptionIsRequired": prescriptionIsRequired,
        "finalQuantity": finalQuantity,
        "freeQuantity": freeQuantity,
        "schemeId": schemeId,
        "maxOrderQuantity": maxOrderQuantity,
        "expectedDeliveryDate": expectedDeliveryDate == null
            ? null
            : expectedDeliveryDate!.toIso8601String(),
        "stockAvailable": stockAvailable,
        "schemeName": schemeName,
        "manufacturer": manufacturer,
        "message": message,
      };
}
