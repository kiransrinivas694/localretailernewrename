import 'dart:convert';

StoreCreditRatingModel storeCreditRatingModelFromJson(String str) =>
    StoreCreditRatingModel.fromJson(json.decode(str));

String storeCreditRatingModelToJson(StoreCreditRatingModel data) =>
    json.encode(data.toJson());

class StoreCreditRatingModel {
  String? id;
  String? retailerId;
  String? retailer;
  num? totalOrderAmount;
  num? totalPaidAmount;
  num? totalBalance;
  double? avgPaymentPercentage;
  num? maxDaysOverdue;
  num? numOrders;
  num? numPaidOnTime;
  num? numDelayedPayments;
  String? creditRating;
  dynamic storeId;
  dynamic tbmId;
  dynamic abmId;

  StoreCreditRatingModel({
    this.id,
    this.retailerId,
    this.retailer,
    this.totalOrderAmount,
    this.totalPaidAmount,
    this.totalBalance,
    this.avgPaymentPercentage,
    this.maxDaysOverdue,
    this.numOrders,
    this.numPaidOnTime,
    this.numDelayedPayments,
    this.creditRating,
    this.storeId,
    this.tbmId,
    this.abmId,
  });

  factory StoreCreditRatingModel.fromJson(Map<String, dynamic> json) {
    return StoreCreditRatingModel(
      id: json['id'] as String?,
      retailerId: json['retailerId'] as String?,
      retailer: json['retailer'] as String?,
      totalOrderAmount: json['totalOrderAmount'] as num?,
      totalPaidAmount: json['totalPaidAmount'] as num?,
      totalBalance: json['totalBalance'] as num?,
      avgPaymentPercentage: (json['avgPaymentPercentage'] as num?)?.toDouble(),
      maxDaysOverdue: json['maxDaysOverdue'] as num?,
      numOrders: json['numOrders'] as num?,
      numPaidOnTime: json['numPaidOnTime'] as num?,
      numDelayedPayments: json['numDelayedPayments'] as num?,
      creditRating: json['creditRating'] as String?,
      storeId: json['storeId'] as dynamic,
      tbmId: json['tbmId'] as dynamic,
      abmId: json['abmId'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'retailerId': retailerId,
        'retailer': retailer,
        'totalOrderAmount': totalOrderAmount,
        'totalPaidAmount': totalPaidAmount,
        'totalBalance': totalBalance,
        'avgPaymentPercentage': avgPaymentPercentage,
        'maxDaysOverdue': maxDaysOverdue,
        'numOrders': numOrders,
        'numPaidOnTime': numPaidOnTime,
        'numDelayedPayments': numDelayedPayments,
        'creditRating': creditRating,
        'storeId': storeId,
        'tbmId': tbmId,
        'abmId': abmId,
      };
}
