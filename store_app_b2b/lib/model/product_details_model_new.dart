// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  String? id;
  String? productName;
  String? specs;
  String? manufacturer;
  String? productDescription;
  String? category;
  String? categoryId;
  String? subCategoryId;
  String? subCategory;
  String? note;
  String? storeName;
  dynamic benefits;
  num? priceWithGst;
  List<ImageId> imageIds;
  dynamic alternative;
  dynamic weight;
  dynamic dimentions;
  String? brandName;
  dynamic brandId;
  num price;
  dynamic quantity;
  num? discount;
  num? pricePtr;
  num? ptr;
  String? isActive;
  dynamic priceIsActive;
  num? priceMrp;
  num? mrp;
  String? discountType;
  dynamic startDate;
  dynamic endDate;
  String? isEnabled;
  dynamic sideEffects;
  dynamic howToUse;
  String? productSearch;
  String? isApproved;
  String? medicneType;
  dynamic tabletsPerStrip;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  dynamic updatedBy;
  String? sku;
  dynamic gst;
  dynamic cgst;
  dynamic sgst;
  dynamic packingType;
  String? hsn;
  String? proudctRequestBy;
  String? medicalProudct;
  num? finalPrice;
  dynamic brandNameLogo;
  String? proudctThumbnail;
  String? productSearchWithoutSpaces;
  String? parentProductId;
  String? margProductId;
  String? rid;
  String? stockAvailable;
  bool? prescriptionIsRequired;
  num? maxOrderQuantity;

  ProductDetailsModel({
    this.id,
    this.productName,
    this.specs,
    this.manufacturer,
    this.productDescription,
    this.category,
    this.categoryId,
    this.subCategoryId,
    this.subCategory,
    this.note,
    this.benefits,
    this.priceWithGst,
    this.imageIds = const <ImageId>[],
    this.alternative,
    this.weight,
    this.dimentions,
    this.brandName,
    this.brandId,
    this.price = 0,
    this.quantity,
    this.discount,
    this.pricePtr,
    this.isActive,
    this.priceMrp,
    this.discountType,
    this.startDate,
    this.endDate,
    this.isEnabled,
    this.sideEffects,
    this.howToUse,
    this.maxOrderQuantity,
    this.productSearch,
    this.isApproved,
    this.medicneType,
    this.tabletsPerStrip,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.sku,
    this.gst,
    this.cgst,
    this.sgst,
    this.packingType,
    this.hsn,
    this.proudctRequestBy,
    this.medicalProudct,
    this.finalPrice,
    this.brandNameLogo,
    this.proudctThumbnail,
    this.productSearchWithoutSpaces,
    this.parentProductId,
    this.margProductId,
    this.rid,
    this.prescriptionIsRequired = false,
    this.priceIsActive,
    this.ptr,
    this.mrp,
    this.stockAvailable,
    this.storeName,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        id: json["id"],
        productName: json["productName"],
        specs: json["specs"],
        manufacturer: json["manufacturer"],
        productDescription: json["productDescription"],
        category: json["category"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
        subCategory: json["subCategory"],
        priceIsActive: json["priceIsActive"],
        note: json["note"],
        benefits: json["benefits"],
        priceWithGst: json["priceWithGst"],
        imageIds: List<ImageId>.from(
            json["imageIds"].map((x) => ImageId.fromJson(x))),
        alternative: json["alternative"],
        weight: json["weight"],
        maxOrderQuantity: json['maxOrderQuantity'],
        dimentions: json["dimentions"],
        brandName: json["brandName"],
        brandId: json["brandId"],
        price: json["price"]?.tonum(),
        quantity: json["quantity"],
        discount: json["discount"],
        pricePtr: json["ptr"]?.tonum(),
        isActive: json["isActive"],
        priceMrp: json["mrp"]?.tonum(),
        discountType: json["discountType"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        isEnabled: json["isEnabled"],
        sideEffects: json["sideEffects"],
        howToUse: json["howToUse"],
        productSearch: json["productSearch"],
        isApproved: json["isApproved"],
        medicneType: json["medicneType"],
        tabletsPerStrip: json["tabletsPerStrip"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        sku: json["sku"],
        gst: json["gst"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        packingType: json["packingType"],
        hsn: json["hsn"],
        proudctRequestBy: json["proudctRequestBy"],
        medicalProudct: json["medicalProudct"],
        finalPrice: json["finalPrice"]?.tonum(),
        brandNameLogo: json["brandNameLogo"],
        proudctThumbnail: json["proudctThumbnail"],
        productSearchWithoutSpaces: json["productSearchWithoutSpaces"],
        parentProductId: json["parentProductId"],
        margProductId: json["margProductId"],
        rid: json["rid"],
        prescriptionIsRequired: json["prescriptionIsRequired"],
        ptr: json['ptr'],
        mrp: json['mrp'],
        stockAvailable: json["stockAvailable"],
        storeName: json['storeName'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "specs": specs,
        "manufacturer": manufacturer,
        "productDescription": productDescription,
        "category": category,
        'maxOrderQuantity': maxOrderQuantity,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "subCategory": subCategory,
        "note": note,
        "priceWithGst": priceWithGst,
        "benefits": benefits,
        "priceIsActive": priceIsActive,
        "imageIds": List<dynamic>.from(imageIds.map((x) => x.toJson())),
        "alternative": alternative,
        "weight": weight,
        "dimentions": dimentions,
        "brandName": brandName,
        "brandId": brandId,
        "price": price,
        "quantity": quantity,
        "discount": discount,
        "ptr": pricePtr,
        "isActive": isActive,
        "mrp": priceMrp,
        "discountType": discountType,
        "startDate": startDate,
        "endDate": endDate,
        "isEnabled": isEnabled,
        "sideEffects": sideEffects,
        "howToUse": howToUse,
        "productSearch": productSearch,
        "isApproved": isApproved,
        "medicneType": medicneType,
        "tabletsPerStrip": tabletsPerStrip,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "sku": sku,
        "gst": gst,
        "cgst": cgst,
        "sgst": sgst,
        "packingType": packingType,
        "hsn": hsn,
        "proudctRequestBy": proudctRequestBy,
        "medicalProudct": medicalProudct,
        "finalPrice": finalPrice,
        "brandNameLogo": brandNameLogo,
        "proudctThumbnail": proudctThumbnail,
        "productSearchWithoutSpaces": productSearchWithoutSpaces,
        "parentProductId": parentProductId,
        "margProductId": margProductId,
        "rid": rid,
        "prescriptionIsRequired": prescriptionIsRequired,
        "pricePtr": ptr,
        "priceMrp": priceMrp,
        "stockAvailable": stockAvailable,
        "storeName": storeName,
      };
}

class ImageId {
  num? displayOrder;
  String? imageId;
  String? enable;
  String? delete;

  ImageId({
    this.displayOrder,
    this.imageId,
    this.enable,
    this.delete,
  });

  factory ImageId.fromJson(Map<String, dynamic> json) => ImageId(
        displayOrder: json["displayOrder"],
        imageId: json["imageId"],
        enable: json["enable"],
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "displayOrder": displayOrder,
        "imageId": imageId,
        "enable": enable,
        "delete": delete,
      };
}
