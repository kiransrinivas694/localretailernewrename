import 'package:store_app_b2b/new_module/services/new_rest_service_new.dart';

class Payloads {
  //POST APIS
  Map<String, dynamic> getSendLoginOtpPayload(
      {required String mobileNumber, String flag = "send"}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.sendLoginOtp}?phoneNumber=$mobileNumber';

    map["body"] = {
      "phoneNumber": mobileNumber,
      "flg": flag,
    };

    return map;
  }

  Map<String, dynamic> getSendOtpPayload(
      {required String mobileNumber, String flag = "send"}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.sendOtp}/$flag?phoneNumber=$mobileNumber';

    return map;
  }

  Map<String, dynamic> getVerifyLoginOtpPayload(
      {required String mobileNumber,
      required String otp,
      required String fcmToken}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.verifyLoginOtp}?otp=$otp&phoneNumber=$mobileNumber&fcmToken=$fcmToken';

    return map;
  }

  Map<String, dynamic> getSignUp(
      {required String mobileNumber,
      String flag = "send",
      required String otp,
      required String fcmToken,
      required String username,
      required String referralCode,
      required String email,
      requried}) {
    Map<String, dynamic> map = {
      "mobileNumber": mobileNumber,
      "otp": "",
      "fcmToken": "string",
      "userName": "string",
      "referralCode": "string",
      "email": "string",
      "socialLoignAuthonticatd": ""
    };

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.signup}';

    map["body"] = {
      "mobileNumber": mobileNumber,
      "otp": otp,
      "fcmToken": fcmToken,
      "userName": username,
      "referralCode": referralCode,
      "email": email,
      "socialLoignAuthonticatd": ""
    };
    return map;
  }

  Map<String, dynamic> getVerifyOtpPayload(
      {required String mobileNumber,
      required String otp,
      required String fcmToken}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.verifyOtp}?otp=$otp&phoneNumber=$mobileNumber&fcmToken=$fcmToken';

    return map;
  }

  Map<String, dynamic> cartAdditionNearProduct({
    required String productId,
    required String skuId,
    required String productName,
    required String mesuare,
    required int quantity,
    required String price,
    required String productUrl,
    required String storeName,
    required bool isPrescriptionIsRequired,
    required String tabletsPerStrip,
    required String categoryName,
    required String discountType,
    required String discount,
    required String mrp,
    required String userId,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = [
      {
        "productId": productId,
        "skuId": skuId,
        "productName": productName,
        "mesuare": mesuare,
        "quantity": quantity,
        "price": price,
        "productUrl": productUrl,
        "storeName": storeName,
        "isPrescriptionIsRequired": isPrescriptionIsRequired,
        "tabletsPerStrip": tabletsPerStrip,
        "categoryName": categoryName,
        "discountType": discountType,
        "discount": discount,
        "mrp": mrp
      }
    ];

    map["url"] =
        '${RestConstants.instance.apiCart}${RestConstants.instance.cartAdditionNearProduct}/$userId/store/AL-R202306-001';

    return map;
  }

  Map<String, dynamic> cartAdditionUpdateNearProduct({
    required String productId,
    required int quantity,
    required String userId,
    required String storeId,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {
      "productId": productId,
      "quantity": quantity,
      "userId": userId,
      'storeId': storeId,
    };

    map["url"] =
        '${RestConstants.instance.apiCart}${RestConstants.instance.cartAdditionUpdateNearProduct}';

    return map;
  }

  Map<String, dynamic> cartBeforeCheckout({
    required bool rewards,
    required bool cashback,
    required String userId,
    required List<Map<String, dynamic>> cartId,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {
      "cartId": cartId,
      "userId": userId,
      "rewards": rewards,
      "cashback": cashback,
    };

    map["url"] =
        "${RestConstants.instance.apiCheckout}${RestConstants.instance.getBeforeCheckout}";

    return map;
  }

  Map<String, dynamic> cartAfterCheckout({
    required String id,
    required String paidAmount,
    required num toBePaid,
    required String transactionId,
    required String transactionStatus,
    required List<Map<String, dynamic>> checkoutItems,
    required String userId,
    required String userName,
    required Map<String, dynamic> delivery,
    required String mobileNumber,
    required String paymentMode,
    required String slot,
    required String deliveryDate,
    required bool expressDelivery,
    required num expressDeliveryCharges,
    required String fcmToken,
    required String? walletTransactionId,
    required num walletAmount,
    required String? barcode,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {
      "id": id,
      "paidAmount": paidAmount,
      "toBePaid": toBePaid,
      "transactionId": transactionId,
      "transactionStatus": transactionStatus,
      "checkoutItems": checkoutItems,
      "walletTransactionId": walletTransactionId,
      "walletAmount": walletAmount,
      "deliveryAddress": delivery,
      "userName": userName,
      "userId": userId,
      "mobileNumber": mobileNumber,
      "paymentMode": paymentMode,
      "slot": slot,
      "deliveryDate": deliveryDate,
      "expressDelivery": expressDelivery,
      "expressDeliveryCharges": expressDeliveryCharges,
      "fcmToken": fcmToken,
      "barCode": barcode,
    };

    map["url"] =
        "${RestConstants.instance.apiCheckout}${RestConstants.instance.getAfterCheckout}";

    return map;
  }

  Map<String, dynamic> addAddressCallPayload({
    required String mobileNumber,
    required String name,
    required String houseNum,
    required String addresslineMobileOne,
    required String addresslineMobileTwo,
    required String addressType,
    required String alterNateMobileNumber,
    required String emailId,
    required String pinCode,
    required String addressLine1,
    required String addressLine2,
    required String landMark,
    required String city,
    required String region,
    required String state,
    required String latitude,
    required String longitude,
    required String countrycode,
    required String userId,
  }) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAddAddress}/$userId';

    map["body"] = {
      "mobileNumber": mobileNumber,
      "name": name,
      "houseNum": houseNum,
      "addresslineMobileOne": addresslineMobileOne,
      "addresslineMobileTwo": addresslineMobileTwo,
      "addressType": addressType,
      "alterNateMobileNumber": alterNateMobileNumber,
      "emailId": emailId,
      "pinCode": pinCode,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "landMark": landMark,
      "city": city,
      "region": region,
      "state": state,
      "latitude": latitude,
      "longitude": longitude,
      "countrycode": countrycode,
    };
    return map;
  }

  String getAllHealthPackages(
      {required int size, required int page, required String packageName}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getAllHealthPackages}?packageName=$packageName&page=$page&size=$size&sort=string";
    return url;
  }

  String getHealthPackagesDetails({required String packageId}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getPackagedetails}$packageId";
    return url;
  }

  String getViewPackages({required String serviceCd}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getHealthPackage}$serviceCd";
    return url;
  }

  String getRelationUrl() {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getRelationList}";
    return url;
  }

  Map<String, dynamic> deleteAddressCallPayload({
    required String addressId,
  }) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}v1/address/$addressId';

    return map;
  }

  Map<String, dynamic> uploadPrescriptionPayload({
    required String cartId,
    required String storeId,
    required String userId,
    required List<Map<String, dynamic>> prescList,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {
      "prescList": prescList,
      "continueWithoutPrescItems": false,
      "existingCustomer": false,
      "prescUploaded": true,
      "consultDoctor": false
    };

    map["url"] =
        "${RestConstants.instance.apiCart}${RestConstants.instance.uploadPrescription}/$cartId/store/$storeId/user/$userId";

    return map;
  }

  Map<String, dynamic> saveRecentView({
    required String productId,
    required String userId,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {"userId": userId, "productId": productId};

    map["url"] =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.saveRecentView}";

    return map;
  }

  Map<String, dynamic> consultDoctorPayload({
    required String cartId,
    required String storeId,
    required String userId,
    required String name,
    required int age,
    required String phoneNumber,
    required String gender,
    required String relation,
    required bool isDelete,
  }) {
    Map<String, dynamic> map = {};

    if (isDelete) {
      map["body"] = {
        "prescList": [],
        "continueWithoutPrescItems": false,
        "consultDoctor": false,
        "existingCustomer": false,
        "prescUploaded": false,
        "consultPatientInfo": {
          "name": "",
          "age": 0,
          "phoneNumber": "",
          "gender": "",
          "relation": "",
        }
      };
    } else {
      map["body"] = {
        "prescList": [],
        "continueWithoutPrescItems": false,
        "consultDoctor": true,
        "existingCustomer": false,
        "prescUploaded": false,
        "consultPatientInfo": {
          "name": name,
          "age": age,
          "phoneNumber": phoneNumber,
          "gender": gender,
          "relation": relation,
        }
      };
    }

    map["url"] =
        "${RestConstants.instance.apiCart}${RestConstants.instance.uploadPrescription}/$cartId/store/$storeId/user/$userId";

    return map;
  }

  String getAllTopDoctors(
      {required int page,
      required int size,
      required String specialisation,
      required String doctorName}) {
    if (specialisation.isNotEmpty && doctorName.isEmpty) {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getTopAllDoctors}/specialization/$specialisation?topDoctorStatus=Y&page=$page&size=$size";

      return url;
    } else {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getTopAllDoctors}/specialization/$specialisation?topDoctorStatus=Y&doctorName=$doctorName&page=$page&size=$size";

      return url;
    }
  }

  Map<String, dynamic> continuewWithoutPrescription({
    required String cartId,
    required String storeId,
    required String userId,
  }) {
    Map<String, dynamic> map = {};

    map["url"] =
        "${RestConstants.instance.apiCart}${RestConstants.instance.continuewWithoutPrescription}/$cartId/store/$storeId/user/$userId/continueWithoutPrescItems";

    return map;
  }

  Map<String, dynamic> deletePrescriptionPayload({
    required String cartId,
    required String prescId,
  }) {
    Map<String, dynamic> map = {};

    map["body"] = {
      "cartId": cartId,
      "prescId": prescId,
    };

    map["url"] =
        "${RestConstants.instance.apiCart}${RestConstants.instance.deletePrescription}/$cartId/prescId/$prescId";

    return map;
  }

  String postAppointmentRequest() {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.postDoctorAppointment}";
    return url;
  }

  String rebook(String testId) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.rebookTest}/$testId";
    return url;
  }

  Map<String, dynamic> getAddTest({
    required String userId,
    required List<Map<String, dynamic>> lucidTest,
  }) {
    // Creating the payload
    Map<String, dynamic> map = {
      "userId": userId,
      "lucidTest": lucidTest,
    };

    // Adding the URL for the endpoint
    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.addTest}';

    // Adding the body for the POST request
    map["body"] = {
      "userId": userId,
      "lucidTest": lucidTest,
    };

    return map;
  }

  String getAllAchieversList() {
    String url =
        "${RestConstants.instance.apiAchivers}${RestConstants.instance.getAllAchievers}";
    return url;
  }

  String getByAchieversId({required String achieverId}) {
    String url =
        "${RestConstants.instance.apiAchivers}${RestConstants.instance.getByAchieverId}?id=$achieverId";

    return url;
  }

  String getByDiseaseId({
    required String achieverDiseaseId,
  }) {
    String url =
        "${RestConstants.instance.apiAchivers}${RestConstants.instance.getByDiseaseId}?id=$achieverDiseaseId";

    return url;
  }

  String getfindBranch({required String branchId}) {
    String url =
        "${RestConstants.instance.apiLucidService}${RestConstants.instance.findBranch}/id/$branchId";
    return url;
  }

  String postReview() {
    String url =
        "${RestConstants.instance.apiReview}${RestConstants.instance.postReview}";
    return url;
  }

  ///post Api////
  Map<String, dynamic> postPatientDetails({
    required String cartId,
    required String userId,
    required String relation,
    required String firstName,
    required String lastName,
    required int age,
    required String mobileNumber,
    required String city,
    required String address,
    required String fullAddress,
    required String location,
    required String comments,
    required String gender,
    required String isUrgent,
    required String appointmentDate,
    required String bookingDate,
    required String branchId,
    required String? latitude,
    required String? longitude,
    required String? isHomeCollection,
  }) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.saveLucidPatient}';

    map["body"] = {
      "cartId": cartId,
      "userId": userId,
      "relation": relation,
      "firstName": firstName,
      "lastName": lastName,
      "age": age,
      "mobileNumber": mobileNumber,
      "city": city,
      "gender": gender,
      "location": location,
      "comments": comments,
      "address": address,
      'fullAddress': fullAddress,
      "appointmentDate": appointmentDate,
      "bookingDate": bookingDate,
      "branchId": branchId,
      "isHomeCollection": isHomeCollection,
      'latitude': latitude,
      'longitude': longitude,
    };
    return map;
  }

  Map<String, dynamic> postDiagnosticTestPayment(
      {required String patientId,
      required String paymentId,
      required String paymentStatus,
      required num paidAmount,
      required num homeCollecitonCharges,
      required String isHomeCollection,
      required String fcmToken,
      required String companyName,
      required String companyReferralCode,
      required String companylogo,
      required String storeNumber}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.lucidOrderCheckout}';

    map["body"] = {
      "patientId": patientId,
      "paymentId": paymentId,
      "paymentStatus": paymentStatus,
      'isHomeCollection': isHomeCollection,
      "paidAmount": paidAmount,
      'homeCollecitonCharges': homeCollecitonCharges,
      'homeCollectionCharges': homeCollecitonCharges,
      'fcmToken': fcmToken,
      'companyName': companyName,
      'companyReferralCode': companyReferralCode,
      'companylogo': companylogo,
      'storeNumber': storeNumber
    };
    return map;
  }

  Map<String, dynamic> uploadPrescription({
    required String relation,
    required String name,
    required String email,
    required String userId,
    required int age,
    required String gender,
    required String phoneNumber,
    required String problemDescription,
    required String hospitalName,
    required String specialization,
    required String doctorName,
    required String appointmentTime,
    required String requestStatus,
  }) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiAuthentication}${RestConstants.instance.prescriptionUpload}';

    map["body"] = {
      "relation": relation,
      "name": name,
      "email": email,
      'userId': userId,
      "age": age,
      "gender": gender,
      "phoneNumber": phoneNumber,
      "problemDescription": problemDescription,
      "hospitalName": hospitalName,
      "specialization": specialization,
      "doctorName": doctorName,
      "appointmentTime": appointmentTime,
      "requestStatus": requestStatus,
    };
    return map;
  }

  String getLiveVideosList() {
    String url =
        "${RestConstants.instance.apiBanner}${RestConstants.instance.getVideosList}";
    return url;
  }

  //GET APIS

  String getReferralCheck(String referralCode) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.referralCheck}/$referralCode";

    return url;
  }

  String getCategoryList(String searchtxt) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllCategories}";
    return url;
  }

  String getNewlyLaunchedProducts({required int page, required int size}) {
    String url =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.getNewlyLaunchedProducts}/category/669e6737a2bada17a0e1f4a6?page=$page&size=$size";
    return url;
  }

  String getViewAllProducts(
      {required int page, required int size, required String endpoint}) {
    String url =
        "${RestConstants.instance.apiProduct}$endpoint?page=$page&size=$size";
    return url;
  }

  String getRecentViewedProducts(
      {required int page, required int size, required String userId}) {
    String url =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.getRecentViewedProducts}/$userId?page=$page&size=$size";
    return url;
  }

  String getCategoryWiseProducts(
      {required int page,
      required int size,
      String categoryId = "",
      String productName = ""}) {
    String url =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.getCategoryWiseProducts}?categoryId=$categoryId&productName=$productName&page=$page&size=$size";
    return url;
  }

  String getAppointmentHistory(
      {required int page,
      required int size,
      required String status,
      required String userId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.appointmentHistory}/$userId?status=$status&page=$page&size=$size&sort=appointmentDate,slot";
    return url;
  }

  String getTopSellingProducts({required int page, required int size}) {
    String url =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.getTopSellingProducts}/category/669e6737a2bada17a0e1f4a6?page=$page&size=$size";
    return url;
  }

  String getMedOrdersList(
      {required int page, required int size, required String userId}) {
    String url =
        "${RestConstants.instance.apiOMS}${RestConstants.instance.getMedOrdersList}/$userId/orders?page=$page&size=$size";
    return url;
  }

  String getRequestList(
      {required int page, required int size, required String userId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getRequestList}/$userId?page=$page&size=$size";
    return url;
  }

  String getAllLucidData(
      {required int page,
      required int size,
      required String serviceName,
      required String hc}) {
    String url =
        "${RestConstants.instance.apiLucidService}${RestConstants.instance.getAllLucidData}?serviceName=$serviceName&homeCollection=$hc&page=$page&size=$size";
    return url;
  }

  String getDiagnosticUserDetails({
    required String userId,
    required String isHomeCollection,
  }) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getTestPatientDetails}userId/$userId/isHomeCollection/$isHomeCollection";
    return url;
  }

  String getCartTests({required String userId, required String hv}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getAllTests}/userId/$userId/hv/$hv";
    return url;
  }

  String getlucidDataByDepartment(
      {required int page, required int size, required String serviceName}) {
    String url =
        "${RestConstants.instance.apiLucidService}${RestConstants.instance.getlucidByDepartment}?serviceName=$serviceName&page=$page&size=$size";
    return url;
  }

  String getHomeBanners({required String row, required String appName}) {
    String url =
        "${RestConstants.instance.apiBanner}${RestConstants.instance.getHomeBanners}/$row/appName/$appName";

    return url;
  }

  String getAllBranches() {
    String url =
        "${RestConstants.instance.apiLucidService}${RestConstants.instance.getAllBranches}";
    return url;
  }

  String getLucidUserUpcomingStatus(
      {required String userId,
      required int page,
      required int status,
      required int size}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getLucidUserUpcomingStatus}?userId=$userId&status=$status&page=$page&size=$size&sort=string";
    return url;
  }

  String getAllAddress({required String userId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllAddress}/$userId";

    return url;
  }

  String getAllDoctors(
      {required int page,
      required int size,
      required String specialisation,
      required String doctorName}) {
    if (specialisation.isEmpty && doctorName.isEmpty) {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllDoctors}?page=$page&size=$size&sort=experience,desc";

      return url;
    } else if (specialisation.isEmpty && doctorName.isNotEmpty) {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllDoctors}?doctorName=$doctorName&page=$page&size=$size&sort=experience,desc";

      return url;
    } else if (specialisation.isNotEmpty && doctorName.isEmpty) {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllDoctors}?specializationId=$specialisation&page=$page&size=$size&sort=experience,desc";

      return url;
    } else {
      String url =
          "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllDoctors}?specializationId=$specialisation&doctorName=$doctorName&page=$page&size=$size&sort=experience,desc";

      return url;
    }
  }

  String getDoctorDetails(String doctorId) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getDoctorDetailsById}/$doctorId";
    return url;
  }

  String getBookedDetailsById(String userId, String testId) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getLucidOrderById}/id/$testId/userId/$userId";
    return url;
  }

  String getAllTests({required String userId}) {
    String url =
        "${RestConstants.instance.apiLucidCart}${RestConstants.instance.getAllTests}/userId/$userId";
    return url;
  }

  String getReviewsbyId({required String doctorId}) {
    String url =
        "${RestConstants.instance.apiReview}${RestConstants.instance.getReviewById}/$doctorId";
    return url;
  }

  String getAppointmentOverview({required String appintmentId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.bookingOverview}/$appintmentId";

    return url;
  }

  String getAppWideCart({required String userId}) {
    String url =
        "${RestConstants.instance.apiCart}${RestConstants.instance.getAppWideCart}/$userId";

    return url;
  }

  String getUserCart({required String userId}) {
    String url =
        "${RestConstants.instance.apiCart}${RestConstants.instance.getUSerCart}/$userId";

    return url;
  }

  String getMedicineOrderDetail(
      {required String userId, required String orderId}) {
    String url =
        "${RestConstants.instance.apiOMS}${RestConstants.instance.getMedOrderDetail}/$userId/order/$orderId";

    return url;
  }

  String getRequestDetail({required String requestId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getRequestDetail}/$requestId";

    return url;
  }

  String getProductDetails({required String productId}) {
    String url =
        "${RestConstants.instance.apiProduct}${RestConstants.instance.getProductDetails}/$productId";

    return url;
  }

  String getAppointmentDetails({required String appointmentId}) {
    String url =
        "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAppointmentDetails}/$appointmentId";

    return url;
  }

  String getAllNgoId({required int page, required int size}) {
    String url =
        "${RestConstants.instance.apingo}${RestConstants.instance.getAllNgoId}?page=$page&size=$size&sort=string";

    return url;
  }

  String getSpecialisationList(String councelling) {
    String url = councelling == ''
        ? "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllSpecialisation}"
        : "${RestConstants.instance.apiAuthentication}${RestConstants.instance.getAllSpecialisation}$councelling";
    return url;
  }

  String getByNgoId({required String ngoId}) {
    String url =
        "${RestConstants.instance.apingo}${RestConstants.instance.getByNgoId}?id=$ngoId";

    return url;
  }

  Map<String, dynamic> deleteAllLabTest(
      {required String cartId, required String isHomeCollection}) {
    Map<String, dynamic> map = {};

    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.deleteCart}/id/$cartId/isHomeCollection/$isHomeCollection';

    return map;
  }

  Map<String, dynamic> cancelOrReschedulePayload(
      {required String cartId,
      required String status,
      required String date,
      required String comment}) {
    // Creating the payload
    Map<String, dynamic> map = {};

    // Adding the URL for the endpoint
    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.cancelOrReschedule}/id/$cartId';

    // Adding the body for the POST request
    map["body"] = {
      "status": status,
      "rescheduleDate": date,
      "comments": comment,
    };

    return map;
  }

  //DELETE CALLS
  Map<String, dynamic> deleteMedicineCart({
    required String userId,
    required String cartId,
    required String storeId,
  }) {
    Map<String, dynamic> map = {};
    map["url"] =
        '${RestConstants.instance.apiCart}${RestConstants.instance.deleteMedicineCart}/$cartId/store/$storeId/user/$userId';
    return map;
  }

  Map<String, dynamic> deleteLabTest({
    required String userId,
    required String serviceCd,
    required String hv,
  }) {
    Map<String, dynamic> map = {};
    map["url"] =
        '${RestConstants.instance.apiLucidCart}${RestConstants.instance.deleteTest}/userId/$userId/serviceCd/$serviceCd/hv/$hv';
    return map;
  }
}
