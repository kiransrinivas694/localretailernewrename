import 'dart:convert';

TopBuyingProductModel topBuyingProductModelFromJson(String str) =>
    TopBuyingProductModel.fromJson(json.decode(str));

String topBuyingProductModelToJson(TopBuyingProductModel data) =>
    json.encode(data.toJson());

class TopBuyingProductModel {
  String? userId;
  String? productId;
  String? productName;
  String? skuCode;
  num? finalQuantity;

  TopBuyingProductModel({
    this.userId,
    this.productId,
    this.productName,
    this.skuCode,
    this.finalQuantity,
  });

  factory TopBuyingProductModel.fromJson(Map<String, dynamic> json) {
    return TopBuyingProductModel(
      userId: json['userId'],
      productId: json['productId'],
      productName: json['productName'],
      skuCode: json['skuCode'],
      finalQuantity: json['finalQuantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'productId': productId,
        'productName': productName,
        'skuCode': skuCode,
        'finalQuantity': finalQuantity,
      };
}
