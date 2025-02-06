import 'dart:convert';

SupplierListResponse supplierListResponseFromJson(String str) =>
    SupplierListResponse.fromJson(json.decode(str));

String supplierListResponseToJson(SupplierListResponse data) =>
    json.encode(data.toJson());

class SupplierListResponse {
  List<SupplierDetail>? content;
  Page? page;

  SupplierListResponse({this.content, this.page});

  factory SupplierListResponse.fromJson(Map<String, dynamic> json) {
    return SupplierListResponse(
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => SupplierDetail.fromJson(e as Map<String, dynamic>))
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

class SupplierDetail {
  String? id;
  String? email;
  dynamic phoneNumber;
  dynamic password;
  dynamic otp;
  String? storeName;
  dynamic businessType;
  dynamic storeCategory;
  dynamic storeCategoryId;
  String? ownerName;
  dynamic isDeleted;
  String? isActive;
  dynamic dealsIn;
  dynamic popularIn;
  dynamic storeNumber;
  dynamic openTime;
  dynamic closeTime;
  dynamic deliveryStrength;
  dynamic applicationStatus;
  dynamic applicationStatusDate;
  dynamic boarded;
  dynamic retailerBirthday;
  dynamic retailerMarriageDay;
  dynamic retailerChildOneBirthDay;
  dynamic retailerChildTwoBirthDay;
  dynamic retailerMessage;
  dynamic storeRating;
  String? storeLiveStatus;
  dynamic storeDisplayid;
  dynamic profileUpdateEnbale;
  Gst? gst;
  StoreLicense? storeLicense;
  DrugLicense? drugLicense;
  dynamic deliveryType;
  dynamic slots;
  List<StoreAddressDetailRequest>? storeAddressDetailRequest;
  ImageUrl? imageUrl;
  dynamic drugLicenseAddress;
  dynamic reason;
  dynamic gstVerifed;
  dynamic storeLicenseVerifed;
  dynamic drugLicenseVerifed;
  dynamic registeredPharmacistName;
  dynamic fcmToken;
  dynamic webFcmToken;
  dynamic centralStore;
  dynamic accountNumber;
  dynamic ifsc;
  dynamic bank;
  dynamic paytm;
  dynamic margUserId;
  dynamic salesPersonId;
  dynamic subscribed;
  dynamic notificationTitle;
  dynamic upiId;
  dynamic upiPhoneNumber;
  dynamic firmType;
  dynamic quickDeliverySupplier;
  dynamic b2cSubscribed;
  dynamic state;
  dynamic pinCode;
  dynamic linkSupplierId;
  dynamic bankbranch;
  dynamic phonepay;
  dynamic googlepay;
  dynamic accuntName;
  String? displayOnboard;

  SupplierDetail({
    this.id,
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
    this.storeDisplayid,
    this.profileUpdateEnbale,
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
    this.ifsc,
    this.bank,
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
    this.bankbranch,
    this.phonepay,
    this.googlepay,
    this.accuntName,
    this.displayOnboard,
  });

  factory SupplierDetail.fromJson(Map<String, dynamic> json) => SupplierDetail(
        id: json['id'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as dynamic,
        password: json['password'] as dynamic,
        otp: json['otp'] as dynamic,
        storeName: json['storeName'] as String?,
        businessType: json['businessType'] as dynamic,
        storeCategory: json['storeCategory'] as dynamic,
        storeCategoryId: json['storeCategoryId'] as dynamic,
        ownerName: json['ownerName'] as String?,
        isDeleted: json['isDeleted'] as dynamic,
        isActive: json['isActive'] as String?,
        dealsIn: json['dealsIn'] as dynamic,
        popularIn: json['popularIn'] as dynamic,
        storeNumber: json['storeNumber'] as dynamic,
        openTime: json['openTime'] as dynamic,
        closeTime: json['closeTime'] as dynamic,
        deliveryStrength: json['deliveryStrength'] as dynamic,
        applicationStatus: json['applicationStatus'] as dynamic,
        applicationStatusDate: json['applicationStatusDate'] as dynamic,
        boarded: json['boarded'] as dynamic,
        retailerBirthday: json['retailerBirthday'] as dynamic,
        retailerMarriageDay: json['retailerMarriageDay'] as dynamic,
        retailerChildOneBirthDay: json['retailerChildOneBirthDay'] as dynamic,
        retailerChildTwoBirthDay: json['retailerChildTwoBirthDay'] as dynamic,
        retailerMessage: json['retailerMessage'] as dynamic,
        storeRating: json['storeRating'] as dynamic,
        storeLiveStatus: json['storeLiveStatus'] as String?,
        storeDisplayid: json['storeDisplayid'] as dynamic,
        profileUpdateEnbale: json['profileUpdateEnbale'] as dynamic,
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
        slots: json['slots'] as dynamic,
        storeAddressDetailRequest: (json['storeAddressDetailRequest']
                as List<dynamic>?)
            ?.map((e) =>
                StoreAddressDetailRequest.fromJson(e as Map<String, dynamic>))
            .toList(),
        imageUrl: json['imageUrl'] == null
            ? null
            : ImageUrl.fromJson(json['imageUrl'] as Map<String, dynamic>),
        drugLicenseAddress: json['drugLicenseAddress'] as dynamic,
        reason: json['reason'] as dynamic,
        gstVerifed: json['gstVerifed'] as dynamic,
        storeLicenseVerifed: json['storeLicenseVerifed'] as dynamic,
        drugLicenseVerifed: json['drugLicenseVerifed'] as dynamic,
        registeredPharmacistName: json['registeredPharmacistName'] as dynamic,
        fcmToken: json['fcmToken'] as dynamic,
        webFcmToken: json['webFcmToken'] as dynamic,
        centralStore: json['centralStore'] as dynamic,
        accountNumber: json['accountNumber'] as dynamic,
        ifsc: json['ifsc'] as dynamic,
        bank: json['bank'] as dynamic,
        paytm: json['paytm'] as dynamic,
        margUserId: json['margUserId'] as dynamic,
        salesPersonId: json['salesPersonId'] as dynamic,
        subscribed: json['subscribed'] as dynamic,
        notificationTitle: json['notificationTitle'] as dynamic,
        upiId: json['upiId'] as dynamic,
        upiPhoneNumber: json['upiPhoneNumber'] as dynamic,
        firmType: json['firmType'] as dynamic,
        quickDeliverySupplier: json['quickDeliverySupplier'] as dynamic,
        b2cSubscribed: json['b2cSubscribed'] as dynamic,
        state: json['state'] as dynamic,
        pinCode: json['pinCode'] as dynamic,
        linkSupplierId: json['linkSupplierId'] as dynamic,
        bankbranch: json['bankbranch'] as dynamic,
        phonepay: json['phonepay'] as dynamic,
        googlepay: json['googlepay'] as dynamic,
        accuntName: json['accuntName'] as dynamic,
        displayOnboard: json["displayOnboard"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'storeNumber': storeNumber,
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
        'storeDisplayid': storeDisplayid,
        'profileUpdateEnbale': profileUpdateEnbale,
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
        'ifsc': ifsc,
        'bank': bank,
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
        'bankbranch': bankbranch,
        'phonepay': phonepay,
        'googlepay': googlepay,
        'accuntName': accuntName,
        'displayOnboard': displayOnboard,
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

class DrugLicense {
  String? drugLicenseNumber;
  String? documentId;

  DrugLicense({this.drugLicenseNumber, this.documentId});

  factory DrugLicense.fromJson(Map<String, dynamic> json) => DrugLicense(
        drugLicenseNumber: json['drugLicenseNumber'] as String?,
        documentId: json['documentId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'drugLicenseNumber': drugLicenseNumber,
        'documentId': documentId,
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
