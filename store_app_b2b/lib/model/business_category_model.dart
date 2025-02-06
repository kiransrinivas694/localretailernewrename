import 'dart:convert';

class BusinessCategoryModel {
  BusinessCategoryModel({
    this.categoryId,
    this.categoryName,
    this.imageId,
    this.isEnabled,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.imgBgColor,
    this.imgFrontColor,
    this.labelColor,
    this.menulableColor,
  });

  String? categoryId;
  String? categoryName;
  String? imageId;
  String? isEnabled;
  String? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? imgBgColor;
  String? imgFrontColor;
  String? labelColor;
  String? menulableColor;

  factory BusinessCategoryModel.fromJson(Map<String, dynamic> json) =>
      BusinessCategoryModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        imageId: json["imageId"],
        isEnabled: json["isEnabled"],
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        imgBgColor: json["imgBgColor"],
        imgFrontColor: json["imgFrontColor"],
        labelColor: json["labelColor"],
        menulableColor: json["menulableColor"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "imageId": imageId,
        "isEnabled": isEnabled,
        "isActive": isActive,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "imgBgColor": imgBgColor,
        "imgFrontColor": imgFrontColor,
        "labelColor": labelColor,
        "menulableColor": menulableColor,
      };
}
