import 'dart:convert';

SubscriptionTenureModel subscriptionTenureModelFromJson(String str) =>
    SubscriptionTenureModel.fromJson(json.decode(str));

String subscriptionTenureModelToJson(SubscriptionTenureModel data) =>
    json.encode(data.toJson());

class SubscriptionTenureModel {
  String? id;
  String? planType;
  String? planStartDate;
  String? planEndDate;
  String? planRate;
  String? planTenure;
  dynamic planTermsConditions;
  dynamic features;
  dynamic nofeatures;
  String? planDescription;
  bool? status;
  String? paymentFlg;
  dynamic createdAt;
  dynamic createdBy;
  dynamic updatedAt;
  dynamic updatedBy;

  SubscriptionTenureModel({
    this.id,
    this.planType,
    this.planStartDate,
    this.planEndDate,
    this.planRate,
    this.planTenure,
    this.planTermsConditions,
    this.features,
    this.nofeatures,
    this.planDescription,
    this.status,
    this.paymentFlg,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory SubscriptionTenureModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionTenureModel(
      id: json['id'] as String?,
      planType: json['planType'] as String?,
      planStartDate: json['planStartDate'] as String?,
      planEndDate: json['planEndDate'] as String?,
      planRate: json['planRate'] as String?,
      planTenure: json['planTenure'] as String?,
      planTermsConditions: json['planTermsConditions'] as dynamic,
      features: json['features'] as dynamic,
      nofeatures: json['nofeatures'] as dynamic,
      planDescription: json['planDescription'] as String?,
      status: json['status'] as bool?,
      paymentFlg: json['paymentFlg'] as String?,
      createdAt: json['createdAt'] as dynamic,
      createdBy: json['createdBy'] as dynamic,
      updatedAt: json['updatedAt'] as dynamic,
      updatedBy: json['updatedBy'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'planType': planType,
        'planStartDate': planStartDate,
        'planEndDate': planEndDate,
        'planRate': planRate,
        'planTenure': planTenure,
        'planTermsConditions': planTermsConditions,
        'features': features,
        'nofeatures': nofeatures,
        'planDescription': planDescription,
        'status': status,
        'paymentFlg': paymentFlg,
        'createdAt': createdAt,
        'createdBy': createdBy,
        'updatedAt': updatedAt,
        'updatedBy': updatedBy,
      };
}
