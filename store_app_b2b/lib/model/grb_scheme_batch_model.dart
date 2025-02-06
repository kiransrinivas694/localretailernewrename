import 'dart:convert';

List<GrbSchemeBatchModel> grbSchemeBatchModelFromJson(String str) =>
    List<GrbSchemeBatchModel>.from(
        json.decode(str).map((x) => GrbSchemeBatchModel.fromJson(x)));

String grbSchemeBatchModelToJson(List<GrbSchemeBatchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrbSchemeBatchModel {
  String? productId;
  String? productName;
  String? orderId;
  String? schemeName;
  String? schemeId;
  num? quantity;
  num? totalQuantity;
  num? totalFreeQuantity;
  num? totalConfirmQuantity;
  num? totalBuyQuantity;
  num? totalFinalQuantity;
  String? manufacturer;
  String? skuCode;
  DateTime? orderCreatedDate;
  List<GrbSchemeBatchItem>? items;

  GrbSchemeBatchModel({
    this.productId,
    this.productName,
    this.orderId,
    this.schemeName,
    this.quantity,
    this.manufacturer,
    this.skuCode,
    this.orderCreatedDate,
    this.items,
    this.schemeId,
    this.totalQuantity,
    this.totalFreeQuantity,
    this.totalConfirmQuantity,
    this.totalBuyQuantity,
    this.totalFinalQuantity,
  });

  factory GrbSchemeBatchModel.fromJson(Map<String, dynamic> json) =>
      GrbSchemeBatchModel(
        productId: json['productId'] as String?,
        productName: json['productName'] as String?,
        orderId: json['orderId'] as String?,
        schemeName: json['schemeName'] as String?,
        quantity: json['quantity'] as num?,
        manufacturer: json['manufacturer'] as String?,
        skuCode: json['skuCode'] as String?,
        schemeId: json['schemeId'] as String?,
        orderCreatedDate: json['orderCreatedDate'] == null
            ? null
            : DateTime.parse(json['orderCreatedDate'] as String),
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => GrbSchemeBatchItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalQuantity: json["totalQuantity"] as num?,
        totalFreeQuantity: json["totalFreeQuantity"] as num?,
        totalConfirmQuantity: json["totalConfirmQuantity"] as num?,
        totalBuyQuantity: json['totalBuyQuantity'] as num?,
        totalFinalQuantity: json['totalFinalQuantity'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'orderId': orderId,
        'schemeName': schemeName,
        'quantity': quantity,
        'manufacturer': manufacturer,
        'skuCode': skuCode,
        'orderCreatedDate': orderCreatedDate?.toIso8601String(),
        'items': items?.map((e) => e.toJson()).toList(),
        "schemeId": schemeId,
        "totalQuantity": totalQuantity,
        "totalFreeQuantity": totalFreeQuantity,
        "totalConfirmQuantity": totalConfirmQuantity,
        "totalBuyQuantity": totalBuyQuantity,
        "totalFinalQuantity": totalFinalQuantity,
      };
}

class GrbSchemeBatchItem {
  String? itemId;
  String? invoiceId;
  String? batchNumber;
  num? buyQuantity;
  num? freeQuantity;
  num? confirmQuantity;
  num? lineAmount;
  num? netRate;
  num? orderedQuantity;
  num? finalQuantity;
  double? finalPtr;
  num? mrp;
  num? expiryReturnAmount;
  String? cgstPercent;
  String? sgstPercent;
  String? gstPercent;
  String? discount;
  String? hsn;
  String? expDate;
  String? skuId;

  GrbSchemeBatchItem({
    this.itemId,
    this.invoiceId,
    this.batchNumber,
    this.buyQuantity,
    this.freeQuantity,
    this.confirmQuantity,
    this.finalQuantity,
    this.finalPtr,
    this.lineAmount,
    this.expiryReturnAmount,
    this.mrp,
    this.skuId,
    this.netRate,
    this.cgstPercent,
    this.discount,
    this.gstPercent,
    this.hsn,
    this.orderedQuantity,
    this.sgstPercent,
    this.expDate,
  });

  factory GrbSchemeBatchItem.fromJson(Map<String, dynamic> json) =>
      GrbSchemeBatchItem(
        itemId: json['itemId'] as String?,
        batchNumber: json['batchNumber'] as String?,
        buyQuantity: json['buyQuantity'] as num?,
        netRate: json['netRate'] as num?,
        freeQuantity: json['freeQuantity'] as num?,
        confirmQuantity: json['confirmQuantity'] as num?,
        finalQuantity: json['finalQuantity'] as num?,
        finalPtr: (json['finalPtr'] as num?)?.toDouble(),
        mrp: json['mrp'] as num?,
        expiryReturnAmount: json["expiryReturnAmount"] as num?,
        skuId: json['skuId'] as String?,
        invoiceId: json["invoiceId"] as String?,
        cgstPercent: json["cgstPercent"] as String?,
        discount: json["discount"] as String?,
        gstPercent: json["gstPercent"] as String?,
        hsn: json["hsn"] as String?,
        sgstPercent: json["sgstPercent"] as String?,
        expDate: json['expDate'] as String?,
        orderedQuantity: json["orderedQuantity"] as num?,
        lineAmount: json['lineAmount'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'batchNumber': batchNumber,
        'buyQuantity': buyQuantity,
        'freeQuantity': freeQuantity,
        'confirmQuantity': confirmQuantity,
        'finalQuantity': finalQuantity,
        'finalPtr': finalPtr,
        'mrp': mrp,
        'skuId': skuId,
        'netRate': netRate,
        'invoiceId': invoiceId,
        'cgstPercent': cgstPercent,
        'gstPercent': gstPercent,
        'sgstPercent': sgstPercent,
        'expiryReturnAmount': expiryReturnAmount,
        'hsn': hsn,
        'discount': discount,
        'expDate': expDate,
        'lineAmount': lineAmount,
        'orderedQuantity': orderedQuantity,
      };
}
