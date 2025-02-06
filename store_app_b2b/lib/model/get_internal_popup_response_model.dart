// To parse this JSON data, do
//
//     final getInternalPopUpResponseModel = getInternalPopUpResponseModelFromJson(jsonString);

import 'dart:convert';

GetInternalPopUpResponseModel getInternalPopUpResponseModelFromJson(
        String str) =>
    GetInternalPopUpResponseModel.fromJson(json.decode(str));

String getInternalPopUpResponseModelToJson(
        GetInternalPopUpResponseModel data) =>
    json.encode(data.toJson());

class GetInternalPopUpResponseModel {
  String? id;
  String? orderId;
  String? messageType;
  String? title;
  String? message;
  String? isApproved;
  String? imageId;
  dynamic imageUrLs;
  DateTime? createdAt;
  String? isActive;
  String? storeId;
  String? userId;
  String? publicAlert;
  dynamic bgColor;
  String? userViewd;
  String? userResponse;
  String? orderDate;
  num? orderAmount;

  GetInternalPopUpResponseModel(
      {this.id,
      this.orderId,
      this.messageType,
      this.title,
      this.message,
      this.isApproved,
      this.imageId,
      this.imageUrLs,
      this.createdAt,
      this.isActive,
      this.storeId,
      this.userId,
      this.publicAlert,
      this.bgColor,
      this.userViewd,
      this.userResponse,
      this.orderDate,
      this.orderAmount});

  factory GetInternalPopUpResponseModel.fromJson(Map<String, dynamic> json) =>
      GetInternalPopUpResponseModel(
          id: json["id"],
          orderId: json["orderId"],
          messageType: json["messageType"],
          title: json["title"],
          message: json["message"],
          isApproved: json["isApproved"],
          imageId: json["imageId"],
          imageUrLs: json["imageURLs"],
          createdAt: DateTime.parse(json["createdAt"]),
          isActive: json["isActive"],
          storeId: json["storeId"],
          userId: json["userId"],
          publicAlert: json["publicAlert"],
          bgColor: json["bgColor"],
          userViewd: json["userViewd"],
          userResponse: json["userResponse"],
          orderDate: json["orderDate"],
          orderAmount: json["orderAmount"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "messageType": messageType,
        "title": title,
        "message": message,
        "isApproved": isApproved,
        "imageId": imageId,
        "imageURLs": imageUrLs,
        "createdAt": createdAt!.toIso8601String(),
        "isActive": isActive,
        "storeId": storeId,
        "userId": userId,
        "publicAlert": publicAlert,
        "bgColor": bgColor,
        "userViewd": userViewd,
        "userResponse": userResponse,
        "orderDate": orderDate,
        "orderAmount": orderAmount,
      };
}
