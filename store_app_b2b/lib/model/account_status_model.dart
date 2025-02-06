// To parse this JSON data, do
//
//     final accountStatusModel = accountStatusModelFromJson(jsonString);

import 'dart:convert';

AccountStatusModel accountStatusModelFromJson(String str) =>
    AccountStatusModel.fromJson(json.decode(str));

String accountStatusModelToJson(AccountStatusModel data) =>
    json.encode(data.toJson());

class AccountStatusModel {
  String? purchaseAccountStatus;
  String? accountLocked;
  num? outStandingAmount;
  num? creditLimit;
  num? usedLimit;
  num? unlockDays;
  String? storeGrade;
  String? creditApplicable;
  String? laterDeliveryIsEnable;
  num? avgPaymentPercentage;
  num? numOrders;
  num? numPaidOnTime;
  num? numDelayedPayments;
  num? totalOrderAmount;
  num? totalPaidAmount;
  num? totalBalance;
  num? dailyOrderLimit;

  AccountStatusModel({
    this.purchaseAccountStatus,
    this.outStandingAmount,
    this.accountLocked,
    this.creditLimit,
    this.usedLimit,
    this.unlockDays,
    this.storeGrade,
    this.creditApplicable,
    this.laterDeliveryIsEnable,
    this.avgPaymentPercentage,
    this.numOrders,
    this.numPaidOnTime,
    this.numDelayedPayments,
    this.totalOrderAmount,
    this.totalPaidAmount,
    this.totalBalance,
    this.dailyOrderLimit,
  });

  factory AccountStatusModel.fromJson(Map<String, dynamic> json) =>
      AccountStatusModel(
        purchaseAccountStatus: json["purchaseAccountStatus"],
        outStandingAmount: json["outStandingAmount"],
        accountLocked: json["accountLocked"],
        creditLimit: json["creditLimit"],
        usedLimit: json["usedLimit"],
        storeGrade: json["storeGrade"],
        unlockDays: json["unlockDays"],
        creditApplicable: json["creditApplicable"],
        laterDeliveryIsEnable: json['laterDeliveryIsEnable'],
        avgPaymentPercentage: json["avgPaymentPercentage"],
        numOrders: json["numOrders"],
        numPaidOnTime: json["numPaidOnTime"],
        numDelayedPayments: json["numDelayedPayments"],
        totalOrderAmount: json["totalOrderAmount"],
        totalPaidAmount: json["totalPaidAmount"],
        totalBalance: json["totalBalance"],
        dailyOrderLimit: json["dailyOrderLimit"],
      );

  Map<String, dynamic> toJson() => {
        "purchaseAccountStatus": purchaseAccountStatus,
        "outStandingAmount": outStandingAmount,
        "creditLimit": creditLimit,
        "accountLocked": accountLocked,
        "usedLimit": usedLimit,
        "storeGrade": storeGrade,
        "unlockDays": unlockDays,
        "creditApplicable": creditApplicable,
        'laterDeliveryIsEnable': laterDeliveryIsEnable,
        "avgPaymentPercentage": avgPaymentPercentage,
        "numOrders": numOrders,
        "numPaidOnTime": numPaidOnTime,
        "totalOrderAmount": totalOrderAmount,
        "numDelayedPayments": numDelayedPayments,
        "totalPaidAmount": totalPaidAmount,
        "totalBalance": totalBalance,
        "dailyOrderLimit": dailyOrderLimit,
      };
}
