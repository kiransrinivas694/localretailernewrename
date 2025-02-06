import 'dart:convert';

StoreCategoryModel storeCategoryModelFromJson(String str) =>
    StoreCategoryModel.fromJson(json.decode(str));

String storeCategoryModelToJson(StoreCategoryModel data) =>
    json.encode(data.toJson());

class StoreCategoryModel {
  String? categoryId;
  String? categoryName;
  String? imgUrl;
  String? medicalCategory;

  StoreCategoryModel({
    this.categoryId,
    this.categoryName,
    this.imgUrl,
    this.medicalCategory,
  });

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryModel(
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      imgUrl: json['imgURL'] as String?,
      medicalCategory: json['medicalCategory'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'imgURL': imgUrl,
        'medicalCategory': medicalCategory,
      };
}
