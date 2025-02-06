import 'dart:convert';

ViewAllPackageCartModel viewAllPackageCartModelFromJson(String str) =>
    ViewAllPackageCartModel.fromJson(json.decode(str));

String viewAllPackageCartModelToJson(ViewAllPackageCartModel data) =>
    json.encode(data.toJson());

class ViewAllPackageCartModel {
  bool? status;
  String? message;
  BasicPackageCartDetails? data;
  dynamic token;

  ViewAllPackageCartModel({this.status, this.message, this.data, this.token});

  factory ViewAllPackageCartModel.fromJson(Map<String, dynamic> json) {
    return ViewAllPackageCartModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BasicPackageCartDetails.fromJson(
              json['data'] as Map<String, dynamic>),
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

class BasicPackageCartDetails {
  String? id;
  String? serviceCd;
  String? packageName;
  List<PackageCartTypes>? healthPackageTypes;
  String? image;
  num? totalAmount;
  num? discount;
  String? discountType;
  num? finalMrp;
  String? pakageNameSearch;
  String? gender;
  String? isAppointmentRequired;
  String? helpLineNumber;
  String? isTopHealthPackage;

  BasicPackageCartDetails({
    this.id,
    this.serviceCd,
    this.packageName,
    this.healthPackageTypes,
    this.image,
    this.totalAmount,
    this.discount,
    this.discountType,
    this.finalMrp,
    this.pakageNameSearch,
    this.gender,
    this.isAppointmentRequired,
    this.helpLineNumber,
    this.isTopHealthPackage,
  });

  factory BasicPackageCartDetails.fromJson(Map<String, dynamic> json) =>
      BasicPackageCartDetails(
        id: json['id'] as String?,
        serviceCd: json['serviceCd'] as String?,
        packageName: json['packageName'] as String?,
        healthPackageTypes: (json['healthPackageTypes'] as List<dynamic>?)
            ?.map((e) => PackageCartTypes.fromJson(e as Map<String, dynamic>))
            .toList(),
        image: json['image'] as String?,
        totalAmount: json['totalAmount'] as int?,
        discount: json['discount'] as num?,
        discountType: json['discountType'] as String?,
        finalMrp: json['finalMrp'] as num?,
        pakageNameSearch: json['pakageNameSearch'] as String?,
        gender: json['gender'] as String?,
        isAppointmentRequired: json['isAppointmentRequired'] as String?,
        helpLineNumber: json['helpLineNumber'] as String?,
        isTopHealthPackage: json['isTopHealthPackage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceCd': serviceCd,
        'packageName': packageName,
        'healthPackageTypes': healthPackageTypes,
        'image': image,
        'totalAmount': totalAmount,
        'discount': discount,
        'discountType': discountType,
        'finalMrp': finalMrp,
        'pakageNameSearch': pakageNameSearch,
        'gender': gender,
        'isAppointmentRequired': isAppointmentRequired,
        'helpLineNumber': helpLineNumber,
        'isTopHealthPackage': isTopHealthPackage,
      };
}

class PackageCartTypes {
  String? packageType;
  String? image;
  List<String>? testNames;

  PackageCartTypes({this.packageType, this.image, this.testNames});

  factory PackageCartTypes.fromJson(Map<String, dynamic> json) {
    return PackageCartTypes(
      packageType: json['packageType'] as String?,
      image: json['image'] as String?,
      testNames: (json['testNames'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'packageType': packageType,
        'image': image,
        'testNames': testNames,
      };
}
