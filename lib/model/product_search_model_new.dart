import 'dart:convert';

List<ProductSearchModel> productSearchModelFromJson(String str) =>
    List<ProductSearchModel>.from(
        json.decode(str).map((x) => ProductSearchModel.fromJson(x)));

String productSearchModelToJson(List<ProductSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ProductResult productResultFromJson(String str) =>
    ProductResult.fromJson(json.decode(str));

class ProductSearchModel {
  String? id;
  String? productName;
  String? productSearch;
  String? categoryId;
  String? category;

  ProductSearchModel({
    this.id,
    this.productName,
    this.productSearch,
    this.categoryId,
    this.category,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) =>
      ProductSearchModel(
        id: json["id"],
        productName: json["productName"],
        productSearch: json["productSearch"],
        categoryId: json["categoryId"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "productSearch": productSearch,
        "categoryId": categoryId,
        "category": category
      };
}

class ProductResult {
  String? name;
  String? manufacturer;
  String? description;

  ProductResult({
    this.name,
    this.manufacturer,
    this.description,
  });

  factory ProductResult.fromJson(Map<String, dynamic> json) => ProductResult(
        name: json["productName"],
        manufacturer: json["manufacturer"],
        description: json["productDescription"],
      );

  Map<String, dynamic> toJson() => {
        "productName": name,
        "manufacturer": manufacturer,
        "productDescription": description,
      };
}
