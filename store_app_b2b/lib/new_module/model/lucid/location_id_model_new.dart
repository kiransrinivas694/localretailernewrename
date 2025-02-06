import 'dart:convert';

LocationIdModel locationIdModelFromJson(String str) =>
    LocationIdModel.fromJson(json.decode(str));

String locationIdModelToJson(LocationIdModel data) =>
    json.encode(data.toJson());

class LocationIdModel {
  bool? status;
  String? message;
  LocationId? data;
  dynamic token;

  LocationIdModel({this.status, this.message, this.data, this.token});

  factory LocationIdModel.fromJson(Map<String, dynamic> json) {
    return LocationIdModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LocationId.fromJson(json['data'] as Map<String, dynamic>),
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

class LocationId {
  String? id;
  String? organizationId;
  String? branchName;
  String? lucidBranchId;
  dynamic distance;
  String? contactNumber;
  String? email;
  String? location;
  String? image;
  String? openingTime;
  String? closingTime;

  LocationId({
    this.id,
    this.organizationId,
    this.branchName,
    this.lucidBranchId,
    this.distance,
    this.contactNumber,
    this.email,
    this.location,
    this.image,
    this.openingTime,
    this.closingTime,
  });

  factory LocationId.fromJson(Map<String, dynamic> json) => LocationId(
        id: json['id'] as String?,
        organizationId: json['organizationId'] as String?,
        branchName: json['branchName'] as String?,
        lucidBranchId: json['lucidBranchId'] as String?,
        distance: json['distance'] as dynamic,
        contactNumber: json['contactNumber'] as String?,
        email: json['email'] as String?,
        location: json['location'] as String?,
        image: json['image'] as String?,
        openingTime:
            json['openingTime'] == null ? "" : json['openingTime'] as String,
        closingTime:
            json['closingTime'] == null ? "" : json['closingTime'] as String,
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
        'image': image,
        'openingTime': openingTime,
        'closingTime': closingTime,
      };
}
