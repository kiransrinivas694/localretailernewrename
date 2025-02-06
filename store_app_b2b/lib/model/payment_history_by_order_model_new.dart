// To parse this JSON data, do
//
//     final paymentHistoryByOrderModel = paymentHistoryByOrderModelFromJson(jsonString);

import 'dart:convert';

PaymentHistoryByOrderModel paymentHistoryByOrderModelFromJson(String str) =>
    PaymentHistoryByOrderModel.fromJson(json.decode(str));

String paymentHistoryByOrderModelToJson(PaymentHistoryByOrderModel data) =>
    json.encode(data.toJson());

class PaymentHistoryByOrderModel {
  String? orderId;
  num? orderAmount;
  DateTime? orderDate;
  num? paidAmount;
  num? billedAmount;
  num? balanceTobePaid;
  String? userName;
  String? userId;
  String? orderStatus;
  String? fullyPaid;
  List<PaymentInfo> paymentInfo;

  PaymentHistoryByOrderModel({
    this.orderId,
    this.orderAmount,
    this.orderDate,
    this.paidAmount,
    this.billedAmount,
    this.balanceTobePaid,
    this.userName,
    this.userId,
    this.orderStatus,
    this.fullyPaid,
    this.paymentInfo = const <PaymentInfo>[],
  });

  factory PaymentHistoryByOrderModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryByOrderModel(
        orderId: json["orderId"],
        orderAmount: json["orderAmount"],
        orderDate: DateTime.parse(json["orderDate"]),
        paidAmount: json["paidAmount"],
        billedAmount: json["billedAmount"],
        balanceTobePaid: json["balanceTobePaid"],
        userName: json["userName"],
        userId: json["userId"],
        orderStatus: json["orderStatus"],
        fullyPaid: json["fullyPaid"],
        paymentInfo: List<PaymentInfo>.from(
            json["paymentInfo"].map((x) => PaymentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderAmount": orderAmount,
        "orderDate": orderDate!.toIso8601String(),
        "paidAmount": paidAmount,
        "billedAmount": billedAmount,
        "balanceTobePaid": balanceTobePaid,
        "userName": userName,
        "userId": userId,
        "orderStatus": orderStatus,
        "fullyPaid": fullyPaid,
        "paymentInfo": List<dynamic>.from(paymentInfo.map((x) => x.toJson())),
      };
}

class PaymentInfo {
  String? paymentId;
  DateTime? paidDate;
  num? paidAmount;
  String? trasactionStatus;
  String? paymentMode;
  String? paymentType;

  PaymentInfo({
    this.paymentId,
    this.paidDate,
    this.paidAmount,
    this.trasactionStatus,
    this.paymentMode,
    this.paymentType,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        paymentId: json["paymentId"],
        paidDate: (json["paidDate"] == null)
            ? null
            : DateTime.parse(json["paidDate"]),
        paidAmount: json["paidAmount"],
        trasactionStatus: json["trasactionStatus"],
        paymentMode: json["paymentMode"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "paidDate": paidDate == null ? "" : paidDate!.toIso8601String(),
        "paidAmount": paidAmount,
        "trasactionStatus": trasactionStatus,
        "paymentMode": paymentMode,
        "paymentType": paymentType,
      };
}
