import 'dart:convert';

CartDiagnosticTestsModel cartDiagnosticTestsModelFromJson(String str) =>
    CartDiagnosticTestsModel.fromJson(json.decode(str));

String cartDiagnosticTestsModelToJson(CartDiagnosticTestsModel data) =>
    json.encode(data.toJson());

class CartDiagnosticTestsModel {
  bool? status;
  String? message;
  CartTestData? data;
  dynamic token;

  CartDiagnosticTestsModel({this.status, this.message, this.data, this.token});

  factory CartDiagnosticTestsModel.fromJson(Map<String, dynamic> json) {
    return CartDiagnosticTestsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CartTestData.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'token': token,
      };
}

class CartTestData {
  String? id;
  String? userId;
  List<CartTest>? lucidTest;
  num? totalAmount;
  num? totalDiscount;
  num? totalMrpPriceAmount;
  CartTestData(
      {this.id,
      this.userId,
      this.lucidTest,
      this.totalDiscount,
      this.totalMrpPriceAmount,
      this.totalAmount});

  factory CartTestData.fromJson(Map<String, dynamic> json) => CartTestData(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        lucidTest: (json['lucidTest'] as List<dynamic>?)
            ?.map((e) => CartTest.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: json['totalAmount'] as num?,
        totalDiscount: json['totalDiscount'] as num?,
        totalMrpPriceAmount: json['totalMrpPriceAmount'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'lucidTest': lucidTest?.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'totalDiscount': totalDiscount,
        'totalMrpPriceAmount': totalMrpPriceAmount,
      };
}

class CartTest {
  String? serviceCd;
  String? serviceName;
  String? image;
  num? finalMrp;
  num? mrpPrice;
  num? discount;
  String? hv;
  String? isAppointmentRequired;
  dynamic healthPackageTypes;
  String? isHealthPackage;

  CartTest({
    this.serviceCd,
    this.serviceName,
    this.image,
    this.finalMrp,
    this.mrpPrice,
    this.discount,
    this.hv,
    this.isAppointmentRequired,
    this.healthPackageTypes,
    this.isHealthPackage,
  });

  factory CartTest.fromJson(Map<String, dynamic> json) => CartTest(
        serviceCd: json['serviceCd'] as String?,
        serviceName: json['serviceName'] as String?,
        image: json['image'] as String?,
        finalMrp: json['finalMrp'] as num?,
        discount: json['discount'] as num?,
        mrpPrice: json['mrpPrice'] as num?,
        hv: json['hv'] as String?,
        isAppointmentRequired: json['isAppointmentRequired'] as String?,
        healthPackageTypes: json['healthPackageTypes'] as dynamic,
        isHealthPackage: json['isHealthPackage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'serviceCd': serviceCd,
        'serviceName': serviceName,
        'image': image,
        'finalMrp': finalMrp,
        'discount': discount,
        'mrpPrice': mrpPrice,
        'hv': hv,
        'isAppointmentRequired': isAppointmentRequired,
        'healthPackageTypes': healthPackageTypes,
        'isHealthPackage': isHealthPackage,
      };
}
