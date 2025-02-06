// To parse this JSON data, do
//
//     final latestOrderResponseModel = latestOrderResponseModelFromJson(jsonString);

import 'dart:convert';

List<LatestOrderResponseModel> latestOrderResponseModelFromJson(String str) =>
    List<LatestOrderResponseModel>.from(
        json.decode(str).map((x) => LatestOrderResponseModel.fromJson(x)));

String latestOrderResponseModelToJson(List<LatestOrderResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LatestOrderResponseModel {
  String? orderId;
  String? storeId;
  String? storeName;
  String? orderStatus;
  String? orderStautsId;
  DateTime? orderDate;
  String? customerId;
  num? orderValue;
  String? payMode;
  num? totalItems;
  String? supplierAddr;
  String? orderTime;

  LatestOrderResponseModel({
    this.orderId,
    this.storeId,
    this.storeName,
    this.orderStatus,
    this.orderStautsId,
    this.orderDate,
    this.customerId,
    this.orderValue,
    this.payMode,
    this.totalItems,
    this.supplierAddr,
    this.orderTime,
  });

  factory LatestOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      LatestOrderResponseModel(
        orderId: json["orderId"],
        storeId: json["storeId"],
        storeName: json["storeName"],
        orderStatus: json["orderStatus"],
        orderStautsId: json["orderStautsId"],
        orderDate: json['orderDate'] == null
            ? null
            : DateTime.parse(json['orderDate'] as String),
        customerId: json["customerId"],
        orderValue: json["orderValue"].toDouble(),
        payMode: json["payMode"],
        totalItems: json["totalItems"],
        supplierAddr: json["supplierAddr"],
        orderTime: json["orderTime"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "storeId": storeId,
        "storeName": storeName,
        "orderStatus": orderStatus,
        "orderStautsId": orderStautsId,
        "orderDate": orderDate!.toIso8601String(),
        "customerId": customerId,
        "orderValue": orderValue,
        "payMode": payMode,
        "totalItems": totalItems,
        "supplierAddr": supplierAddr,
        "orderTime": orderTime,
      };
}
