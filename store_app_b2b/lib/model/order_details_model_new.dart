import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  String? id;
  dynamic usedRewards;
  dynamic usedCashBack;
  String? createdAt;
  String? userId;
  String? userName;
  String? mobileNumber;
  num? orderTotalValue;
  num? creditNoteAmountAdjusted;
  dynamic paidAmount;
  num? orderValue;
  String? storeId;
  List<OrderItem> items;
  num? deliveryCharges;
  num? serviceCharges;
  num? tax;
  dynamic couponInfo;
  num? discounts;
  String? paymentMode;
  Map<String, String> pickupAddress;
  Map<String, String> deliveryAddress;
  String? deliveryDate;
  String? slot;
  String? isExpressDelivery;
  dynamic riderId;
  String? orderAssignedStatus;
  String? deliveryStatus;
  String? packed;
  String? riderOrderAcceptStatus;
  String? isPickedFromStore;
  dynamic atLocation;
  String? orderEventStatus;
  String? orderStatus;
  String? orderEventId;
  String? storeName;
  String? storeImageUrl;
  DateTime? orderCreatedDate;
  DateTime? orderUpdatedDate;
  DateTime? orderAssignedDate;
  DateTime? orderDelivaryDate;
  bool prescVerified;
  bool prescAdded;
  bool prescIsExistingCustomer;
  dynamic rewardPoints;
  DateTime? validTillDate;
  dynamic prescImages;
  bool consultDoctor;
  String? paymentTransactionId;
  dynamic categoryId;
  dynamic categoryName;
  dynamic subCategoryId;
  dynamic subCategoryName;
  num? orderAcceptedValue;
  num? orderRefundValue;
  String? refundStatus;
  DateTime? refundDate;
  String? fcmToken;
  dynamic riderPhoneNumber;
  dynamic riderStatusMessage;
  dynamic riderImgUrl;
  dynamic riderName;
  num? serviceChargesPercentage;
  dynamic specialInstruction;
  dynamic anySpecialInstruction;
  String? unListedOrder;
  String? invoiceDownloadURL;
  String? billed;
  String? orderReceived;

  OrderDetailsModel({
    this.id,
    this.usedRewards,
    this.usedCashBack,
    this.createdAt,
    this.userId,
    this.userName,
    this.mobileNumber,
    this.orderTotalValue,
    this.paidAmount,
    this.packed,
    this.orderValue,
    this.storeId,
    this.items = const <OrderItem>[],
    this.deliveryCharges,
    this.serviceCharges,
    this.tax,
    this.couponInfo,
    this.discounts,
    this.paymentMode,
    this.pickupAddress = const {},
    this.deliveryAddress = const {},
    this.deliveryDate,
    this.slot,
    this.creditNoteAmountAdjusted,
    this.isExpressDelivery,
    this.riderId,
    this.orderAssignedStatus,
    this.deliveryStatus,
    this.riderOrderAcceptStatus,
    this.isPickedFromStore,
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
    this.prescVerified = false,
    this.prescAdded = false,
    this.prescIsExistingCustomer = false,
    this.rewardPoints,
    this.validTillDate,
    this.prescImages,
    this.consultDoctor = false,
    this.paymentTransactionId,
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
    this.invoiceDownloadURL,
    this.unListedOrder,
    this.billed,
    this.orderReceived,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        id: json["id"],
        usedRewards: json["usedRewards"],
        usedCashBack: json["usedCashBack"],
        createdAt: json["createdAt"],
        userId: json["userId"],
        userName: json["userName"],
        packed: json['packed'],
        mobileNumber: json["mobileNumber"],
        orderTotalValue: json["orderTotalValue"] as num?,
        paidAmount: json["paidAmount"],
        orderValue: json["orderValue"] as num?,
        storeId: json["storeId"],
        items: List<OrderItem>.from(
            json["items"].map((x) => OrderItem.fromJson(x))),
        deliveryCharges: json["deliveryCharges"],
        serviceCharges: json["serviceCharges"],
        tax: json["tax"],
        couponInfo: json["couponInfo"],
        discounts: json["discounts"],
        paymentMode: json["paymentMode"],
        //     pickupAddress: json["pickupAddress"] != null
        // ? Map.from(json["pickupAddress"]).map((k, v) => MapEntry<String, String>(k, jsonEncode(v)))
        // : {},
        // pickupAddress: Map.from(json["pickupAddress"])
        //     .map((k, v) => MapEntry<String, String>(k, (jsonEncode(v) ?? ''))),
        // deliveryAddress: Map.from(json["deliveryAddress"])
        //     .map((k, v) => MapEntry<String, String>(k, (jsonEncode(v) ?? ''))),
        deliveryDate: json["deliveryDate"],
        slot: json["slot"],
        isExpressDelivery: json["isExpressDelivery"],
        riderId: json["riderId"],
        orderAssignedStatus: json["orderAssignedStatus"],
        deliveryStatus: json["deliveryStatus"],
        riderOrderAcceptStatus: json["riderOrderAcceptStatus"],
        isPickedFromStore: json["isPickedfromStore"],
        atLocation: json["atLocation"],
        orderEventStatus: json["orderEventStatus"],
        orderStatus: json["orderStatus"],
        orderEventId: json["orderEventId"],
        storeName: json["storeName"],
        storeImageUrl: json["storeImageURL"],
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
        // prescVerified: json["prescVerified"],
        //  prescAdded: json["prescAdded"],
        // prescIsExistingCustomer: json["prescIsExistingCutomer"],
        rewardPoints: json["rewardPoints"],
        validTillDate: json['validTillDate'] == null
            ? null
            : DateTime.parse(json['validTillDate'] as String),
        prescImages: json["prescImgs"],
        //consultDoctor: json["consultDoctor"],
        paymentTransactionId: json["paymentTrasactionId"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        subCategoryId: json["subCategoryId"],
        subCategoryName: json["subCategoryName"],
        orderAcceptedValue: json["orderAcceptedValue"],
        orderRefundValue: json["orderRefundValue"],
        refundStatus: json["refundStatus"],
        refundDate: json['refundDate'] == null
            ? null
            : DateTime.parse(json['refundDate'] as String),
        fcmToken: json["fcmToken"],
        riderPhoneNumber: json["riderPhoneNumber"],
        riderStatusMessage: json["riderStatusMessage"],
        riderImgUrl: json["riderImgURL"],
        riderName: json["riderName"],
        serviceChargesPercentage: json["serviceChargesPercentage"] as num?,
        specialInstruction: json["specialInstruction"],
        anySpecialInstruction: json["anySpecialInstruction"],
        unListedOrder: json["unListedOrder"],
        invoiceDownloadURL: json["invoiceDownloadURL"],
        billed: json["billed"],
        creditNoteAmountAdjusted: json["creditNoteAmountAdjusted"],
        orderReceived: json["orderReceived"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usedRewards": usedRewards,
        "usedCashBack": usedCashBack,
        "createdAt": createdAt,
        "userId": userId,
        'packed': packed,
        "userName": userName,
        "mobileNumber": mobileNumber,
        "orderTotalValue": orderTotalValue,
        "paidAmount": paidAmount,
        "orderValue": orderValue,
        "storeId": storeId,
        "creditNoteAmountAdjusted": creditNoteAmountAdjusted,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "deliveryCharges": deliveryCharges,
        "serviceCharges": serviceCharges,
        "tax": tax,
        "couponInfo": couponInfo,
        "discounts": discounts,
        "paymentMode": paymentMode,
        // "pickupAddress":
        //  (pickupAddress ?? {})
        //     .map((k, v) => MapEntry<String, dynamic>(k, v)),
        // "pickupAddress": Map.from(pickupAddress)
        //     .map((k, v) => MapEntry<String, dynamic>(k, v)),
        // "deliveryAddress": Map.from(deliveryAddress)
        //     .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "deliveryDate": deliveryDate,
        "slot": slot,
        "isExpressDelivery": isExpressDelivery,
        "riderId": riderId,
        "orderAssignedStatus": orderAssignedStatus,
        "deliveryStatus": deliveryStatus,
        "riderOrderAcceptStatus": riderOrderAcceptStatus,
        "isPickedfromStore": isPickedFromStore,
        "atLocation": atLocation,
        "orderEventStatus": orderEventStatus,
        "orderStatus": orderStatus,
        "orderEventId": orderEventId,
        "storeName": storeName,
        "storeImageURL": storeImageUrl,
        "orderCreatedDate": orderCreatedDate?.toIso8601String(),
        "orderUpdatedDate": orderUpdatedDate?.toIso8601String(),
        "orderAssignedDate": orderAssignedDate?.toIso8601String(),
        "orderDelivaryDate": orderDelivaryDate?.toIso8601String(),
        // "prescVerified": prescVerified,
        // "prescAdded": prescAdded,
        //"prescIsExistingCutomer": prescIsExistingCustomer,
        "rewardPoints": rewardPoints,
        "validTillDate": validTillDate?.toIso8601String(),
        "prescImgs": prescImages,
        // "consultDoctor": consultDoctor,
        "paymentTrasactionId": paymentTransactionId,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "subCategoryId": subCategoryId,
        "subCategoryName": subCategoryName,
        "orderAcceptedValue": orderAcceptedValue,
        "orderRefundValue": orderRefundValue,
        "refundStatus": refundStatus,
        "refundDate": refundDate?.toIso8601String(),
        "fcmToken": fcmToken,
        "riderPhoneNumber": riderPhoneNumber,
        "riderStatusMessage": riderStatusMessage,
        "riderImgURL": riderImgUrl,
        "riderName": riderName,
        "serviceChargesPercentage": serviceChargesPercentage,
        "specialInstruction": specialInstruction,
        "anySpecialInstruction": anySpecialInstruction,
        "unListedOrder": unListedOrder,
        "invoiceDownloadURL": invoiceDownloadURL,
        "billed": billed,
        "orderReceived": orderReceived,
      };
}

class OrderItem {
  String? productId;
  String? productName;
  num? price;
  num? finalPtr;
  num? mrp;
  num? quantity;
  num? freeQuantity;
  num? confirmQuantity;
  num? buyQuantity;
  num? finalQuantity;
  dynamic discountAmount;
  String? skuId;
  String? skuCode;
  num? totalPrice;
  dynamic discountPrice;
  String? itemUrl;
  String? presRequired;
  dynamic measure;
  String? status;
  dynamic gst;
  dynamic costGst;
  dynamic sGst;
  num? lineTotalAmount;
  String? gstPercent;
  String? cGstPercent;
  String? sGstPercent;
  String? schemeName;
  String? manufacturer;
  String? batchNumber;
  String? hsn;
  String? manufacturerDate;
  String? expiryDate;
  String? packingType;
  String? stockStatus;
  String? unListedOrder;
  String? modified;
  String? rejectedFlag;
  String? showTabRecord;
  String? reason;

  OrderItem({
    this.productId,
    this.productName,
    this.price,
    this.finalPtr,
    this.mrp,
    this.quantity,
    this.freeQuantity,
    this.confirmQuantity,
    this.buyQuantity,
    this.finalQuantity,
    this.discountAmount,
    this.skuId,
    this.lineTotalAmount,
    this.skuCode,
    this.totalPrice,
    this.discountPrice,
    this.itemUrl,
    this.presRequired,
    this.measure,
    this.status,
    this.gst,
    this.costGst,
    this.sGst,
    this.gstPercent,
    this.cGstPercent,
    this.sGstPercent,
    this.schemeName,
    this.manufacturer,
    this.batchNumber,
    this.hsn,
    this.manufacturerDate,
    this.expiryDate,
    this.packingType,
    this.stockStatus,
    this.modified,
    this.rejectedFlag,
    this.showTabRecord,
    this.reason,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"].toDouble(),
        finalPtr: json["finalPtr"].toDouble(),
        mrp: json["mrp"].toDouble(),
        quantity: json["quantity"],
        freeQuantity: json["freeQuantity"],
        lineTotalAmount: json['lineTotalAmount'],
        confirmQuantity: json["confirmQuantity"],
        buyQuantity: json["buyQuantity"],
        finalQuantity: json["finalQuantity"],
        discountAmount: json["discountAmount"],
        skuId: json["skuId"],
        skuCode: json["skuCode"],
        totalPrice: json["totalPrice"].toDouble(),
        discountPrice: json["discountPrice"],
        itemUrl: json["itemURL"],
        presRequired: json["presRquried"],
        measure: json["measure"],
        status: json["status"],
        gst: json["gst"],
        costGst: json["cgst"],
        sGst: json["sgst"],
        gstPercent: json["gstPercent"],
        cGstPercent: json["cgstPercent"],
        sGstPercent: json["sgstPercent"],
        schemeName: json["schemeName"],
        manufacturer: json["manufacturer"],
        batchNumber: json["batchNumer"],
        hsn: json["hsn"],
        manufacturerDate: json["mfdate"],
        expiryDate: json["expdate"],
        packingType: json["packingType"],
        stockStatus: json["stockStatus"],
        modified: json["modified"],
        rejectedFlag: json["rejectedFlag"],
        showTabRecord: json["showTabRecord"],
        reason: json['reason'],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "price": price,
        "finalPtr": finalPtr,
        "mrp": mrp,
        "quantity": quantity,
        "freeQuantity": freeQuantity,
        'lineTotalAmount': lineTotalAmount,
        "confirmQuantity": confirmQuantity,
        "buyQuantity": buyQuantity,
        "finalQuantity": finalQuantity,
        "discountAmount": discountAmount,
        "skuId": skuId,
        "skuCode": skuCode,
        "totalPrice": totalPrice,
        "discountPrice": discountPrice,
        "itemURL": itemUrl,
        "presRquried": presRequired,
        "measure": measure,
        "status": status,
        "gst": gst,
        "cgst": costGst,
        "sgst": sGst,
        "gstPercent": gstPercent,
        "cgstPercent": cGstPercent,
        "sgstPercent": sGstPercent,
        "schemeName": schemeName,
        "manufacturer": manufacturer,
        "batchNumer": batchNumber,
        "hsn": hsn,
        "mfdate": manufacturerDate,
        "expdate": expiryDate,
        "packingType": packingType,
        "stockStatus": stockStatus,
        "modified": modified,
        "rejectedFlag": rejectedFlag,
        "showTabRecord": showTabRecord,
        'reason': reason,
      };
}
