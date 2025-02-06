import 'dart:convert';

List<CartCountModel> cartCountModelFromJson(String str) =>
    List<CartCountModel>.from(
        json.decode(str).map((x) => CartCountModel.fromJson(x)));

String cartCountModelModelToJson(List<CartCountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartCountModel {
  String? productId;
  String? productName;
  num? quantity;

  CartCountModel({this.productId, this.productName, this.quantity});

  factory CartCountModel.fromJson(Map<String, dynamic> json) {
    return CartCountModel(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      quantity: json['quantity'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
      };
}
