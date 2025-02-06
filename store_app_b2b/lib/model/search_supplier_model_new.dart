import 'dart:convert';

List<SearchSupplier> searchSupplierFromJson(String str) =>
    List<SearchSupplier>.from(
        json.decode(str).map((x) => SearchSupplier.fromJson(x)));

String searchSupplierToJson(List<SearchSupplier> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchSupplier {
  String? id;
  String? productName;
  String? manufacturer;
  String? weight;
  String? storeId;
  String? storeName;
  String? specs;
  String? address;
  String? skuCode;
  String? skuId;
  int? discount;
  num? ptr;
  num? mrp;
  String? discountType;
  dynamic discountPercent;
  num? freeQuantity;
  num? finalQuantity;
  num? buyPurchaseQuantity;
  num? price;
  String? schemeName;
  String? stockAvailable;
  String? schemeId;
  bool? schemeAvailable;

  SearchSupplier({
    this.id,
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
    this.stockAvailable,
    this.schemeAvailable,
    this.schemeId,
    this.finalQuantity,
    this.specs,
  });

  factory SearchSupplier.fromJson(Map<String, dynamic> json) => SearchSupplier(
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
        finalQuantity: json["finalQuantity"],
        specs: json["specs"],
      );

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
        "finalQuantity": finalQuantity,
        "specs": specs
      };
}
