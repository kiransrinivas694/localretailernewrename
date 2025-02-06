import 'dart:convert';

PaymentOverviewModel paymentOverviewModelFromJson(String str) =>
    PaymentOverviewModel.fromJson(json.decode(str));

String paymentOverviewModelToJson(PaymentOverviewModel data) =>
    json.encode(data.toJson());

class PaymentOverviewModel {
  String? storeId;
  String? payerId;
  num? totalBilledAmount;
  num? totalAmountPaid;
  num? totalBalanceToBePaid;

  PaymentOverviewModel({
    this.storeId,
    this.payerId,
    this.totalBilledAmount,
    this.totalAmountPaid,
    this.totalBalanceToBePaid,
  });

  factory PaymentOverviewModel.fromJson(Map<String, dynamic> json) {
    return PaymentOverviewModel(
      storeId: json['storeId'] as String?,
      payerId: json['payerId'] as String?,
      totalBilledAmount: json['totalBilledAmount'] as num?,
      totalAmountPaid: json['totalAmountPaid'] as num?,
      totalBalanceToBePaid: json['totalBalanceToBePaid'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'payerId': payerId,
        'totalBilledAmount': totalBilledAmount,
        'totalAmountPaid': totalAmountPaid,
        'totalBalanceToBePaid': totalBalanceToBePaid,
      };
}
