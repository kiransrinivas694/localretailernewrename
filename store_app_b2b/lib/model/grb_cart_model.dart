import 'dart:convert';

GrbCartModel grbCartModelFromJson(String str) =>
    GrbCartModel.fromJson(json.decode(str));

String grbCartModelToJson(GrbCartModel data) => json.encode(data.toJson());

class GrbCartModel {
  String? id;
  dynamic usedRewards;
  dynamic usedCashBack;
  String? createdAt;
  String? userId;
  String? userName;
  String? mobileNumber;
  GstRetailer? gstRetailer;
  dynamic storeLicenseRetailer;
  DrugLicenseRetailer? drugLicenseRetailer;
  GstSupplier? gstSupplier;
  dynamic storeLicenseSupplier;
  DrugLicenseSupplier? drugLicenseSupplier;
  num? orderTotalValue;
  dynamic paidAmount;
  double? orderValue;
  double? orderValueAferDiscount;
  String? storeId;
  List<GrbItem>? items;
  num? deliveryCharges;
  num? serviceCharges;
  num? tax;
  dynamic couponInfo;
  dynamic discounts;
  String? paymentMode;
  PickupAddress? pickupAddress;
  DeliveryAddress? deliveryAddress;
  String? deliveryDate;
  String? slot;
  String? isExpressDelivery;
  String? riderId;
  String? orderAssignedStatus;
  String? deliveryStatus;
  String? riderOrderAcceptStatus;
  String? isPickedfromStore;
  String? atLocation;
  String? orderEventStatus;
  String? orderStatus;
  String? orderEventId;
  String? storeName;
  String? storeImageUrl;
  DateTime? orderCreatedDate;
  DateTime? orderUpdatedDate;
  DateTime? orderAssignedDate;
  DateTime? orderDelivaryDate;
  bool? prescVerified;
  bool? prescAdded;
  bool? prescIsExistingCutomer;
  dynamic rewardPonums;
  DateTime? validTillDate;
  dynamic prescImgs;
  bool? consultDoctor;
  String? paymentTrasactionId;
  dynamic categoryId;
  dynamic categoryName;
  dynamic subCategoryId;
  dynamic subCategoryName;
  num? orderAcceptedValue;
  num? orderRefundValue;
  String? refundStatus;
  DateTime? refundDate;
  String? fcmToken;
  String? riderPhoneNumber;
  dynamic riderStatusMessage;
  String? riderImgUrl;
  String? riderName;
  num? serviceChargesPercentage;
  dynamic specialInstruction;
  dynamic anySpecialInstruction;
  dynamic orderValueAfterDiscount;
  double? totalGstAmount;
  double? totalCgstAmount;
  double? totalSgstAmount;
  dynamic discountAmount;
  dynamic margOrderStatus;
  dynamic margOrderNumber;
  dynamic margBillNumber;
  String? unListedOrder;
  String? invoiceDownloadUrl;
  String? billed;
  String? packed;
  dynamic billAmount;
  String? salesManId;
  String? salesManContactNumber;
  String? salesManName;
  String? orderReceived;
  dynamic billedItems;
  String? salesManFcmToken;
  dynamic consultationCompleted;
  String? numerStateBilling;
  dynamic orderRejectReason;

  GrbCartModel({
    this.id,
    this.usedRewards,
    this.usedCashBack,
    this.createdAt,
    this.userId,
    this.userName,
    this.mobileNumber,
    this.gstRetailer,
    this.storeLicenseRetailer,
    this.drugLicenseRetailer,
    this.gstSupplier,
    this.storeLicenseSupplier,
    this.drugLicenseSupplier,
    this.orderTotalValue,
    this.paidAmount,
    this.orderValue,
    this.orderValueAferDiscount,
    this.storeId,
    this.items,
    this.deliveryCharges,
    this.serviceCharges,
    this.tax,
    this.couponInfo,
    this.discounts,
    this.paymentMode,
    this.pickupAddress,
    this.deliveryAddress,
    this.deliveryDate,
    this.slot,
    this.isExpressDelivery,
    this.riderId,
    this.orderAssignedStatus,
    this.deliveryStatus,
    this.riderOrderAcceptStatus,
    this.isPickedfromStore,
    this.atLocation,
    this.orderEventStatus,
    this.orderStatus,
    this.orderEventId,
    this.storeName,
    this.storeImageUrl,
    this.orderCreatedDate,
    this.orderUpdatedDate,
    this.orderAssignedDate,
    this.orderDelivaryDate,
    this.prescVerified,
    this.prescAdded,
    this.prescIsExistingCutomer,
    this.rewardPonums,
    this.validTillDate,
    this.prescImgs,
    this.consultDoctor,
    this.paymentTrasactionId,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.orderAcceptedValue,
    this.orderRefundValue,
    this.refundStatus,
    this.refundDate,
    this.fcmToken,
    this.riderPhoneNumber,
    this.riderStatusMessage,
    this.riderImgUrl,
    this.riderName,
    this.serviceChargesPercentage,
    this.specialInstruction,
    this.anySpecialInstruction,
    this.orderValueAfterDiscount,
    this.totalGstAmount,
    this.totalCgstAmount,
    this.totalSgstAmount,
    this.discountAmount,
    this.margOrderStatus,
    this.margOrderNumber,
    this.margBillNumber,
    this.unListedOrder,
    this.invoiceDownloadUrl,
    this.billed,
    this.packed,
    this.billAmount,
    this.salesManId,
    this.salesManContactNumber,
    this.salesManName,
    this.orderReceived,
    this.billedItems,
    this.salesManFcmToken,
    this.consultationCompleted,
    this.numerStateBilling,
    this.orderRejectReason,
  });

  factory GrbCartModel.fromJson(Map<String, dynamic> json) => GrbCartModel(
        id: json['id'] as String?,
        usedRewards: json['usedRewards'] as dynamic,
        usedCashBack: json['usedCashBack'] as dynamic,
        createdAt: json['createdAt'] as String?,
        userId: json['userId'] as String?,
        userName: json['userName'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        gstRetailer: json['gstRetailer'] == null
            ? null
            : GstRetailer.fromJson(json['gstRetailer'] as Map<String, dynamic>),
        storeLicenseRetailer: json['storeLicenseRetailer'] as dynamic,
        drugLicenseRetailer: json['drugLicenseRetailer'] == null
            ? null
            : DrugLicenseRetailer.fromJson(
                json['drugLicenseRetailer'] as Map<String, dynamic>),
        gstSupplier: json['gstSupplier'] == null
            ? null
            : GstSupplier.fromJson(json['gstSupplier'] as Map<String, dynamic>),
        storeLicenseSupplier: json['storeLicenseSupplier'] as dynamic,
        drugLicenseSupplier: json['drugLicenseSupplier'] == null
            ? null
            : DrugLicenseSupplier.fromJson(
                json['drugLicenseSupplier'] as Map<String, dynamic>),
        orderTotalValue: json['orderTotalValue'] as num?,
        paidAmount: json['paidAmount'] as dynamic,
        orderValue: (json['orderValue'] as num?)?.toDouble(),
        orderValueAferDiscount:
            (json['orderValueAferDiscount'] as num?)?.toDouble(),
        storeId: json['storeId'] as String?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => GrbItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        deliveryCharges: json['deliveryCharges'] as num?,
        serviceCharges: json['serviceCharges'] as num?,
        tax: json['tax'] as num?,
        couponInfo: json['couponInfo'] as dynamic,
        discounts: json['discounts'] as dynamic,
        paymentMode: json['paymentMode'] as String?,
        pickupAddress: json['pickupAddress'] == null
            ? null
            : PickupAddress.fromJson(
                json['pickupAddress'] as Map<String, dynamic>),
        deliveryAddress: json['deliveryAddress'] == null
            ? null
            : DeliveryAddress.fromJson(
                json['deliveryAddress'] as Map<String, dynamic>),
        deliveryDate: json['deliveryDate'] as String?,
        slot: json['slot'] as String?,
        isExpressDelivery: json['isExpressDelivery'] as String?,
        riderId: json['riderId'] as String?,
        orderAssignedStatus: json['orderAssignedStatus'] as String?,
        deliveryStatus: json['deliveryStatus'] as String?,
        riderOrderAcceptStatus: json['riderOrderAcceptStatus'] as String?,
        isPickedfromStore: json['isPickedfromStore'] as String?,
        atLocation: json['atLocation'] as String?,
        orderEventStatus: json['orderEventStatus'] as String?,
        orderStatus: json['orderStatus'] as String?,
        orderEventId: json['orderEventId'] as String?,
        storeName: json['storeName'] as String?,
        storeImageUrl: json['storeImageURL'] as String?,
        orderCreatedDate: json['orderCreatedDate'] == null
            ? null
            : DateTime.parse(json['orderCreatedDate'] as String),
        orderUpdatedDate: json['orderUpdatedDate'] == null
            ? null
            : DateTime.parse(json['orderUpdatedDate'] as String),
        orderAssignedDate: json['orderAssignedDate'] == null
            ? null
            : DateTime.parse(json['orderAssignedDate'] as String),
        orderDelivaryDate: json['orderDelivaryDate'] == null
            ? null
            : DateTime.parse(json['orderDelivaryDate'] as String),
        prescVerified: json['prescVerified'] as bool?,
        prescAdded: json['prescAdded'] as bool?,
        prescIsExistingCutomer: json['prescIsExistingCutomer'] as bool?,
        rewardPonums: json['rewardPonums'] as dynamic,
        validTillDate: json['validTillDate'] == null
            ? null
            : DateTime.parse(json['validTillDate'] as String),
        prescImgs: json['prescImgs'] as dynamic,
        consultDoctor: json['consultDoctor'] as bool?,
        paymentTrasactionId: json['paymentTrasactionId'] as String?,
        categoryId: json['categoryId'] as dynamic,
        categoryName: json['categoryName'] as dynamic,
        subCategoryId: json['subCategoryId'] as dynamic,
        subCategoryName: json['subCategoryName'] as dynamic,
        orderAcceptedValue: json['orderAcceptedValue'] as num?,
        orderRefundValue: json['orderRefundValue'] as num?,
        refundStatus: json['refundStatus'] as String?,
        refundDate: json['refundDate'] == null
            ? null
            : DateTime.parse(json['refundDate'] as String),
        fcmToken: json['fcmToken'] as String?,
        riderPhoneNumber: json['riderPhoneNumber'] as String?,
        riderStatusMessage: json['riderStatusMessage'] as dynamic,
        riderImgUrl: json['riderImgURL'] as String?,
        riderName: json['riderName'] as String?,
        serviceChargesPercentage: json['serviceChargesPercentage'] as num?,
        specialInstruction: json['specialInstruction'] as dynamic,
        anySpecialInstruction: json['anySpecialInstruction'] as dynamic,
        orderValueAfterDiscount: json['orderValueAfterDiscount'] as dynamic,
        totalGstAmount: (json['totalGstAmount'] as num?)?.toDouble(),
        totalCgstAmount: (json['totalCgstAmount'] as num?)?.toDouble(),
        totalSgstAmount: (json['totalSgstAmount'] as num?)?.toDouble(),
        discountAmount: json['discountAmount'] as dynamic,
        margOrderStatus: json['margOrderStatus'] as dynamic,
        margOrderNumber: json['margOrderNumber'] as dynamic,
        margBillNumber: json['margBillNumber'] as dynamic,
        unListedOrder: json['unListedOrder'] as String?,
        invoiceDownloadUrl: json['invoiceDownloadURL'] as String?,
        billed: json['billed'] as String?,
        packed: json['packed'] as String?,
        billAmount: json['billAmount'] as dynamic,
        salesManId: json['salesManId'] as String?,
        salesManContactNumber: json['salesManContactNumber'] as String?,
        salesManName: json['salesManName'] as String?,
        orderReceived: json['orderReceived'] as String?,
        billedItems: json['billedItems'] as dynamic,
        salesManFcmToken: json['salesManFCMToken'] as String?,
        consultationCompleted: json['consultationCompleted'] as dynamic,
        numerStateBilling: json['numerStateBilling'] as String?,
        orderRejectReason: json['orderRejectReason'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'usedRewards': usedRewards,
        'usedCashBack': usedCashBack,
        'createdAt': createdAt,
        'userId': userId,
        'userName': userName,
        'mobileNumber': mobileNumber,
        'gstRetailer': gstRetailer?.toJson(),
        'storeLicenseRetailer': storeLicenseRetailer,
        'drugLicenseRetailer': drugLicenseRetailer?.toJson(),
        'gstSupplier': gstSupplier?.toJson(),
        'storeLicenseSupplier': storeLicenseSupplier,
        'drugLicenseSupplier': drugLicenseSupplier?.toJson(),
        'orderTotalValue': orderTotalValue,
        'paidAmount': paidAmount,
        'orderValue': orderValue,
        'orderValueAferDiscount': orderValueAferDiscount,
        'storeId': storeId,
        'items': items?.map((e) => e.toJson()).toList(),
        'deliveryCharges': deliveryCharges,
        'serviceCharges': serviceCharges,
        'tax': tax,
        'couponInfo': couponInfo,
        'discounts': discounts,
        'paymentMode': paymentMode,
        'pickupAddress': pickupAddress?.toJson(),
        'deliveryAddress': deliveryAddress?.toJson(),
        'deliveryDate': deliveryDate,
        'slot': slot,
        'isExpressDelivery': isExpressDelivery,
        'riderId': riderId,
        'orderAssignedStatus': orderAssignedStatus,
        'deliveryStatus': deliveryStatus,
        'riderOrderAcceptStatus': riderOrderAcceptStatus,
        'isPickedfromStore': isPickedfromStore,
        'atLocation': atLocation,
        'orderEventStatus': orderEventStatus,
        'orderStatus': orderStatus,
        'orderEventId': orderEventId,
        'storeName': storeName,
        'storeImageURL': storeImageUrl,
        'orderCreatedDate': orderCreatedDate?.toIso8601String(),
        'orderUpdatedDate': orderUpdatedDate?.toIso8601String(),
        'orderAssignedDate': orderAssignedDate?.toIso8601String(),
        'orderDelivaryDate': orderDelivaryDate?.toIso8601String(),
        'prescVerified': prescVerified,
        'prescAdded': prescAdded,
        'prescIsExistingCutomer': prescIsExistingCutomer,
        'rewardPonums': rewardPonums,
        'validTillDate': validTillDate?.toIso8601String(),
        'prescImgs': prescImgs,
        'consultDoctor': consultDoctor,
        'paymentTrasactionId': paymentTrasactionId,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'subCategoryId': subCategoryId,
        'subCategoryName': subCategoryName,
        'orderAcceptedValue': orderAcceptedValue,
        'orderRefundValue': orderRefundValue,
        'refundStatus': refundStatus,
        'refundDate': refundDate?.toIso8601String(),
        'fcmToken': fcmToken,
        'riderPhoneNumber': riderPhoneNumber,
        'riderStatusMessage': riderStatusMessage,
        'riderImgURL': riderImgUrl,
        'riderName': riderName,
        'serviceChargesPercentage': serviceChargesPercentage,
        'specialInstruction': specialInstruction,
        'anySpecialInstruction': anySpecialInstruction,
        'orderValueAfterDiscount': orderValueAfterDiscount,
        'totalGstAmount': totalGstAmount,
        'totalCgstAmount': totalCgstAmount,
        'totalSgstAmount': totalSgstAmount,
        'discountAmount': discountAmount,
        'margOrderStatus': margOrderStatus,
        'margOrderNumber': margOrderNumber,
        'margBillNumber': margBillNumber,
        'unListedOrder': unListedOrder,
        'invoiceDownloadURL': invoiceDownloadUrl,
        'billed': billed,
        'packed': packed,
        'billAmount': billAmount,
        'salesManId': salesManId,
        'salesManContactNumber': salesManContactNumber,
        'salesManName': salesManName,
        'orderReceived': orderReceived,
        'billedItems': billedItems,
        'salesManFCMToken': salesManFcmToken,
        'consultationCompleted': consultationCompleted,
        'numerStateBilling': numerStateBilling,
        'orderRejectReason': orderRejectReason,
      };
}

class DeliveryAddress {
  dynamic mobileNumber;
  dynamic addressType;
  dynamic addresslineMobileOne;
  dynamic addresslineMobileTwo;
  dynamic alterNateMobileNumber;
  dynamic emailId;
  dynamic pinCode;
  String? addressLine1;
  dynamic addressLine2;
  dynamic landMark;
  dynamic city;
  dynamic region;
  dynamic state;
  String? latitude;
  String? longitude;
  dynamic geoLocation;

  DeliveryAddress({
    this.mobileNumber,
    this.addressType,
    this.addresslineMobileOne,
    this.addresslineMobileTwo,
    this.alterNateMobileNumber,
    this.emailId,
    this.pinCode,
    this.addressLine1,
    this.addressLine2,
    this.landMark,
    this.city,
    this.region,
    this.state,
    this.latitude,
    this.longitude,
    this.geoLocation,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      mobileNumber: json['mobileNumber'] as dynamic,
      addressType: json['addressType'] as dynamic,
      addresslineMobileOne: json['addresslineMobileOne'] as dynamic,
      addresslineMobileTwo: json['addresslineMobileTwo'] as dynamic,
      alterNateMobileNumber: json['alterNateMobileNumber'] as dynamic,
      emailId: json['emailId'] as dynamic,
      pinCode: json['pinCode'] as dynamic,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as dynamic,
      landMark: json['landMark'] as dynamic,
      city: json['city'] as dynamic,
      region: json['region'] as dynamic,
      state: json['state'] as dynamic,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      geoLocation: json['geoLocation'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'addressType': addressType,
        'addresslineMobileOne': addresslineMobileOne,
        'addresslineMobileTwo': addresslineMobileTwo,
        'alterNateMobileNumber': alterNateMobileNumber,
        'emailId': emailId,
        'pinCode': pinCode,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'landMark': landMark,
        'city': city,
        'region': region,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'geoLocation': geoLocation,
      };
}

class DrugLicenseRetailer {
  String? drugLicenseNumber;
  String? documentId;
  String? expiryDate;

  DrugLicenseRetailer({
    this.drugLicenseNumber,
    this.documentId,
    this.expiryDate,
  });

  factory DrugLicenseRetailer.fromJson(Map<String, dynamic> json) {
    return DrugLicenseRetailer(
      drugLicenseNumber: json['drugLicenseNumber'] as String?,
      documentId: json['documentId'] as String?,
      expiryDate: json['expiryDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'drugLicenseNumber': drugLicenseNumber,
        'documentId': documentId,
        'expiryDate': expiryDate,
      };
}

class DrugLicenseSupplier {
  String? drugLicenseNumber;
  String? documentId;
  String? expiryDate;

  DrugLicenseSupplier({
    this.drugLicenseNumber,
    this.documentId,
    this.expiryDate,
  });

  factory DrugLicenseSupplier.fromJson(Map<String, dynamic> json) {
    return DrugLicenseSupplier(
      drugLicenseNumber: json['drugLicenseNumber'] as String?,
      documentId: json['documentId'] as String?,
      expiryDate: json['expiryDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'drugLicenseNumber': drugLicenseNumber,
        'documentId': documentId,
        'expiryDate': expiryDate,
      };
}

class GstRetailer {
  String? gstNumber;
  String? docUrl;

  GstRetailer({this.gstNumber, this.docUrl});

  factory GstRetailer.fromJson(Map<String, dynamic> json) => GstRetailer(
        gstNumber: json['gstNumber'] as String?,
        docUrl: json['docUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'gstNumber': gstNumber,
        'docUrl': docUrl,
      };
}

class GstSupplier {
  String? gstNumber;
  String? docUrl;

  GstSupplier({this.gstNumber, this.docUrl});

  factory GstSupplier.fromJson(Map<String, dynamic> json) => GstSupplier(
        gstNumber: json['gstNumber'] as String?,
        docUrl: json['docUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'gstNumber': gstNumber,
        'docUrl': docUrl,
      };
}

class GrbItem {
  String? id;
  String? invoiceId;
  String? productId;
  String? productName;
  double? price;
  double? mrp;
  num? quantity;
  num? freeQuantity;
  num? confirmQuantity;
  num? buyQuantity;
  num? finalQuantity;
  dynamic availableQuantity;
  double? finalPtr;
  dynamic discountAmount;
  String? skuId;
  String? skuCode;
  double? totalPrice;
  dynamic discountPrice;
  num? discount;
  String? itemUrl;
  bool? presRquried;
  dynamic measure;
  String? status;
  double? gst;
  double? cgst;
  double? sgst;
  String? gstPercent;
  String? cgstPercent;
  String? sgstPercent;
  String? schemeName;
  String? schemeId;
  String? manufacturer;
  String? batchNumber;
  String? hsn;
  dynamic mfdate;
  String? expDate;
  dynamic packingType;
  double? lineTotalAmount;
  dynamic stockStatus;
  String? rackLable;
  double? lineAmount;
  dynamic taxAmount;
  dynamic updatedBy;
  String? confirmFlag;
  dynamic reason;
  double? discountAmountLine;
  double? withoutDiscountAmountLine;
  String? rejectedFlag;
  String? modified;
  String? discountType;
  String? orderId;
  String? showTabRecord;

  GrbItem({
    this.id,
    this.invoiceId,
    this.productId,
    this.productName,
    this.price,
    this.mrp,
    this.quantity,
    this.freeQuantity,
    this.confirmQuantity,
    this.buyQuantity,
    this.finalQuantity,
    this.availableQuantity,
    this.finalPtr,
    this.discountAmount,
    this.skuId,
    this.skuCode,
    this.totalPrice,
    this.discountPrice,
    this.discount,
    this.itemUrl,
    this.presRquried,
    this.measure,
    this.status,
    this.gst,
    this.cgst,
    this.sgst,
    this.gstPercent,
    this.cgstPercent,
    this.sgstPercent,
    this.schemeName,
    this.schemeId,
    this.manufacturer,
    this.batchNumber,
    this.hsn,
    this.mfdate,
    this.expDate,
    this.packingType,
    this.lineTotalAmount,
    this.stockStatus,
    this.rackLable,
    this.lineAmount,
    this.taxAmount,
    this.updatedBy,
    this.confirmFlag,
    this.reason,
    this.discountAmountLine,
    this.withoutDiscountAmountLine,
    this.rejectedFlag,
    this.modified,
    this.discountType,
    this.orderId,
    this.showTabRecord,
  });

  factory GrbItem.fromJson(Map<String, dynamic> json) => GrbItem(
        id: json['id'] as String?,
        invoiceId: json['invoiceId'] as String?,
        productId: json['productId'] as String?,
        productName: json['productName'] as String?,
        price: (json['price'] as num?)?.toDouble(),
        mrp: (json['mrp'] as num?)?.toDouble(),
        quantity: json['quantity'] as num?,
        freeQuantity: json['freeQuantity'] as num?,
        confirmQuantity: json['confirmQuantity'] as num?,
        buyQuantity: json['buyQuantity'] as num?,
        finalQuantity: json['finalQuantity'] as num?,
        availableQuantity: json['availableQuantity'] as dynamic,
        finalPtr: (json['finalPtr'] as num?)?.toDouble(),
        discountAmount: json['discountAmount'] as dynamic,
        skuId: json['skuId'] as String?,
        skuCode: json['skuCode'] as String?,
        totalPrice: (json['totalPrice'] as num?)?.toDouble(),
        discountPrice: json['discountPrice'] as dynamic,
        discount: json['discount'] as num?,
        itemUrl: json['itemURL'] as String?,
        presRquried: json['presRquried'] as bool?,
        measure: json['measure'] as dynamic,
        status: json['status'] as String?,
        gst: (json['gst'] as num?)?.toDouble(),
        cgst: (json['cgst'] as num?)?.toDouble(),
        sgst: (json['sgst'] as num?)?.toDouble(),
        gstPercent: json['gstPercent'] as String?,
        cgstPercent: json['cgstPercent'] as String?,
        sgstPercent: json['sgstPercent'] as String?,
        schemeName: json['schemeName'] as String?,
        schemeId: json['schemeId'] as String?,
        manufacturer: json['manufacturer'] as String?,
        batchNumber: json['batchNumber'] as String?,
        hsn: json['hsn'] as String?,
        mfdate: json['mfdate'] as dynamic,
        expDate: json['expDate'] as String?,
        packingType: json['packingType'] as dynamic,
        lineTotalAmount: (json['lineTotalAmount'] as num?)?.toDouble(),
        stockStatus: json['stockStatus'] as dynamic,
        rackLable: json['rackLable'] as String?,
        lineAmount: (json['lineAmount'] as num?)?.toDouble(),
        taxAmount: json['taxAmount'] as dynamic,
        updatedBy: json['updatedBy'] as dynamic,
        confirmFlag: json['confirmFlag'] as String?,
        reason: json['reason'] as dynamic,
        discountAmountLine: (json['discountAmountLine'] as num?)?.toDouble(),
        withoutDiscountAmountLine:
            (json['withoutDiscountAmountLine'] as num?)?.toDouble(),
        rejectedFlag: json['rejectedFlag'] as String?,
        modified: json['modified'] as String?,
        discountType: json['discountType'] as String?,
        orderId: json['orderId'] as String?,
        showTabRecord: json['showTabRecord'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoiceId': invoiceId,
        'productId': productId,
        'productName': productName,
        'price': price,
        'mrp': mrp,
        'quantity': quantity,
        'freeQuantity': freeQuantity,
        'confirmQuantity': confirmQuantity,
        'buyQuantity': buyQuantity,
        'finalQuantity': finalQuantity,
        'availableQuantity': availableQuantity,
        'finalPtr': finalPtr,
        'discountAmount': discountAmount,
        'skuId': skuId,
        'skuCode': skuCode,
        'totalPrice': totalPrice,
        'discountPrice': discountPrice,
        'discount': discount,
        'itemURL': itemUrl,
        'presRquried': presRquried,
        'measure': measure,
        'status': status,
        'gst': gst,
        'cgst': cgst,
        'sgst': sgst,
        'gstPercent': gstPercent,
        'cgstPercent': cgstPercent,
        'sgstPercent': sgstPercent,
        'schemeName': schemeName,
        'schemeId': schemeId,
        'manufacturer': manufacturer,
        'batchNumber': batchNumber,
        'hsn': hsn,
        'mfdate': mfdate,
        'expDate': expDate,
        'packingType': packingType,
        'lineTotalAmount': lineTotalAmount,
        'stockStatus': stockStatus,
        'rackLable': rackLable,
        'lineAmount': lineAmount,
        'taxAmount': taxAmount,
        'updatedBy': updatedBy,
        'confirmFlag': confirmFlag,
        'reason': reason,
        'discountAmountLine': discountAmountLine,
        'withoutDiscountAmountLine': withoutDiscountAmountLine,
        'rejectedFlag': rejectedFlag,
        'modified': modified,
        'discountType': discountType,
        'orderId': orderId,
        'showTabRecord': showTabRecord,
      };
}

class PickupAddress {
  dynamic mobileNumber;
  dynamic addressType;
  dynamic addresslineMobileOne;
  dynamic addresslineMobileTwo;
  dynamic alterNateMobileNumber;
  dynamic emailId;
  dynamic pinCode;
  String? addressLine1;
  dynamic addressLine2;
  dynamic landMark;
  dynamic city;
  dynamic region;
  dynamic state;
  String? latitude;
  String? longitude;
  dynamic geoLocation;

  PickupAddress({
    this.mobileNumber,
    this.addressType,
    this.addresslineMobileOne,
    this.addresslineMobileTwo,
    this.alterNateMobileNumber,
    this.emailId,
    this.pinCode,
    this.addressLine1,
    this.addressLine2,
    this.landMark,
    this.city,
    this.region,
    this.state,
    this.latitude,
    this.longitude,
    this.geoLocation,
  });

  factory PickupAddress.fromJson(Map<String, dynamic> json) => PickupAddress(
        mobileNumber: json['mobileNumber'] as dynamic,
        addressType: json['addressType'] as dynamic,
        addresslineMobileOne: json['addresslineMobileOne'] as dynamic,
        addresslineMobileTwo: json['addresslineMobileTwo'] as dynamic,
        alterNateMobileNumber: json['alterNateMobileNumber'] as dynamic,
        emailId: json['emailId'] as dynamic,
        pinCode: json['pinCode'] as dynamic,
        addressLine1: json['addressLine1'] as String?,
        addressLine2: json['addressLine2'] as dynamic,
        landMark: json['landMark'] as dynamic,
        city: json['city'] as dynamic,
        region: json['region'] as dynamic,
        state: json['state'] as dynamic,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
        geoLocation: json['geoLocation'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'addressType': addressType,
        'addresslineMobileOne': addresslineMobileOne,
        'addresslineMobileTwo': addresslineMobileTwo,
        'alterNateMobileNumber': alterNateMobileNumber,
        'emailId': emailId,
        'pinCode': pinCode,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'landMark': landMark,
        'city': city,
        'region': region,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'geoLocation': geoLocation,
      };
}
