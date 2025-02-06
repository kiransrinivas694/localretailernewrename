import 'dart:convert';

FindLocationModel findLocationModelFromJson(String str) =>
    FindLocationModel.fromJson(json.decode(str));

String findLocationModelToJson(FindLocationModel data) =>
    json.encode(data.toJson());

class FindLocationModel {
  bool? status;
  String? message;
  List<BasicLocationModel>? data;
  dynamic token;

  FindLocationModel({this.status, this.message, this.data, this.token});

  factory FindLocationModel.fromJson(Map<String, dynamic> json) {
    return FindLocationModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BasicLocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      token: json['token'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'token': token,
      };
}

class BasicLocationModel {
  String? id;
  String? organizationId;
  String? branchName;
  String? lucidBranchId;
  dynamic distance;
  String? contactNumber;
  String? email;
  String? location;
  String? lattitude;
  String? logittude;
  String? image;
  dynamic openigTime;
  dynamic closingTime;

  BasicLocationModel({
    this.id,
    this.organizationId,
    this.branchName,
    this.lucidBranchId,
    this.distance,
    this.contactNumber,
    this.email,
    this.location,
    this.lattitude,
    this.logittude,
    this.image,
    this.openigTime,
    this.closingTime,
  });

  factory BasicLocationModel.fromJson(Map<String, dynamic> json) =>
      BasicLocationModel(
        id: json['id'] as String?,
        organizationId: json['organizationId'] as String?,
        branchName: json['branchName'] as String?,
        lucidBranchId: json['lucidBranchId'] as String?,
        distance: json['distance'] as dynamic,
        contactNumber: json['contactNumber'] as String?,
        email: json['email'] as String?,
        location: json['location'] as String?,
        lattitude: json["lattitude"] as String?,
        logittude: json["logittude"] as String?,
        image: json["image"] as String?,
        openigTime: json['openigTime'] as dynamic,
        closingTime: json['closingTime'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'branchName': branchName,
        'lucidBranchId': lucidBranchId,
        'distance': distance,
        'contactNumber': contactNumber,
        'email': email,
        'location': location,
        "lattitude": lattitude,
        "logittude": logittude,
        "image": image,
        'openigTime': openigTime,
        'closingTime': closingTime,
      };
}
