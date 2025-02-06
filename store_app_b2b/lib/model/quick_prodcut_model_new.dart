// To parse this JSON data, do
//
//     final quickProductListModel = quickProductListModelFromJson(jsonString);

import 'dart:convert';

QuickProductListModel quickProductListModelFromJson(String str) =>
    QuickProductListModel.fromJson(json.decode(str));

String quickProductListModelToJson(QuickProductListModel data) =>
    json.encode(data.toJson());

class QuickProductListModel {
  String? id;
  String? userId;
  String? userName;
  String? storeId;
  String? storeName;
  DateTime? insertDate;
  List<QuickItem> quickItems;
  String? checkOut;
  num? platformCharges;
  num? delivaryCharges;
  num? gstCharges;
  String? gstPercent;
  num? totalPayble;
  String? transId;
  num? paidDelivaryAmount;
  String? transStatus;
  dynamic orderStatus;
  String? invoiceUrl;
  String? riderId;
  String? riderName;
  String? riderContactNumber;
  dynamic invoieId;
  num? invoiceAmount;
  String? invoicePaidTransId;
  dynamic invoicePaidAmount;
  String? invoicePaidTransStatus;
  DateTime? invoiceDate;
  String? riderStatus;
  String? riderRating;
  String? cartStatus;
  double? totalQuantity;
  double? totalProducts;

  QuickProductListModel({
    this.id,
    this.userId,
    this.userName,
    this.storeId,
    this.storeName,
    this.insertDate,
    this.quickItems = const <QuickItem>[],
    this.checkOut,
    this.platformCharges,
    this.delivaryCharges,
    this.gstCharges,
    this.gstPercent,
    this.totalPayble,
    this.transId,
    this.paidDelivaryAmount,
    this.transStatus,
    this.orderStatus,
    this.invoiceUrl,
    this.riderId,
    this.riderName,
    this.riderContactNumber,
    this.invoieId,
    this.invoiceAmount,
    this.invoicePaidTransId,
    this.invoicePaidAmount,
    this.invoicePaidTransStatus,
    this.invoiceDate,
    this.riderStatus,
    this.riderRating,
    this.cartStatus,
    this.totalQuantity,
    this.totalProducts,
  });

  factory QuickProductListModel.fromJson(Map<String, dynamic> json) =>
      QuickProductListModel(
          id: json["id"],
          userId: json["userId"],
          userName: json["userName"],
          storeId: json["storeId"],
          storeName: json["storeName"],
          insertDate: json["insertDate"] == null
              ? null
              : DateTime.parse(json["insertDate"]),
          quickItems: json["items"] == null
              ? []
              : List<QuickItem>.from(
                  json["items"]!.map((x) => QuickItem.fromJson(x))),
          checkOut: json["checkOut"],
          platformCharges: json["platformCharges"],
          delivaryCharges: json["delivaryCharges"],
          gstCharges: json["gstCharges"],
          gstPercent: json["gstPercent"],
          totalPayble: json["totalPayble"],
          transId: json["transId"],
          paidDelivaryAmount: json["paidDelivaryAmount"],
          transStatus: json["transStatus"],
          orderStatus: json["orderStatus"],
          invoiceUrl: json["invoiceURL"],
          riderId: json["riderId"],
          riderName: json["riderName"],
          riderContactNumber: json["riderContactNumber"],
          invoieId: json["invoieId"],
          invoiceAmount: json["invoiceAmount"],
          invoicePaidTransId: json["invoicePaidTransId"],
          invoicePaidAmount: json["invoicePaidAmount"],
          invoicePaidTransStatus: json["invoicePaidTransStatus"],
          invoiceDate: json["invoiceDate"] == null
              ? null
              : DateTime.parse(json["invoiceDate"]),
          riderStatus: json["riderStatus"],
          riderRating: json["riderRating"],
          cartStatus: json["cartStatus"],
          totalProducts: json["totalProducts"],
          totalQuantity: json["totalQuantity"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "storeId": storeId,
        "storeName": storeName,
        "insertDate": insertDate?.toIso8601String(),
        "items": List<dynamic>.from(quickItems.map((x) => x.toJson())),
        "checkOut": checkOut,
        "platformCharges": platformCharges,
        "delivaryCharges": delivaryCharges,
        "gstCharges": gstCharges,
        "gstPercent": gstPercent,
        "totalPayble": totalPayble,
        "transId": transId,
        "paidDelivaryAmount": paidDelivaryAmount,
        "transStatus": transStatus,
        "orderStatus": orderStatus,
        "invoiceURL": invoiceUrl,
        "riderId": riderId,
        "riderName": riderName,
        "riderContactNumber": riderContactNumber,
        "invoieId": invoieId,
        "invoiceAmount": invoiceAmount,
        "invoicePaidTransId": invoicePaidTransId,
        "invoicePaidAmount": invoicePaidAmount,
        "invoicePaidTransStatus": invoicePaidTransStatus,
        "invoiceDate": invoiceDate?.toIso8601String(),
        "riderStatus": riderStatus,
        "riderRating": riderRating,
        "cartStatus": cartStatus,
        "totalProducts": totalProducts,
        "totalQuantity": totalQuantity,
      };
}

class QuickItem {
  String? id;
  String? productName;
  String? manufacturer;
  num? quantity;
  num? freeQuantity;
  num? totalQuantity;

  QuickItem({
    this.id,
    this.productName,
    this.manufacturer,
    this.quantity,
    this.freeQuantity,
    this.totalQuantity,
  });

  factory QuickItem.fromJson(Map<String, dynamic> json) => QuickItem(
        id: json["id"],
        productName: json["productName"],
        manufacturer: json["manufacturer"],
        quantity: json["quantity"],
        freeQuantity: json["freeQuantity"],
        totalQuantity: json["totalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "manufacturer": manufacturer,
        "quantity": quantity,
        "freeQuantity": freeQuantity,
        "totalQuantity": totalQuantity,
      };
}
