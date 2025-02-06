import 'dart:io';
import 'package:b2c/helper/firebase_gettoken_backup.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/helper/firebase_token_storeb2b_helper_new.dart';
import 'package:store_app_b2b/new_module/constant/app_api_type_constants.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/model/appointment/appointment_details_response.dart';
import 'package:store_app_b2b/new_module/model/appointment/appointment_history.dart';
import 'package:store_app_b2b/new_module/model/appointment/doctor_details_by_id.dart';
import 'package:store_app_b2b/new_module/model/appointment/doctor_list_model.dart';
import 'package:store_app_b2b/new_module/model/appointment/reviews_by_id.dart';
import 'package:store_app_b2b/new_module/model/appointment/specialisation_list.dart';
import 'package:store_app_b2b/new_module/model/relaton_model.dart';
import 'package:store_app_b2b/new_module/screens/appointments/patient_details_form.dart';
import 'package:store_app_b2b/new_module/services/new_apiresponse.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service.dart';
import 'package:store_app_b2b/new_module/services/payloads.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;
import 'package:store_app_b2b/utils/shar_preferences_new.dart'
    as store_app_b2b_shar;

class BooikingAppointmentController extends GetxController
    implements APiResponseFlow {
  int? doctorIndex;
  bool? topDoctors;
  int specialisationIndex = 0;
  String specialisation = '';
  String specialisationName = '';
  String doctorName = '';
  RxString selectedDoctorName = ''.obs;
  RxList<DoctorsDetails> doctorsList = <DoctorsDetails>[].obs;
  var doctorDetails = Rx<DoctorsDetails?>(null);
  var reviewsList = <ReviewDetails>[].obs;
  RxString selectedDoctor = ''.obs;
  // String? appointmentId;
  List favorites = [].obs;
  DateTime? selectedDate;
  Slot slot = Slot();
  // String selectedTime = "";
  int selectedtimeIndex = -1;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  int? currentTime;
  List<Slot> slots = [];
  int? slotTime;
  int appointmentIndex = -1;
  bool rebook = false;

  var appointmentSingleDetail = Rx<AppointmentDetailModel?>(null);
  final isAppointmentDetailsLoading = false.obs;

  var showSuffixForSearchDoctorController = false.obs;

  /// ---- GET APPOINTMNET DETAILS API STARTS HERE ---- ///
  Future<void> getAppointmentDetails(
      {String endpoint = "", required String appointmentId}) async {
    try {
      isAppointmentDetailsLoading.value = true;

      await RestServices.instance.getRestCall<AppointmentDetailResponse>(
        fromJson: (json) {
          return appointmentDetailResponseFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAppointmentDetails(appointmentId: appointmentId),
        flow: this,
        apiType: ApiTypes.getAppointmentDetails,
      );
    } catch (e) {
      logs('error -> ${e.toString()}');
      isAppointmentDetailsLoading.value = false;
      // customFailureToast(content: e.toString());
    }
  }

  Future<void> getAppointmentDetailsOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) async {
    AppointmentDetailResponse productResponse =
        data as AppointmentDetailResponse;

    if (productResponse.status != null &&
        productResponse.status! &&
        productResponse.data != null) {
      appointmentSingleDetail.value = productResponse.data;

      logs("logsing detail");
    } else {
      appointmentSingleDetail.value = null;
    }

    isAppointmentDetailsLoading.value = false;
  }

  Future<void> getAppointmentDetailsOnFailure(
      String message, String apiType, Map<String, dynamic> info) async {
    isAppointmentDetailsLoading.value = false;
    // customFailureToast(content: message);
  }

  /// ---- GET APPOINTMNET DETAILS API ENDS HERE ---- ///

  void chechValidationDateAndTime() {
    if (selectedDate == null) {
      customFailureToast(content: 'Please select date');
    } else if (selectedDate!.weekday == DateTime.sunday) {
      customFailureToast(content: 'Please choose another date');
    } else if (selectedTime == '') {
      customFailureToast(content: 'Please select time');
    } else {
      Get.to(() => const PatientDetailsForm());
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String? selectedRelationValue;
  String? selectedGenderValue;

  void checkValidationForPatientDetails() {
    String name = nameController.text;
    String age = ageController.text;
    String height = heightController.text;
    String weight = weightController.text;
    String phone = phoneNumberController.text;
    if (selectedRelationValue == null &&
        name.isEmpty &&
        age.isEmpty &&
        selectedGenderValue == null &&
        phone.isEmpty &&
        weight.isEmpty &&
        height.isEmpty) {
      customFailureToast(content: 'Please enter details');
    } else if (selectedRelationValue == null) {
      customFailureToast(content: 'Please select relation');
    } else if (name.isEmpty) {
      customFailureToast(content: 'Please enter full name');
    } else if (name.length <= 2) {
      fieldLengthCheck(value: name, fieldName: 'Full name');
    } else if (age.isEmpty) {
      customFailureToast(content: 'Please enter age');
    } else if (age == '0') {
      customFailureToast(content: 'Please enter age more than 0');
    } else if (selectedGenderValue == null) {
      customFailureToast(content: 'Please select gender');
    } else if (phone.isEmpty) {
      customFailureToast(content: 'Please enter phone number');
    } else if (age == '0') {
      customFailureToast(content: 'Please enter age more than 0');
    } else if (height == '0') {
      customFailureToast(content: 'Please enter valid height');
    } else if (weight == '0') {
      customFailureToast(content: 'Please enter valid weight');
    } else if (phoneNumberController.text.isNotEmpty &&
        phoneNumberController.text.length != 10) {
      customFailureToast(content: "Phone number must be 10 digits");
    } else {
      sendAppointmentRequest();
    }
  }

  // RxInt getDoctorsTotalPages = 0.obs;
  // RxInt getDoctorsCurrentPage = 0.obs;
  var isDoctorListLoading = false.obs;
  var isMoreDoctorsLoading = false.obs;
  RxInt doctorsTotalPages = 0.obs;
  RxInt doctorsCurrentPage = 0.obs;
  RxInt doctorsPageSize = 100.obs;
  String selectedTime = '';
  Future<void> getAllDoctors({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
  }) async {
    // logs(
    //     "logsing ${Payloads().getAllDoctors(specialisation: specialisation, doctorName: doctorName)}");
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    try {
      if (finalLoadMore) {
        if (doctorsCurrentPage.value >= doctorsTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        isMoreDoctorsLoading.value = true;
      } else {
        isDoctorListLoading.value = true;
      }

      // isDoctorListLoading.value = true;
      await RestServices.instance.getRestCall<DoctorsListModel>(
        fromJson: (json) {
          return doctorsListModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAllDoctors(
                specialisation: specialisation,
                doctorName: doctorName,
                page: doctorsCurrentPage.value,
                size: doctorsPageSize.value,
              ),
        flow: this,
        info: {"loadMore": finalLoadMore},
        apiType: ApiTypes.getAllDoctors,
      );
    } catch (e) {
      if (finalLoadMore) {
        isMoreDoctorsLoading.value = false;
      } else {
        isDoctorListLoading.value = false;
      }
      // customFailureToast(content: e.toString());
    }
  }

  void gertAllDoctorsOnSuccess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    DoctorsListModel modelData = data as DoctorsListModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        doctorsList.addAll(modelData.data!.content!);
        isMoreDoctorsLoading.value = false;
      } else {
        doctorsList.value = modelData.data!.content!;
        isDoctorListLoading.value = false;
      }
      logs(' ${doctorsList.length}');

      doctorsCurrentPage.value = modelData.data!.number!.toInt() + 1;
      doctorsTotalPages.value = modelData.data!.totalPages!.toInt();
      // logs(
      //     'total pages${doctorsTotalPages.value = modelData.data!.totalPages!.toInt()}');
      // logs(
      //     'current pages${doctorsCurrentPage.value = modelData.data!.number!.toInt()}');

      //   logs(
      //       "logsing newly launched products length -> ${newlyLaunchedProducts.length}");
      // }
      return;
    }
    if (info["loadMore"]) {
      isMoreDoctorsLoading.value = false;
    } else {
      isDoctorListLoading.value = false;
    }
  }

  void getDoctorsOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    // customFailureToast(content: message);
    if (info["loadMore"]) {
      isMoreDoctorsLoading.value = false;
    } else {
      isDoctorListLoading.value = false;
    }
  }

  var istopDoctorListLoading = false.obs;
  var isMoreTopDoctorsLoading = false.obs;
  RxInt topDoctorsTotalPages = 0.obs;
  RxInt topDoctorsCurrentPage = 0.obs;
  RxInt topDoctorsPageSize = 100.obs;
  Future<void> getAllTopDoctors({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
  }) async {
    // logs(
    //     "logsing ${Payloads().getAllDoctors(specialisation: specialisation, doctorName: doctorName)}");

    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    try {
      if (finalLoadMore) {
        if (topDoctorsCurrentPage.value >= topDoctorsTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        isMoreTopDoctorsLoading.value = true;
      } else {
        istopDoctorListLoading.value = true;
      }

      // istopDoctorListLoading.value = true;
      await RestServices.instance.getRestCall<DoctorsListModel>(
        fromJson: (json) {
          return doctorsListModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAllTopDoctors(
                specialisation: specialisation,
                doctorName: doctorName,
                page: topDoctorsCurrentPage.value,
                size: topDoctorsPageSize.value,
              ),
        flow: this,
        info: {"loadMore": finalLoadMore},
        apiType: ApiTypes.getAllTopDoctors,
      );
    } catch (e) {
      if (finalLoadMore) {
        isMoreTopDoctorsLoading.value = false;
      } else {
        istopDoctorListLoading.value = false;
      }
      // customFailureToast(content: e.toString());
    }
  }

  void getAllTopDoctorsOnSuccess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    DoctorsListModel modelData = data as DoctorsListModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        doctorsList.addAll(modelData.data!.content!);
        isMoreTopDoctorsLoading.value = false;
      } else {
        doctorsList.value = modelData.data!.content!;
        istopDoctorListLoading.value = false;
      }
      logs(' ${doctorsList.length}');

      topDoctorsCurrentPage.value = modelData.data!.number!.toInt() + 1;
      topDoctorsTotalPages.value = modelData.data!.totalPages!.toInt();
      return;
    }
    if (info["loadMore"]) {
      isMoreTopDoctorsLoading.value = false;
    } else {
      istopDoctorListLoading.value = false;
    }
  }

  void getTopDoctorsOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    // customFailureToast(content: message);
    if (info["loadMore"]) {
      isMoreTopDoctorsLoading.value = false;
    } else {
      istopDoctorListLoading.value = false;
    }
  }

  String counselling = '';
  RxBool isSpecialisationloading = false.obs;
  RxList<DoctorSpecialisations> doctorSpecialisationList =
      <DoctorSpecialisations>[].obs;
  Future<void> getAllSpecialisations({String endpoint = ""}) async {
    try {
      doctorSpecialisationList.value = [];
      isSpecialisationloading.value = true;
      await RestServices.instance.getRestCall<SpecialisationList>(
        fromJson: (json) {
          return specialisationListFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getSpecialisationList(counselling),
        flow: this,
        apiType: ApiTypes.getSpecialisationList,
      );
    } catch (e) {
      isSpecialisationloading.value = false;

      // customFailureToast(content: e.toString());
      logs("logs error -> ${e.toString()}");
    }
    update();
  }

  void gertAllSpecialisationOnSuccess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    SpecialisationList modelData = data as SpecialisationList;

    if (modelData.data != null &&
        modelData.data != null &&
        modelData.data!.isNotEmpty) {
      doctorSpecialisationList.value = modelData.data!;

      specialisationIndex = 0;

      // specialisation = modelData.data![0].id ?? '';
      doctorsList.value = [];
      doctorsCurrentPage.value = 0;
      favorites = [];
      getAllDoctors();

      //   logs(
      //       "logsing newly launched products length -> ${newlyLaunchedProducts.length}");
      // }
    }
    isSpecialisationloading.value = false;
  }

  String doctorId = '';
  RxBool isDoctorDetailsLoading = false.obs;
  Future<void> getdoctorDetailsById({String endpoint = ""}) async {
    try {
      isDoctorDetailsLoading.value = true;
      await RestServices.instance.getRestCall<DoctorDetailsById>(
        fromJson: (json) {
          return doctorDetailsByIdFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getDoctorDetails(doctorId),
        flow: this,
        apiType: ApiTypes.getDoctorDetailsById,
      );
    } catch (e) {
      isDoctorDetailsLoading.value = false;

      // customFailureToast(content: e.toString());
      logs("logs error -> ${e.toString()}");
    }
    update();
  }

  void getDoctorDetailsByIdOnSucess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    DoctorDetailsById modelData = data as DoctorDetailsById;

    if (modelData.data != null) {
      doctorDetails.value = modelData.data!;
    }
    isDoctorDetailsLoading.value = false;
  }

  var appointmentHistoryLoading = false.obs;
  var isMoreAppointmentsLoading = false.obs;
  RxInt appointmentHistoryPageSize = 8.obs;
  RxInt appointmentHistoryTotalPages = 0.obs;
  RxInt appointmentHistoryCurrentPage = 0.obs;
  String status = '';
  var appointmentDetails = <AppointmentDetails>[].obs;
  Future<void> getAppointmentHistory({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
  }) async {
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    String userId = await getUserId();
    try {
      if (finalLoadMore) {
        if (appointmentHistoryCurrentPage.value >=
            appointmentHistoryTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        isMoreAppointmentsLoading.value = true;
      } else {
        appointmentDetails.value = [];
        appointmentHistoryTotalPages.value = 0;
        appointmentHistoryCurrentPage.value = 0;
        appointmentHistoryLoading.value = true;
      }

      await RestServices.instance.getRestCall<AppointmentHistory>(
        fromJson: (json) {
          return appointmentHistoryFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAppointmentHistory(
                page: appointmentHistoryCurrentPage.value,
                size: appointmentHistoryPageSize.value,
                status: status,
                userId: userId,
              ),
        flow: this,
        info: {"loadMore": finalLoadMore},
        apiType: ApiTypes.getAppointmentHistory,
      );
    } catch (e) {
      logs("logs error -> ${e.toString()}");
      if (finalLoadMore) {
        isMoreAppointmentsLoading.value = false;
      } else {
        appointmentHistoryLoading.value = false;
      }
      customFailureToast(content: e.toString());
    }
  }

  void getAppointmentOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    customFailureToast(content: message);
    if (info["loadMore"]) {
      isMoreAppointmentsLoading.value = false;
    } else {
      appointmentHistoryLoading.value = false;
    }
  }

  RxString doctorEducation = ''.obs;
  RxString doctorImageUrl = ''.obs;
  RxString hospitalName = ''.obs;
  RxString doctorExperience = ''.obs;
  RxString specializationId = ''.obs;
  RxString specialization = ''.obs;
  RxString hospitalId = ''.obs;
  RxString languages = ''.obs;
  RxString consultationFees = ''.obs;

  RxBool isAppointmentRequestLoading = false.obs;
  Future<void> sendAppointmentRequest({String endPoint = ''}) async {
    String userId = await getUserId();
    var deviceToken = await getFirebaseTokenStoreb2b();
    String companyName =
        await SharPreferences.getString(SharPreferences.storeName);

    String storeNumber = await store_app_b2b_shar.SharPreferences.getString(
        SharPreferences.storeNumber);

    String ownerName = await store_app_b2b_shar.SharPreferences.getString(
        SharPreferences.ownerNameNew);
    try {
      isAppointmentRequestLoading.value = true;

      Map<String, dynamic> body = {
        "appointmentDate": dateFormat.format(selectedDate!),
        "doctorId": selectedDoctor.value,
        "doctorName": selectedDoctorName.value,
        "doctorEducation": doctorEducation.value,
        "doctorImageUrl": doctorImageUrl.value,
        "hospitalName": hospitalName.value,
        "doctorExperience": doctorExperience.value,
        "specializationId": specializationId.value,
        "specialization": specialization.value,
        "hospitalId": hospitalId.value,
        "userId": userId,
        "slot": {
          "id": slot.doctorId,
          "slotName": slot.slotName,
          "startTime": slot.startTime,
          "endTime": slot.endTime,
          "displayOrder": slot.displayOrder,
          "checked": true
        },
        "languages": languages.value,
        "consultationFees": consultationFees.value,
        "userName": nameController.text,
        "userMobileNumber": phoneNumberController.text,
        "dateOfBirth": '2002-01-14',
        "age": int.parse(ageController.text),
        "relation": selectedRelationValue,
        "gender": selectedGenderValue,
        "height": heightController.text.isEmpty
            ? null
            : double.parse(heightController.text),
        "weight": weightController.text.isEmpty
            ? null
            : double.parse(weightController.text),
        "fcmToken": deviceToken,
        "retailerId": userId, //id
        "retailerName": ownerName, //ownerName
        "storeName": companyName, //storeName
        "retailerPhoneNumber": storeNumber //storeNumber
      };

      await RestServices.instance.postRestCall(
          body: body,
          endpoint: endPoint.isNotEmpty
              ? endPoint
              : Payloads().postAppointmentRequest(),
          flow: this,
          apiType: ApiTypes.postDoctorAppointment);
    } on SocketException catch (e) {
      logs('Catch exception in sendOtp --> ${e.message}');
    }
    isAppointmentRequestLoading.value = false;
  }

  RxBool isReviewsLoading = false.obs;
  Future<void> getReviewsByDoctorId({String endpoint = ""}) async {
    try {
      isReviewsLoading.value = true;
      await RestServices.instance.getRestCall<ReviewsById>(
        fromJson: (json) {
          return reviewsByIdFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getReviewsbyId(doctorId: selectedDoctor.value),
        flow: this,
        apiType: ApiTypes.getReviewsById,
      );
    } catch (e) {
      isReviewsLoading.value = false;
      // customFailureToast(content: e.toString());
    }
    update();
  }

  void getReviewsById<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    ReviewsById modelData = data as ReviewsById;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      reviewsList.value = modelData.data!.content!;
    }
  }

  void postAppointmentRequest<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    Map<String, dynamic> response = data as Map<String, dynamic>;
    if (response.containsKey("status") && response["status"]) {
      // appointmentId = response['data']['id'].toString();
      nameController.clear();
      dobController.clear();
      ageController.clear();
      weightController.clear();
      heightController.clear();
      phoneNumberController.clear();
      selectedRelationValue = null;
      selectedGenderValue = null;
      String rawDate = dateFormat.format(selectedDate!);
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(rawDate);
      String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);
      Get.dialog(
          barrierDismissible: false,
          WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: themeController.textPrimaryColor,
                    borderRadius: BorderRadius.circular(48)),
                width: 90.w,
                padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 130,
                      width: 130,
                      child: AppImageAsset(
                          image: 'assets/images/appointment_confirmation.png'),
                    ),
                    const Gap(30),
                    AppText(
                      'Congratulations!',
                      color: themeController.black500Color,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    const Gap(5),
                    AppText(
                      'Your appointment with $selectedDoctorName is scheduled for $formattedDate.',
                      color: themeController.black100Color,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: () {
                        // Get.delete<BottomBarController>();
                        // status = 'P';
                        // getAppointmentHistory();
                        // BottomBarController bbController =
                        //     Get.find<BottomBarController>();
                        // bbController.currentSelectedIndex = 2;
                        // bbController.update();

                        // Get.offAll(() => const DashboardScreen());
                        // Get.to(() => const MyBookingsScreen());
                        Get.offAll(() => const home.HomeScreen());
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: themeController.primary500Color,
                        ),
                        child: AppText(
                          'Done',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: themeController.textPrimaryColor,
                        ), //inter
                      ),
                    ),
                    const Gap(15),
                  ],
                ),
              ),
            ),
          ));
    } else {
      isAppointmentRequestLoading.value = false;
      customFailureToast(content: AppString.failureText);
    }
  }

  void getAppointmentsOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) {
    logs("logsing getappointmntsonsuccess is called");
    AppointmentHistory modelData = data as AppointmentHistory;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        appointmentDetails.addAll(modelData.data!.content!);
        isMoreAppointmentsLoading.value = false;
      } else {
        appointmentDetails.value = modelData.data!.content!;
        appointmentHistoryLoading.value = false;
      }

      appointmentHistoryCurrentPage.value = modelData.data!.number!.toInt() + 1;
      appointmentHistoryTotalPages.value = modelData.data!.totalPages!.toInt();

      return;
    }

    if (info["loadMore"]) {
      isMoreAppointmentsLoading.value = false;
    } else {
      appointmentHistoryLoading.value = false;
    }
  }

  List<String> relationList = [];
  List<String> relationList2 = ['All'];
  RxBool isrelationListLoading = false.obs;
  Future<void> getRelationList({String endpoint = ""}) async {
    relationList = [];
    relationList2 = ['All'];
    try {
      isrelationListLoading.value = true;
      await RestServices.instance.getRestCall<RelationsModel>(
        fromJson: (json) {
          return relationsModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty ? endpoint : Payloads().getRelationUrl(),
        flow: this,
        apiType: ApiTypes.getRelationList,
      );
    } catch (e) {
      isrelationListLoading.value = false;
      logs("logs error -> ${e.toString()}");
    }
    update();
  }

  void getRelationListOnSucess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    RelationsModel modelData = data as RelationsModel;

    if (modelData.data != null) {
      relationList = modelData.data!;
      relationList2.addAll(modelData.data!);
      // relationList2 = modelData.data!;
    }
    isrelationListLoading.value = false;
  }

  @override
  void onFailure(
    String message,
    String apiType,
    Map<String, dynamic> info,
  ) {
    if (apiType == ApiTypes.getAllDoctors) {
      getDoctorsOnFailure(message, apiType, info);
    }

    if (apiType == ApiTypes.getAllTopDoctors) {
      getTopDoctorsOnFailure(message, apiType, info);
    }

    if (apiType == ApiTypes.getSpecialisationList) {
      // customFailureToast(content: message);
      isSpecialisationloading.value = false;
    }

    if (apiType == ApiTypes.getDoctorDetailsById) {
      // customFailureToast(content: message);
      isDoctorDetailsLoading.value = false;
    }

    if (apiType == ApiTypes.postDoctorAppointment) {
      // customFailureToast(content: message);
      isAppointmentRequestLoading.value = false;
    }

    if (apiType == ApiTypes.getReviewsById) {
      // customFailureToast(content: message);
      isReviewsLoading.value = false;
    }

    if (apiType == ApiTypes.getAppointmentHistory) {
      getAppointmentOnFailure(message, apiType, info);
    }

    if (apiType == ApiTypes.getRelationList) {
      isrelationListLoading.value = false;
    }
  }

  @override
  void onSuccess<T>(
    T? data,
    String apiType,
    Map<String, dynamic> info,
  ) {
    if (apiType == ApiTypes.getAppointmentDetails) {
      getAppointmentDetailsOnSuccess(data, apiType, info);
    }
    if (apiType == ApiTypes.getAllDoctors) {
      gertAllDoctorsOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.getAllTopDoctors) {
      getAllTopDoctorsOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.getDoctorDetailsById) {
      getDoctorDetailsByIdOnSucess(data, apiType, info);
    }

    if (apiType == ApiTypes.getSpecialisationList) {
      gertAllSpecialisationOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.postDoctorAppointment) {
      postAppointmentRequest(data, apiType, info);
    }

    if (apiType == ApiTypes.getAppointmentHistory) {
      getAppointmentsOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.getRelationList) {
      getRelationListOnSucess(data, apiType, info);
    }
  }

  @override
  void onTokenExpired(
      String apiType, String endPoint, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllDoctors) {
      getAllDoctors(endpoint: endPoint, retryInfo: info);
    }

    if (apiType == ApiTypes.getAllDoctors) {
      getAllTopDoctors(endpoint: endPoint, retryInfo: info);
    }

    if (apiType == ApiTypes.getSpecialisationList) {
      getAllSpecialisations(endpoint: endPoint);
    }

    if (apiType == ApiTypes.getDoctorDetailsById) {
      getdoctorDetailsById(endpoint: endPoint);
    }

    if (apiType == ApiTypes.postDoctorAppointment) {
      sendAppointmentRequest(endPoint: endPoint);
    }

    if (apiType == ApiTypes.getAppointmentHistory) {
      getAppointmentHistory(endpoint: endPoint, retryInfo: info);
    }

    if (apiType == ApiTypes.getRelationList) {
      getRelationList(endpoint: endPoint);
    }
  }
}
