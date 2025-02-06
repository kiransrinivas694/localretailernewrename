import 'dart:convert';

List<SearchProducts> searchProductsFromJson(String str) =>
    List<SearchProducts>.from(
        json.decode(str).map((x) => SearchProducts.fromJson(x)));

String searchProductsToJson(List<SearchProducts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchProducts {
  String? id;
  String? productName;
  String? manufacturer;
  String? weight;
  String? storeId;
  String? storeName;
  String? address;
  String? skuCode;
  String? skuId;
  String? specs;
  num? discount;
  num? ptr;
  num? mrp;
  String? discountType;
  dynamic discountPercent;
  num? freeQuantity;
  num? buyPurchaseQuantity;
  num? maxOrderQuantity;
  num? finalQty;
  num? price;
  String? schemeName;
  String? schemeId;
  String? stockAvailable;
  bool schemeAvailable;
  num? quantityAvailable;
  num? priceWithGst;

  SearchProducts(
      {this.id,
      this.productName,
      this.manufacturer,
      this.weight,
      this.storeId,
      this.storeName,
      this.address,
      this.skuCode,
      this.skuId,
      this.discount,
      this.ptr,
      this.mrp,
      this.discountType,
      this.discountPercent,
      this.freeQuantity,
      this.buyPurchaseQuantity,
      this.price,
      this.schemeName,
      this.finalQty,
      this.schemeAvailable = false,
      this.stockAvailable,
      this.schemeId,
      this.specs,
      this.maxOrderQuantity,
      this.priceWithGst,
      this.quantityAvailable});

  factory SearchProducts.fromJson(Map<String, dynamic> json) => SearchProducts(
      id: json["id"],
      productName: json["productName"],
      manufacturer: json["manufacturer"],
      weight: json["weight"],
      storeId: json["storeId"],
      storeName: json["storeName"],
      address: json["address"],
      skuCode: json["skuCode"],
      skuId: json["skuId"],
      discount: json["discount"],
      ptr: json["ptr"],
      mrp: json["mrp"],
      discountType: json["discountType"],
      discountPercent: json["discountPercent"],
      freeQuantity: json["freeQuantity"],
      buyPurchaseQuantity: json["buyPurchaseQuantity"],
      price: json["price"],
      schemeName: json["schemeName"],
      stockAvailable: json["stockAvailable"],
      schemeAvailable: json["schemeAvailable"],
      schemeId: json["schemeId"],
      finalQty: json["finalQuantity"],
      specs: json["specs"],
      maxOrderQuantity: json['maxOrderQuantity'],
      priceWithGst: json["priceWithGst"],
      quantityAvailable: json["quantityAvailable"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "manufacturer": manufacturer,
        "weight": weight,
        "storeId": storeId,
        "storeName": storeName,
        "address": address,
        "skuCode": skuCode,
        "skuId": skuId,
        "discount": discount,
        "ptr": ptr,
        "mrp": mrp,
        "discountType": discountType,
        "discountPercent": discountPercent,
        "freeQuantity": freeQuantity,
        "buyPurchaseQuantity": buyPurchaseQuantity,
        "price": price,
        "schemeName": schemeName,
        "stockAvailable": stockAvailable,
        "schemeAvailable": schemeAvailable,
        "schemeId": schemeId,
        "finalQuantity": finalQty,
        "specs": specs,
        "priceWithGst": priceWithGst,
        'maxOrderQuantity': maxOrderQuantity,
        "quantityAvailable": quantityAvailable
      };
}
