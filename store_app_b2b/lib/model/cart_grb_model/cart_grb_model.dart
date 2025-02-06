import 'dart:convert';

CartGrbModel cartGrbModelFromJson(String str) =>
    CartGrbModel.fromJson(json.decode(str));

String cartGrbModelToJson(CartGrbModel data) => json.encode(data.toJson());

class CartGrbModel {
  String? id;
  double? totalPrice;
  dynamic totalDeliveryCharges;
  dynamic serviceCharges;
  dynamic taxOnServiceCharges;
  String? userId;
  dynamic userName;
  List<CartGrbStoreVO>? storeVo;

  CartGrbModel({
    this.id,
    this.totalPrice,
    this.totalDeliveryCharges,
    this.serviceCharges,
    this.taxOnServiceCharges,
    this.userId,
    this.userName,
    this.storeVo,
  });

  factory CartGrbModel.fromJson(Map<String, dynamic> json) => CartGrbModel(
        id: json['id'] as String?,
        totalPrice: (json['totalPrice'] as num?)?.toDouble(),
        totalDeliveryCharges: json['totalDeliveryCharges'] as dynamic,
        serviceCharges: json['serviceCharges'] as dynamic,
        taxOnServiceCharges: json['taxOnServiceCharges'] as dynamic,
        userId: json['userId'] as String?,
        userName: json['userName'] as dynamic,
        storeVo: (json['storeVo'] as List<dynamic>?)
            ?.map((e) => CartGrbStoreVO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalPrice': totalPrice,
        'totalDeliveryCharges': totalDeliveryCharges,
        'serviceCharges': serviceCharges,
        'taxOnServiceCharges': taxOnServiceCharges,
        'userId': userId,
        'userName': userName,
        'storeVo': storeVo?.map((e) => e.toJson()).toList(),
      };
}

class CartGrbStoreVO {
  String? storeId;
  dynamic storeName;
  dynamic address;
  bool? prescUploaded;
  bool? continueWithoutPrescItems;
  double? totalPriceByStore;
  num? deliveryChargesByStore;
  List<GrbItemModel>? items;
  bool? consultDoctor;
  bool? existingCustomer;

  CartGrbStoreVO({
    this.storeId,
    this.storeName,
    this.address,
    this.prescUploaded,
    this.continueWithoutPrescItems,
    this.totalPriceByStore,
    this.deliveryChargesByStore,
    this.items,
    this.consultDoctor,
    this.existingCustomer,
  });

  factory CartGrbStoreVO.fromJson(Map<String, dynamic> json) => CartGrbStoreVO(
        storeId: json['storeId'] as String?,
        storeName: json['storeName'] as dynamic,
        address: json['address'] as dynamic,
        prescUploaded: json['prescUploaded'] as bool?,
        continueWithoutPrescItems: json['continueWithoutPrescItems'] as bool?,
        totalPriceByStore: (json['totalPriceByStore'] as num?)?.toDouble(),
        deliveryChargesByStore: json['deliveryChargesByStore'] as num?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => GrbItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        consultDoctor: json['consultDoctor'] as bool?,
        existingCustomer: json['existingCustomer'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'storeName': storeName,
        'address': address,
        'prescUploaded': prescUploaded,
        'continueWithoutPrescItems': continueWithoutPrescItems,
        'totalPriceByStore': totalPriceByStore,
        'deliveryChargesByStore': deliveryChargesByStore,
        'items': items?.map((e) => e.toJson()).toList(),
        'consultDoctor': consultDoctor,
        'existingCustomer': existingCustomer,
      };
}

class GrbItemModel {
  String? orderId;
  String? itemId;
  String? productId;
  String? productName;
  String? measure;
  String? schemeName;
  String? schemeId;
  String? manufacturer;
  num? quantity;
  String? screenDisplay;
  num? finalQuantity;
  num? freeQuantity;
  num? buyQuantity;
  num? orderedQuantity;
  num? price;
  double? finalPtr;
  num? mrp;
  num? lineAmount;
  String? skuId;
  String? productUrl;
  String? storeName;
  String? tabletsPerStrip;
  String? categoryName;
  bool? prescriptionIsRequired;
  String? checkOutStatus;
  String? timePassed;
  String? batchNumber;
  String? message;
  String? invoiceId;
  String? skuCode;
  String? hsn;
  String? expiryDate;
  String? returnReason;
  String? cgstPercent;
  String? discount;
  String? sgstPercent;
  num? netRate;
  num? confrimQuantity;

  GrbItemModel({
    this.orderId,
    this.itemId,
    this.productId,
    this.productName,
    this.measure,
    this.schemeName,
    this.screenDisplay,
    this.schemeId,
    this.manufacturer,
    this.lineAmount,
    this.quantity,
    this.finalQuantity,
    this.freeQuantity,
    this.buyQuantity,
    this.orderedQuantity,
    this.price,
    this.finalPtr,
    this.mrp,
    this.skuId,
    this.productUrl,
    this.storeName,
    this.tabletsPerStrip,
    this.categoryName,
    this.prescriptionIsRequired,
    this.checkOutStatus,
    this.timePassed,
    this.batchNumber,
    this.message,
    this.invoiceId,
    this.skuCode,
    this.hsn,
    this.expiryDate,
    this.returnReason,
    this.cgstPercent,
    this.discount,
    this.sgstPercent,
    this.netRate,
    this.confrimQuantity,
  });

  factory GrbItemModel.fromJson(Map<String, dynamic> json) => GrbItemModel(
        orderId: json['orderId'] as String?,
        itemId: json['itemId'] as String?,
        productId: json['productId'] as String?,
        productName: json['productName'] as String?,
        measure: json['measure'] as String?,
        schemeName: json['schemeName'] as String?,
        schemeId: json['schemeId'] as String?,
        manufacturer: json['manufacturer'] as String?,
        quantity: json['quantity'] as num?,
        finalQuantity: json['finalQuantity'] as num?,
        freeQuantity: json['freeQuantity'] as num?,
        buyQuantity: json['buyQuantity'] as num?,
        screenDisplay: json['screenDisplay'] as String?,
        orderedQuantity: json['orderedQuantity'] as num?,
        price: json['price'] as num?,
        finalPtr: (json['finalPtr'] as num?)?.toDouble(),
        mrp: json['mrp'] as num?,
        skuId: json['skuId'] as String?,
        productUrl: json['productUrl'] as String?,
        storeName: json['storeName'] as String?,
        tabletsPerStrip: json['tabletsPerStrip'] as String?,
        categoryName: json['categoryName'] as String?,
        prescriptionIsRequired: json['prescriptionIsRequired'] as bool?,
        checkOutStatus: json['checkOutStatus'] as String?,
        timePassed: json['timePassed'] as String?,
        batchNumber: json['batchNumber'] as String?,
        message: json['message'] as String?,
        invoiceId: json['invoiceId'] as String?,
        cgstPercent: json['cgstPercent'] as String?,
        discount: json['discount'] as String?,
        expiryDate: json['expiryDate'] as String?,
        hsn: json['hsn'] as String?,
        returnReason: json['returnReason'] as String?,
        sgstPercent: json['sgstPercent'] as String?,
        skuCode: json['skuCode'] as String?,
        lineAmount: json['lineAmount'] as num?,
        netRate: json['netRate'] as num?,
        confrimQuantity: json['confrimQuantity'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'itemId': itemId,
        'productId': productId,
        'productName': productName,
        'measure': measure,
        'schemeName': schemeName,
        'schemeId': schemeId,
        'manufacturer': manufacturer,
        'quantity': quantity,
        'finalQuantity': finalQuantity,
        'freeQuantity': freeQuantity,
        'buyQuantity': buyQuantity,
        'orderedQuantity': orderedQuantity,
        'screenDisplay': screenDisplay,
        'price': price,
        'finalPtr': finalPtr,
        'mrp': mrp,
        'skuId': skuId,
        'productUrl': productUrl,
        'storeName': storeName,
        'tabletsPerStrip': tabletsPerStrip,
        'categoryName': categoryName,
        'prescriptionIsRequired': prescriptionIsRequired,
        'checkOutStatus': checkOutStatus,
        'timePassed': timePassed,
        'batchNumber': batchNumber,
        'message': message,
        'invoiceId': invoiceId,
        "cgstPercent": cgstPercent,
        "discount": discount,
        "expiryDate": expiryDate,
        "hsn": hsn,
        'lineAmount': lineAmount,
        "returnReason": returnReason,
        "sgstPercent": sgstPercent,
        "skuCode": skuCode,
        'netRate': netRate,
        'confrimQuantity': confrimQuantity,
      };
}
