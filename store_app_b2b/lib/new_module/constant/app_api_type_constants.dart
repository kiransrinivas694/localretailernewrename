class ApiTypes {
  //POST Types
  static const String sendLoginOtp = "sendLoginOtp";
  static const String verifyLoginOtp = "verifyLoginOtp";
  static const String sendOtp = "sendOtp";
  static const String verifyOtp = "verifyOtp";
  static const String signUp = "signUp";
  static const String deletePrescription = "deletePrescription";
  static const String deleteAllCart = "deleteAllCart";
  static const String uploadPrescription = "uploadPrescription";
  static const String saveRecentView = "saveRecentView";
  static const String consultDoctor = "consultDoctor";
  static const String continueWithoutPrescription =
      "continueWithoutPrescription";
  static const String addToCartInProduct = "addToCartInProduct";
  static const String addToCartUpdateInProduct = "addToCartUpdateInProduct";
  static const String beforeCheckout = "beforeCheckout";
  static const String afterCheckout = "afterCheckout";
  static const String postDoctorAppointment = "postDoctorAppointment";
  static const String addTest = "addTest";
  static const String saveLucidPatient = "saveLucidPatient";
  static const String getByAchieversId = "getByAchieversId";
  static const String findBranch = "findBranch";
  static const String prescriptionUpload = "prescriptionUpload";
  static const String postReview = "postReview";
  static const String diagnosticCheckOut = "diagnosticCheckOut";
  //PUT Types
  static const String cancelCart = "cancelCart";
  static const String getLiveVideosList = 'getLiveVideosList';
  static const String rebookTest = "rebookTest";

  //GET Types
  static const String getAllTopDoctors = 'getAllTopDoctors';
  static const String rescheduleDate = "rescheduleDate";
  static const String getAllAchievers = "getAllAchievers";
  static const String getAppointmentHistory = "getAppointmentHistory";
  static const String referralCheck = 'referralCheck';
  static const String getAllBranches = "getAllBranches";
  static const String getAllCategories = "getAllCategories";
  static const String getNewlyLaunchedProducts = "getNewlyLaunchedProducts";
  static const String getViewAllProducts = "getViewAllProducts";
  static const String getRecentViewedProducts = "getRecentViewedProducts";
  static const String getMedOrdersList = "getMedOrdersList";
  static const String getRequestList = "getRequestList";
  static const String getCategoryWiseProducts = "getCategoryWiseProducts";
  static const String getTopSellingProducts = "getTopSellingProducts";
  static const String getSpecialisationList = 'getSpecialisationList';
  static const String getAllDoctors = 'getAllDoctors';
  static const String getAllLucidData = "getAllLucidData";
  static const String getAppWideCart = "getAppWideCart";
  static const String getDoctorDetailsById = 'getDoctorDetailsById';
  static const String getUserCart = "getUserCart";
  static const String getMedicineOrderDetail = "getMedicineOrderDetail";
  static const String getRequestDetail = "getRequestDetail";
  static const String getProductDetails = 'getProductdetails';
  static const String getAppointmentDetails = 'getAppointmentDetails';
  static const String getAllNgoId = "getAllNgoId";
  static const String getAppointmentOverview = "getAppointmentOverview";
  static const String getHomeBanners = "getHomeBanners";
  static const String getRelationList = 'getRelationList';
  static const String getReviewsById = 'getReviewsById';
  static const String getLucidUserUpcomingStatus = "getLucidUserUpcomingStatus";
  static const String getBookedTestDetails = "getBookedTestDetails";
  static const String getAllHealthPackages = 'getAllHealthPackages';
  static const String getAlAddress = "getAllAddress";
  static const String getAddAddress = "getAddAddress";
  static const String deleteAddress = "deleteAddress";
  static const String getByNgoId = "getByNgoId";
  static const String getAllTests = "getAllTests";
  static const String getHealthPackageDetails = "getHealthPackageDetails";
  static const String getLucidByDepartment = "getLucidByDepartment";
  static const String getByDiseaseId = 'getByDiseaseId';
  static const String getviewPackageCart = "getviewPackageCart  ";
  static const String getCartTests = "getCartTests";
  static const String getTestUserDetails = 'getTestUserDetails';
  //DELETE Types
  static const String deleteTest = "deleteTest";
  static const String deleteAllTest = "deleteAllTest";

  //VALUE CHECK TYPES
  static const String fromCartMedicinesTab = "fromCartMedicinesTab";
  static const String fromProfileScreen = "fromProfileScreen";
  static const String getCity = "getCity";
}
