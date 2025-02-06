// To parse this JSON data, do
//
//     final quickSuppliersModel = quickSuppliersModelFromJson(jsonString);

import 'dart:convert';

QuickSuppliersModel quickSuppliersModelFromJson(String str) =>
    QuickSuppliersModel.fromJson(json.decode(str));

String quickSuppliersModelToJson(QuickSuppliersModel data) =>
    json.encode(data.toJson());

class QuickSuppliersModel {
  String? storeId;
  String? storeName;
  String? storeAddress;
  String? storeLandMark;
  String? storeCategory;
  String? gstNumber;
  String? dlNumber;
  String? storeOpenTime;
  String? storeCloseTime;
  num? distance;

  QuickSuppliersModel({
    this.storeId,
    this.storeName,
    this.storeAddress,
    this.storeLandMark,
    this.storeCategory,
    this.gstNumber,
    this.dlNumber,
    this.distance,
    this.storeCloseTime,
    this.storeOpenTime,
  });

  factory QuickSuppliersModel.fromJson(Map<String, dynamic> json) =>
      QuickSuppliersModel(
        storeId: json["storeId"],
        storeName: json["storeName"],
        storeAddress: json["storeAddress"],
        storeLandMark: json["storeLandMark"],
        storeCategory: json["storeCategory"],
        gstNumber: json["gstNumber"],
        dlNumber: json["dlNumber"],
        distance: json["distance"],
        storeCloseTime: json["storeCloseTime"],
        storeOpenTime: json["storeOpenTime"],
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "storeName": storeName,
        "storeAddress": storeAddress,
        "storeLandMark": storeLandMark,
        "storeCategory": storeCategory,
        "gstNumber": gstNumber,
        "dlNumber": dlNumber,
        "distance": distance,
        "storeCloseTime": storeCloseTime,
        "storeOpenTime": storeOpenTime,
      };
}
