import 'dart:convert';

DiagnosticUserDetailsModel diagnosticUserDetailsModelFromJson(String str) =>
    DiagnosticUserDetailsModel.fromJson(json.decode(str));

String diagnosticUserDetailsModelToJson(DiagnosticUserDetailsModel data) =>
    json.encode(data.toJson());

class DiagnosticUserDetailsModel {
  bool? status;
  String? message;
  BasicUserDetails? data;
  dynamic token;

  DiagnosticUserDetailsModel({
    this.status,
    this.message,
    this.data,
    this.token,
  });

  factory DiagnosticUserDetailsModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticUserDetailsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BasicUserDetails.fromJson(json['data'] as Map<String, dynamic>),
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

class BasicUserDetails {
  String? id;
  String? cartId;
  String? userId;
  String? relation;
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  dynamic dateOfBirth;
  String? mobileNumber;
  String? city;
  String? location;
  String? comments;
  String? address;
  String? fullAddress;
  String? latitude;
  dynamic longitude;
  String? status;
  String? bookingDate;
  String? appointmentDate;
  LucidCart? lucidCart;
  String? branchId;
  String? lucidBranchId;

  BasicUserDetails({
    this.id,
    this.cartId,
    this.userId,
    this.relation,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.dateOfBirth,
    this.mobileNumber,
    this.city,
    this.location,
    this.comments,
    this.address,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.status,
    this.bookingDate,
    this.appointmentDate,
    this.lucidCart,
    this.branchId,
    this.lucidBranchId,
  });

  factory BasicUserDetails.fromJson(Map<String, dynamic> json) =>
      BasicUserDetails(
        id: json['id'] as String?,
        cartId: json['cartId'] as String?,
        userId: json['userId'] as String?,
        relation: json['relation'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        age: json['age'] as int?,
        gender: json['gender'] as String?,
        dateOfBirth: json['dateOfBirth'] as dynamic,
        mobileNumber: json['mobileNumber'] as String?,
        city: json['city'] as String?,
        location: json['location'] as String?,
        comments: json['comments'] as String?,
        address: json['address'] as String?,
        fullAddress: json['fullAddress'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as dynamic,
        status: json['status'] as String?,
        bookingDate:
            json['bookingDate'] == null ? '' : json['bookingDate'] as String,
        appointmentDate: json['appointmentDate'] as String?,
        lucidCart: json['lucidCart'] == null
            ? null
            : LucidCart.fromJson(json['lucidCart'] as Map<String, dynamic>),
        branchId: json['branchId'] as String?,
        lucidBranchId: json['lucidBranchId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cartId': cartId,
        'userId': userId,
        'relation': relation,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'mobileNumber': mobileNumber,
        'city': city,
        'location': location,
        'comments': comments,
        'address': address,
        'fullAddress': fullAddress,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'bookingDate': bookingDate,
        'appointmentDate': appointmentDate,
        'lucidCart': lucidCart?.toJson(),
        'branchId': branchId,
        'lucidBranchId': lucidBranchId,
      };
}

class LucidCart {
  String? id;
  String? userId;
  List<LucidTest>? lucidTest;
  num? totalAmount;
  dynamic cretedBy;
  DateTime? createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String? isActive;

  LucidCart({
    this.id,
    this.userId,
    this.lucidTest,
    this.totalAmount,
    this.cretedBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isActive,
  });

  factory LucidCart.fromJson(Map<String, dynamic> json) => LucidCart(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        lucidTest: (json['lucidTest'] as List<dynamic>?)
            ?.map((e) => LucidTest.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: json['totalAmount'] as num?,
        cretedBy: json['cretedBy'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedBy: json['updatedBy'] as dynamic,
        updatedAt: json['updatedAt'] as dynamic,
        isActive: json['isActive'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'lucidTest': lucidTest?.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'cretedBy': cretedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedAt': updatedAt,
        'isActive': isActive,
      };
}

class LucidTest {
  String? serviceCd;
  String? serviceName;
  String? image;
  num? finalMrp;
  num? discount;
  String? hv;
  String? isAppointmentRequired;
  dynamic healthPackageTypes;
  String? isHealthPackage;

  LucidTest({
    this.serviceCd,
    this.serviceName,
    this.image,
    this.finalMrp,
    this.discount,
    this.hv,
    this.isAppointmentRequired,
    this.healthPackageTypes,
    this.isHealthPackage,
  });

  factory LucidTest.fromJson(Map<String, dynamic> json) => LucidTest(
        serviceCd: json['serviceCd'] as String?,
        serviceName: json['serviceName'] as String?,
        image: json['image'] as String?,
        finalMrp: json['finalMrp'] as num?,
        discount: json['discount'] as num?,
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
        'hv': hv,
        'isAppointmentRequired': isAppointmentRequired,
        'healthPackageTypes': healthPackageTypes,
        'isHealthPackage': isHealthPackage,
      };
}
