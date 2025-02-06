import 'dart:convert';

HealthPackageDetails healthPackageDetailsFromJson(String str) =>
    HealthPackageDetails.fromJson(json.decode(str));

String healthPackageDetailsToJson(HealthPackageDetails data) =>
    json.encode(data.toJson());

class HealthPackageDetails {
  bool? status;
  String? message;
  BasicPackageDetails? data;
  dynamic token;

  HealthPackageDetails({this.status, this.message, this.data, this.token});

  factory HealthPackageDetails.fromJson(Map<String, dynamic> json) {
    return HealthPackageDetails(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BasicPackageDetails.fromJson(json['data'] as Map<String, dynamic>),
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

class BasicPackageDetails {
  String? id;
  String? serviceCd;
  String? packageName;
  List<PackageTypes>? healthPackageTypes;
  String? image;
  num? totalAmount;
  num? discount;
  String? discountType;
  num? finalMrp;
  String? pakageNameSearch;
  String? gender;
  String? isAppointmentRequired;
  String? helpLineNumber;

  BasicPackageDetails({
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
  });

  factory BasicPackageDetails.fromJson(Map<String, dynamic> json) =>
      BasicPackageDetails(
        id: json['id'] as String?,
        serviceCd: json['serviceCd'] as String?,
        packageName: json['packageName'] as String?,
        healthPackageTypes: (json['healthPackageTypes'] as List<dynamic>?)
            ?.map((e) => PackageTypes.fromJson(e as Map<String, dynamic>))
            .toList(),
        image: json['image'] as String?,
        totalAmount: json['totalAmount'] as num?,
        discount: json['discount'] as num?,
        discountType: json['discountType'] as String?,
        finalMrp: json['finalMrp'] as num?,
        pakageNameSearch: json['pakageNameSearch'] as String?,
        gender: json['gender'] as String?,
        isAppointmentRequired: json['isAppointmentRequired'] as String?,
        helpLineNumber: json['helpLineNumber'] as String?,
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
      };
}

class PackageTypes {
  String? packageType;
  String? image;
  List<String>? testNames;

  PackageTypes({this.packageType, this.image, this.testNames});

  factory PackageTypes.fromJson(Map<String, dynamic> json) {
    return PackageTypes(
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
