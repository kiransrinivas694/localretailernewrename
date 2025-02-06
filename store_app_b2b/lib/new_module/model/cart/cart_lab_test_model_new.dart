import 'dart:convert';

CartLabTestModel cartLabTestModelFromJson(String str) =>
    CartLabTestModel.fromJson(json.decode(str));

String cartLabTestModelToJson(CartLabTestModel data) =>
    json.encode(data.toJson());

class CartLabTestModel {
  bool? status;
  String? message;
  LucidTestData? data;
  dynamic token;

  CartLabTestModel({this.status, this.message, this.data, this.token});

  factory CartLabTestModel.fromJson(Map<String, dynamic> json) {
    return CartLabTestModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LucidTestData.fromJson(json['data'] as Map<String, dynamic>),
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

class LucidTestData {
  String? id;
  String? userId;
  List<BasicLucidTestModel>? lucidTest;
  num? totalAmount;

  LucidTestData({this.id, this.userId, this.lucidTest, this.totalAmount});

  factory LucidTestData.fromJson(Map<String, dynamic> json) => LucidTestData(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        lucidTest: (json['lucidTest'] as List<dynamic>?)
            ?.map(
                (e) => BasicLucidTestModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: json['totalAmount'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'lucidTest': lucidTest?.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
      };
}

class BasicLucidTestModel {
  String? serviceCd;
  String? serviceName;
  String? image;
  String? hv;
  num? discount;
  num? finalMrp;
  dynamic homeCollection;
  String? isAppointmentRequired;
  String? isHealthPackage;
  BasicLucidTestModel(
      {this.serviceCd,
      this.serviceName,
      this.image,
      this.hv,
      this.discount,
      this.finalMrp,
      required this.homeCollection,
      this.isAppointmentRequired,
      this.isHealthPackage});

  factory BasicLucidTestModel.fromJson(Map<String, dynamic> json) =>
      BasicLucidTestModel(
        serviceCd: json['serviceCd'] as String?,
        serviceName: json['serviceName'] as String?,
        image: json['image'] as String?,
        discount: json['discount'] as num?,
        finalMrp: json['finalMrp'] as num?,
        homeCollection: json["homeCollection"],
        hv: json["hv"] as String?,
        isAppointmentRequired: json['isAppointmentRequired'] as String?,
        isHealthPackage: json['isHealthPackage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'serviceCd': serviceCd,
        'serviceName': serviceName,
        'image': image,
        'discount': discount,
        'finalMrp': finalMrp,
        "homeCollection": homeCollection,
        'hv': hv,
        'isAppointmentRequired': isAppointmentRequired,
        'isHealthPackage': isHealthPackage
      };
}
