import 'dart:convert';

ExpiryProductsInfoModel expiryProductsInfoModelFromJson(String str) =>
    ExpiryProductsInfoModel.fromJson(json.decode(str));

String expiryProductsInfoModelToJson(ExpiryProductsInfoModel data) =>
    json.encode(data.toJson());

class ExpiryProductsInfoModel {
  bool? status;
  String? message;
  num? totalRecord;
  List<ExpiryProductInfo>? data;

  ExpiryProductsInfoModel({
    this.status,
    this.message,
    this.totalRecord,
    this.data,
  });

  factory ExpiryProductsInfoModel.fromJson(Map<String, dynamic> json) {
    return ExpiryProductsInfoModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      totalRecord: json['totalRecord'] as num?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExpiryProductInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'totalRecord': totalRecord,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class ExpiryProductInfo {
  String? itemId;
  String? invoiceId;
  String? productName;
  dynamic schemeId;
  String? schemeName;
  String? manufacturer;
  String? skuCode;
  String? batchNumber;
  String? orderId;
  String? storeId;
  String? productId;
  num? expiryReturnAmount;
  num? quantity;
  num? buyQuantity;
  num? freeQuantity;
  num? confirmQuantity;
  num? finalQuantity;
  num? finalPtr;
  num? mrp;
  String? expDate;
  String? skuId;
  String? hsn;
  String? cgstPercent;
  String? sgstPercent;
  String? gstPercent;
  String? discount;
  num? netRate;
  num? lineAmount;
  DateTime? orderCreatedDate;

  ExpiryProductInfo({
    this.itemId,
    this.invoiceId,
    this.productName,
    this.productId,
    this.orderId,
    this.storeId,
    this.schemeId,
    this.schemeName,
    this.manufacturer,
    this.skuCode,
    this.batchNumber,
    this.expiryReturnAmount,
    this.quantity,
    this.buyQuantity,
    this.freeQuantity,
    this.confirmQuantity,
    this.finalQuantity,
    this.finalPtr,
    this.mrp,
    this.expDate,
    this.skuId,
    this.hsn,
    this.cgstPercent,
    this.sgstPercent,
    this.gstPercent,
    this.discount,
    this.netRate,
    this.lineAmount,
    this.orderCreatedDate,
  });

  factory ExpiryProductInfo.fromJson(Map<String, dynamic> json) =>
      ExpiryProductInfo(
        itemId: json['itemId'] as String?,
        invoiceId: json['invoiceId'] as String?,
        productName: json['productName'] as String?,
        schemeId: json['schemeId'] as dynamic,
        schemeName: json['schemeName'] as String?,
        manufacturer: json['manufacturer'] as String?,
        skuCode: json['skuCode'] as String?,
        batchNumber: json['batchNumber'] as String?,
        orderId: json["orderId"] as String?,
        productId: json["productId"] as String?,
        storeId: json["storeId"] as String?,
        expiryReturnAmount: (json['expiryReturnAmount'] as num?),
        quantity: json['quantity'] as num?,
        buyQuantity: (json['buyQuantity'] as num?),
        freeQuantity: (json['freeQuantity'] as num?),
        confirmQuantity: json['confirmQuantity'] as num?,
        finalQuantity: json['finalQuantity'] as num?,
        finalPtr: (json['finalPtr'] as num?),
        mrp: (json['mrp'] as num?),
        expDate: json['expDate'] as String?,
        skuId: json['skuId'] as String?,
        hsn: json['hsn'] as String?,
        cgstPercent: json['cgstPercent'] as String?,
        sgstPercent: json['sgstPercent'] as String?,
        gstPercent: json['gstPercent'] as String?,
        discount: json['discount'] as String?,
        netRate: (json['netRate'] as num?),
        lineAmount: (json['lineAmount'] as num?),
        orderCreatedDate: json['orderCreatedDate'] == null
            ? null
            : DateTime.parse(json['orderCreatedDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'invoiceId': invoiceId,
        'productName': productName,
        'schemeId': schemeId,
        'schemeName': schemeName,
        'manufacturer': manufacturer,
        'skuCode': skuCode,
        'batchNumber': batchNumber,
        'orderId': orderId,
        'storeId': storeId,
        'productId': productId,
        'expiryReturnAmount': expiryReturnAmount,
        'quantity': quantity,
        'buyQuantity': buyQuantity,
        'freeQuantity': freeQuantity,
        'confirmQuantity': confirmQuantity,
        'finalQuantity': finalQuantity,
        'finalPtr': finalPtr,
        'mrp': mrp,
        'expDate': expDate,
        'skuId': skuId,
        'hsn': hsn,
        'cgstPercent': cgstPercent,
        'sgstPercent': sgstPercent,
        'gstPercent': gstPercent,
        'discount': discount,
        'netRate': netRate,
        'lineAmount': lineAmount,
        'orderCreatedDate': orderCreatedDate?.toIso8601String(),
      };
}
