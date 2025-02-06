import 'dart:convert';

NetworkRetailerResponse networkRetailerResponseFromJson(String str) =>
    NetworkRetailerResponse.fromJson(json.decode(str));

String networkRetailerResponseToJson(NetworkRetailerResponse data) =>
    json.encode(data.toJson());

class NetworkRetailerResponse {
  List<NetworkRetailerSingleItem>? content;
  Page? page;

  NetworkRetailerResponse({this.content, this.page});

  factory NetworkRetailerResponse.fromJson(Map<String, dynamic> json) {
    return NetworkRetailerResponse(
      content: (json['content'] as List<dynamic>?)
          ?.map((e) =>
              NetworkRetailerSingleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] == null
          ? null
          : Page.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'page': page?.toJson(),
      };
}

class NetworkRetailerSingleItem {
  String? id;
  String? storeId;
  String? email;
  String? phoneNumber;
  dynamic password;
  dynamic otp;
  String? storeName;
  String? businessType;
  String? storeCategory;
  String? storeCategoryId;
  String? ownerName;
  String? isDeleted;
  String? isActive;
  String? dealsIn;
  String? popularIn;
  String? storeNumber;
  String? openTime;
  String? closeTime;
  String? deliveryStrength;
  String? applicationStatus;
  String? applicationStatusDate;
  String? boarded;
  String? retailerBirthday;
  String? retailerMarriageDay;
  String? retailerChildOneBirthDay;
  String? retailerChildTwoBirthDay;
  dynamic retailerMessage;
  String? storeRating;
  String? storeLiveStatus;
  Gst? gst;
  StoreLicense? storeLicense;
  DrugLicense? drugLicense;
  dynamic deliveryType;
  List<dynamic>? slots;
  List<StoreAddressDetailRequest>? storeAddressDetailRequest;
  ImageUrl? imageUrl;
  String? drugLicenseAddress;
  dynamic reason;
  dynamic gstVerifed;
  num? storeLicenseVerifed;
  num? drugLicenseVerifed;
  String? registeredPharmacistName;
  String? fcmToken;
  dynamic webFcmToken;
  String? centralStore;
  String? accountNumber;
  String? accountName;
  String? ifsc;
  String? bankBranch;
  String? bank;
  String? googlePay;
  String? phonePay;
  String? paytm;
  dynamic margUserId;
  dynamic salesPersonId;
  String? subscribed;
  String? notificationTitle;
  String? upiId;
  String? upiPhoneNumber;
  String? firmType;
  String? quickDeliverySupplier;
  dynamic b2cSubscribed;
  dynamic state;
  dynamic pinCode;
  String? linkSupplierId;
  dynamic riderName;
  dynamic outStandingAmount;
  String? phonepay;
  String? accuntName;
  dynamic storeDisplayid;
  String? bankbranch;
  String? googlepay;
  dynamic profileUpdateEnbale;
  num? distance;
  String? linkRetailerStatus;

  NetworkRetailerSingleItem({
    this.id,
    this.storeId,
    this.email,
    this.phoneNumber,
    this.password,
    this.otp,
    this.storeName,
    this.businessType,
    this.storeCategory,
    this.storeCategoryId,
    this.ownerName,
    this.isDeleted,
    this.distance,
    this.isActive,
    this.dealsIn,
    this.popularIn,
    this.storeNumber,
    this.openTime,
    this.closeTime,
    this.deliveryStrength,
    this.applicationStatus,
    this.applicationStatusDate,
    this.boarded,
    this.retailerBirthday,
    this.retailerMarriageDay,
    this.retailerChildOneBirthDay,
    this.retailerChildTwoBirthDay,
    this.retailerMessage,
    this.storeRating,
    this.storeLiveStatus,
    this.gst,
    this.storeLicense,
    this.drugLicense,
    this.deliveryType,
    this.slots,
    this.storeAddressDetailRequest,
    this.imageUrl,
    this.drugLicenseAddress,
    this.reason,
    this.gstVerifed,
    this.storeLicenseVerifed,
    this.drugLicenseVerifed,
    this.registeredPharmacistName,
    this.fcmToken,
    this.webFcmToken,
    this.centralStore,
    this.accountNumber,
    this.accountName,
    this.ifsc,
    this.bankBranch,
    this.bank,
    this.googlePay,
    this.phonePay,
    this.paytm,
    this.margUserId,
    this.salesPersonId,
    this.subscribed,
    this.notificationTitle,
    this.upiId,
    this.upiPhoneNumber,
    this.firmType,
    this.quickDeliverySupplier,
    this.b2cSubscribed,
    this.state,
    this.pinCode,
    this.linkSupplierId,
    this.riderName,
    this.outStandingAmount,
    this.phonepay,
    this.accuntName,
    this.storeDisplayid,
    this.bankbranch,
    this.googlepay,
    this.linkRetailerStatus,
    this.profileUpdateEnbale,
  });

  factory NetworkRetailerSingleItem.fromJson(Map<String, dynamic> json) =>
      NetworkRetailerSingleItem(
        id: json['id'] as String?,
        storeId: json['storeId'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        password: json['password'] as dynamic,
        otp: json['otp'] as dynamic,
        storeName: json['storeName'] as String?,
        businessType: json['businessType'] as String?,
        storeCategory: json['storeCategory'] as String?,
        storeCategoryId: json['storeCategoryId'] as String?,
        ownerName: json['ownerName'] as String?,
        isDeleted: json['isDeleted'] as String?,
        isActive: json['isActive'] as String?,
        dealsIn: json['dealsIn'] as String?,
        popularIn: json['popularIn'] as String?,
        storeNumber: json['storeNumber'] as String?,
        openTime: json['openTime'] as String?,
        closeTime: json['closeTime'] as String?,
        deliveryStrength: json['deliveryStrength'] as String?,
        applicationStatus: json['applicationStatus'] as String?,
        applicationStatusDate: json['applicationStatusDate'] as String?,
        boarded: json['boarded'] as String?,
        retailerBirthday: json['retailerBirthday'] as String?,
        retailerMarriageDay: json['retailerMarriageDay'] as String?,
        retailerChildOneBirthDay: json['retailerChildOneBirthDay'] as String?,
        retailerChildTwoBirthDay: json['retailerChildTwoBirthDay'] as String?,
        retailerMessage: json['retailerMessage'] as dynamic,
        storeRating: json['storeRating'] as String?,
        storeLiveStatus: json['storeLiveStatus'] as String?,
        linkRetailerStatus: json["linkRetailerStatus"] as String?,
        gst: json['gst'] == null
            ? null
            : Gst.fromJson(json['gst'] as Map<String, dynamic>),
        storeLicense: json['storeLicense'] == null
            ? null
            : StoreLicense.fromJson(
                json['storeLicense'] as Map<String, dynamic>),
        drugLicense: json['drugLicense'] == null
            ? null
            : DrugLicense.fromJson(json['drugLicense'] as Map<String, dynamic>),
        deliveryType: json['deliveryType'] as dynamic,
        slots: json['slots'] as List<dynamic>?,
        storeAddressDetailRequest: (json['storeAddressDetailRequest']
                as List<dynamic>?)
            ?.map((e) =>
                StoreAddressDetailRequest.fromJson(e as Map<String, dynamic>))
            .toList(),
        imageUrl: json['imageUrl'] == null
            ? null
            : ImageUrl.fromJson(json['imageUrl'] as Map<String, dynamic>),
        drugLicenseAddress: json['drugLicenseAddress'] as String?,
        reason: json['reason'] as dynamic,
        gstVerifed: json['gstVerifed'] as dynamic,
        storeLicenseVerifed: json['storeLicenseVerifed'] as num?,
        drugLicenseVerifed: json['drugLicenseVerifed'] as num?,
        distance: json["distance"] as num?,
        registeredPharmacistName: json['registeredPharmacistName'] as String?,
        fcmToken: json['fcmToken'] as String?,
        webFcmToken: json['webFcmToken'] as dynamic,
        centralStore: json['centralStore'] as String?,
        accountNumber: json['accountNumber'] as String?,
        accountName: json['accountName'] as String?,
        ifsc: json['ifsc'] as String?,
        bankBranch: json['bankBranch'] as String?,
        bank: json['bank'] as String?,
        googlePay: json['googlePay'] as String?,
        phonePay: json['phonePay'] as String?,
        paytm: json['paytm'] as String?,
        margUserId: json['margUserId'] as dynamic,
        salesPersonId: json['salesPersonId'] as dynamic,
        subscribed: json['subscribed'] as String?,
        notificationTitle: json['notificationTitle'] as String?,
        upiId: json['upiId'] as String?,
        upiPhoneNumber: json['upiPhoneNumber'] as String?,
        firmType: json['firmType'] as String?,
        quickDeliverySupplier: json['quickDeliverySupplier'] as String?,
        b2cSubscribed: json['b2cSubscribed'] as dynamic,
        state: json['state'] as dynamic,
        pinCode: json['pinCode'] as dynamic,
        linkSupplierId: json['linkSupplierId'] as String?,
        riderName: json['riderName'] as dynamic,
        outStandingAmount: json['outStandingAmount'] as dynamic,
        phonepay: json['phonepay'] as String?,
        accuntName: json['accuntName'] as String?,
        storeDisplayid: json['storeDisplayid'] as dynamic,
        bankbranch: json['bankbranch'] as String?,
        googlepay: json['googlepay'] as String?,
        profileUpdateEnbale: json['profileUpdateEnbale'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'storeId': storeId,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'otp': otp,
        'storeName': storeName,
        'businessType': businessType,
        'storeCategory': storeCategory,
        'storeCategoryId': storeCategoryId,
        'ownerName': ownerName,
        'isDeleted': isDeleted,
        'isActive': isActive,
        'dealsIn': dealsIn,
        'popularIn': popularIn,
        "distance": distance,
        'storeNumber': storeNumber,
        "linkRetailerStatus": linkRetailerStatus,
        'openTime': openTime,
        'closeTime': closeTime,
        'deliveryStrength': deliveryStrength,
        'applicationStatus': applicationStatus,
        'applicationStatusDate': applicationStatusDate,
        'boarded': boarded,
        'retailerBirthday': retailerBirthday,
        'retailerMarriageDay': retailerMarriageDay,
        'retailerChildOneBirthDay': retailerChildOneBirthDay,
        'retailerChildTwoBirthDay': retailerChildTwoBirthDay,
        'retailerMessage': retailerMessage,
        'storeRating': storeRating,
        'storeLiveStatus': storeLiveStatus,
        'gst': gst?.toJson(),
        'storeLicense': storeLicense?.toJson(),
        'drugLicense': drugLicense?.toJson(),
        'deliveryType': deliveryType,
        'slots': slots,
        'storeAddressDetailRequest':
            storeAddressDetailRequest?.map((e) => e.toJson()).toList(),
        'imageUrl': imageUrl?.toJson(),
        'drugLicenseAddress': drugLicenseAddress,
        'reason': reason,
        'gstVerifed': gstVerifed,
        'storeLicenseVerifed': storeLicenseVerifed,
        'drugLicenseVerifed': drugLicenseVerifed,
        'registeredPharmacistName': registeredPharmacistName,
        'fcmToken': fcmToken,
        'webFcmToken': webFcmToken,
        'centralStore': centralStore,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'ifsc': ifsc,
        'bankBranch': bankBranch,
        'bank': bank,
        'googlePay': googlePay,
        'phonePay': phonePay,
        'paytm': paytm,
        'margUserId': margUserId,
        'salesPersonId': salesPersonId,
        'subscribed': subscribed,
        'notificationTitle': notificationTitle,
        'upiId': upiId,
        'upiPhoneNumber': upiPhoneNumber,
        'firmType': firmType,
        'quickDeliverySupplier': quickDeliverySupplier,
        'b2cSubscribed': b2cSubscribed,
        'state': state,
        'pinCode': pinCode,
        'linkSupplierId': linkSupplierId,
        'riderName': riderName,
        'outStandingAmount': outStandingAmount,
        'phonepay': phonepay,
        'accuntName': accuntName,
        'storeDisplayid': storeDisplayid,
        'bankbranch': bankbranch,
        'googlepay': googlepay,
        'profileUpdateEnbale': profileUpdateEnbale,
      };
}

class StoreLicense {
  String? storeLicense;
  String? docUrl;

  StoreLicense({this.storeLicense, this.docUrl});

  factory StoreLicense.fromJson(Map<String, dynamic> json) => StoreLicense(
        storeLicense: json['storeLicense'] as String?,
        docUrl: json['docUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'storeLicense': storeLicense,
        'docUrl': docUrl,
      };
}

class Gst {
  String? gstNumber;
  String? docUrl;

  Gst({this.gstNumber, this.docUrl});

  factory Gst.fromJson(Map<String, dynamic> json) => Gst(
        gstNumber: json['gstNumber'] as String?,
        docUrl: json['docUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'gstNumber': gstNumber,
        'docUrl': docUrl,
      };
}

class DrugLicense {
  String? drugLicenseNumber;
  String? documentId;
  String? expiryDate;

  DrugLicense({this.drugLicenseNumber, this.documentId, this.expiryDate});

  factory DrugLicense.fromJson(Map<String, dynamic> json) => DrugLicense(
        drugLicenseNumber: json['drugLicenseNumber'] as String?,
        documentId: json['documentId'] as String?,
        expiryDate: json['expiryDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'drugLicenseNumber': drugLicenseNumber,
        'documentId': documentId,
        'expiryDate': expiryDate,
      };
}

class ImageUrl {
  String? bannerImageId;
  String? profileImageId;

  ImageUrl({this.bannerImageId, this.profileImageId});

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
        bannerImageId: json['bannerImageId'] as String?,
        profileImageId: json['profileImageId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'bannerImageId': bannerImageId,
        'profileImageId': profileImageId,
      };
}

class StoreAddressDetailRequest {
  String? id;
  dynamic mobileNumber;
  dynamic name;
  dynamic addressLineMobileOne;
  dynamic addressLineMobileTwo;
  dynamic addressType;
  dynamic alterNateMobileNumber;
  dynamic emailId;
  String? pinCode;
  String? addressLine1;
  dynamic addressLine2;
  String? landMark;
  dynamic city;
  dynamic region;
  String? state;
  String? latitude;
  String? longitude;

  StoreAddressDetailRequest({
    this.id,
    this.mobileNumber,
    this.name,
    this.addressLineMobileOne,
    this.addressLineMobileTwo,
    this.addressType,
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
  });

  factory StoreAddressDetailRequest.fromJson(Map<String, dynamic> json) {
    return StoreAddressDetailRequest(
      id: json['id'] as String?,
      mobileNumber: json['mobileNumber'] as dynamic,
      name: json['name'] as dynamic,
      addressLineMobileOne: json['addressLineMobileOne'] as dynamic,
      addressLineMobileTwo: json['addressLineMobileTwo'] as dynamic,
      addressType: json['addressType'] as dynamic,
      alterNateMobileNumber: json['alterNateMobileNumber'] as dynamic,
      emailId: json['emailId'] as dynamic,
      pinCode: json['pinCode'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as dynamic,
      landMark: json['landMark'] as String?,
      city: json['city'] as dynamic,
      region: json['region'] as dynamic,
      state: json['state'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobileNumber': mobileNumber,
        'name': name,
        'addressLineMobileOne': addressLineMobileOne,
        'addressLineMobileTwo': addressLineMobileTwo,
        'addressType': addressType,
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
      };
}

class Page {
  int? size;
  int? number;
  int? totalElements;
  int? totalPages;

  Page({this.size, this.number, this.totalElements, this.totalPages});

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        size: json['size'] as int?,
        number: json['number'] as int?,
        totalElements: json['totalElements'] as int?,
        totalPages: json['totalPages'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}
