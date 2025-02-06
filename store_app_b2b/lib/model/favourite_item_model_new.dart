// To parse this JSON data, do
//
//     final favouriteItemModel = favouriteItemModelFromJson(jsonString);

import 'dart:convert';

List<FavouriteItemModel> favouriteItemModelFromJson(String str) =>
    List<FavouriteItemModel>.from(
        json.decode(str).map((x) => FavouriteItemModel.fromJson(x)));

String favouriteItemModelToJson(List<FavouriteItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavouriteItemModel {
  String? id;
  String? userId;
  String? favName;
  List<FavList> favList;
  String? createdDt;
  num? itemsCount;
  num? storesCount;
  num? draftValue;

  FavouriteItemModel({
    this.id,
    this.userId,
    this.favName,
    this.favList = const <FavList>[],
    this.createdDt,
    this.itemsCount,
    this.storesCount,
    this.draftValue,
  });

  factory FavouriteItemModel.fromJson(Map<String, dynamic> json) =>
      FavouriteItemModel(
        id: json["id"],
        userId: json["userId"],
        favName: json["favName"],
        favList: json["favList"] == null
            ? []
            : List<FavList>.from(
                json["favList"]!.map((x) => FavList.fromJson(x))),
        createdDt: json["createdDt"],
        itemsCount: json["itemsCount"],
        storesCount: json["storesCount"],
        draftValue: json["draftValue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "favName": favName,
        "favList": List<dynamic>.from(favList.map((x) => x.toJson())),
        "createdDt": createdDt,
        "itemsCount": itemsCount,
        "storesCount": storesCount,
        "draftValue": draftValue,
      };
}

class FavList {
  List<Item> items;

  FavList({
    this.items = const <Item>[],
  });

  factory FavList.fromJson(Map<String, dynamic> json) => FavList(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String? id;
  String? productId;
  String? productName;
  String? storeName;
  String? storeId;
  num? quantity;
  dynamic stockAvilable;
  num? freeQuanity;
  String? schemeName;
  double? mrp;
  double? ptr;
  dynamic totalValue;
  dynamic benifitValue;
  dynamic gst;
  dynamic cgst;
  dynamic sgst;
  String? skuId;
  dynamic skuCode;
  String? manufacturer;
  dynamic hsn;

  Item({
    this.id,
    this.productId,
    this.productName,
    this.storeName,
    this.storeId,
    this.quantity,
    this.stockAvilable,
    this.freeQuanity,
    this.schemeName,
    this.mrp,
    this.ptr,
    this.totalValue,
    this.benifitValue,
    this.gst,
    this.cgst,
    this.sgst,
    this.skuId,
    this.skuCode,
    this.manufacturer,
    this.hsn,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        productId: json["productId"],
        productName: json["productName"],
        storeName: json["storeName"],
        storeId: json["storeId"],
        quantity: json["quantity"],
        stockAvilable: json["stockAvilable"],
        freeQuanity: json["freeQuanity"],
        schemeName: json["schemeName"],
        mrp: json["mrp"]?.toDouble(),
        ptr: json["ptr"]?.toDouble(),
        totalValue: json["totalValue"],
        benifitValue: json["benifitValue"],
        gst: json["gst"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        skuId: json["skuId"],
        skuCode: json["skuCode"],
        manufacturer: json["manufacturer"],
        hsn: json["hsn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productName": productName,
        "storeName": storeName,
        "storeId": storeId,
        "quantity": quantity,
        "stockAvilable": stockAvilable,
        "freeQuanity": freeQuanity,
        "schemeName": schemeName,
        "mrp": mrp,
        "ptr": ptr,
        "totalValue": totalValue,
        "benifitValue": benifitValue,
        "gst": gst,
        "cgst": cgst,
        "sgst": sgst,
        "skuId": skuId,
        "skuCode": skuCode,
        "manufacturer": manufacturer,
        "hsn": hsn,
      };
}
