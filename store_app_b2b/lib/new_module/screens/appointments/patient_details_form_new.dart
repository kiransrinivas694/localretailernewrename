import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_dropdown_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class PatientDetailsForm extends StatefulWidget {
  const PatientDetailsForm({super.key});

  @override
  State<PatientDetailsForm> createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm> {
//  customFailureToast(content: 'Please enter details');
  final ThemeController themeControllerr = Get.find();
  bool isMonthDropdownOpen = false;
  String? selectedMonthValue = 'New User';

  List<String> dropdownMonthItems = ['New User', 'Existing User'];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooikingAppointmentController>(
        init: BooikingAppointmentController(),
        initState: (state) {
          BooikingAppointmentController controller =
              Get.put(BooikingAppointmentController());
          if (controller.rebook) {
            controller.nameController.text = controller
                    .appointmentDetails[controller.appointmentIndex].userName ??
                '';
            controller.selectedRelationValue = controller
                .appointmentDetails[controller.appointmentIndex].relation;
            controller.selectedGenderValue = controller
                .appointmentDetails[controller.appointmentIndex].gender;
            controller.ageController.text = controller
                .appointmentDetails[controller.appointmentIndex].age
                .toString();
            controller.weightController.text =
                '${controller.appointmentDetails[controller.appointmentIndex].weight?.toInt() ?? ''}';
            controller.phoneNumberController.text = controller
                    .appointmentDetails[controller.appointmentIndex]
                    .userMobileNumber ??
                '';
            controller.heightController.text =
                "${controller.appointmentDetails[controller.appointmentIndex].height?.toInt() ?? ''}";
          }
        },
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: const AppAppBar(
                title: 'Book Slots',
              ),
              // bottomNavigationBar: AppBottomBa(
              //   index: 3,
              //   useIndexFromController: false,
              // ),
              body: Obx(
                () => controller.isAppointmentRequestLoading.value
                    ? AppLoader()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Gap(20),
                              SizedBox(
                                width: double.infinity,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double maxWidth = constraints.maxWidth;

                                    return AppDropdown(
                                      hintText: 'Relation',
                                      valuesList: controller.relationList,
                                      // const [
                                      //   'Self',
                                      //   'Father',
                                      //   'Mother',
                                      //   'Wife',
                                      //   'Husband',
                                      //   'Daughter',
                                      //   'Son',
                                      //   'Sister',
                                      //   'Brother',
                                      //   'friend',
                                      //   'Others'
                                      // ],
                                      themeController: themeController,
                                      itemsWidth: maxWidth - 20,
                                      dropdownIconShowOnSelect: true,
                                      selectedValue:
                                          controller.selectedRelationValue,
                                      selectedTextAlignment: TextAlign.left,
                                      onValueChanged: (p0) async {
                                        // String user = await getUserId();
                                        // String mobile = await getMobileNumber();
                                        // if (p0 == 'Self') {
                                        //   setState(() {
                                        //     controller.nameController.text = user;
                                        //     controller.phoneNumberController.text =
                                        //         mobile;
                                        //     controller.selectedRelationValue = p0 ?? '';
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     controller.nameController.clear();
                                        //     controller.phoneNumberController.clear();
                                        //     controller.selectedRelationValue = p0 ?? '';
                                        //   });
                                        // }
                                        setState(() {
                                          controller.selectedRelationValue =
                                              p0 ?? '';
                                        });
                                      },
                                      containerBorderRadius: 4,
                                    );
                                  },
                                ),
                              ),
                              const Gap(20),
                              AppTextField(
                                formattersList: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'[a-zA-Z\s]')), // Only allows alphabetic characters
                                ],
                                labelText: "Full Name",
                                borderColor: themeControllerr.nav4,
                                textEditingController:
                                    controller.nameController,
                                floatingLabelBehaviour:
                                    FloatingLabelBehavior.auto,
                                borderWidth: 1,
                                labelSize: 16,
                                labelColor: themeControllerr.black500Color,
                              ),
                              const Gap(20),
                              // AppTextField(
                              //     readOnly: true,
                              //     labelText: "DOB (YYYY-MM-DD)",
                              //     textKeyboardtype: TextInputType.number,
                              //     borderColor: themeControllerr.nav4,
                              //     textEditingController: controller.dobController,
                              //     floatingLabelBehaviour: FloatingLabelBehavior.auto,
                              //     borderWidth: 1,
                              //     labelSize: 16,
                              //     labelColor: themeControllerr.black500Color,
                              //     onTap: () async {
                              //       final now = DateTime.now();
                              //       // final firstDate =
                              //       //     DateTime(now.year - 1, now.month, now.day);
                              //       final lastDate =
                              //           DateTime(now.year, now.month, now.day);
                              //       DateTime? pickedDate = await showDatePicker(
                              //         context: Get.context!,
                              //         initialDate: now,
                              //         firstDate: DateTime(1900),
                              //         lastDate: lastDate,
                              //       );
                              //       if (pickedDate != null) {
                              //         setState(() {
                              //           controller.dobController.text =
                              //               DateFormat('yyyy-MM-dd').format(pickedDate);
                              //         });
                              //       }
                              //     }),
                              // const Gap(20),
                              AppTextField(
                                labelText: "Age",
                                maxlenght: 3,
                                textKeyboardtype: TextInputType.number,
                                borderColor: themeControllerr.nav4,
                                textEditingController: controller.ageController,
                                floatingLabelBehaviour:
                                    FloatingLabelBehavior.auto,
                                borderWidth: 1,
                                labelSize: 16,
                                labelColor: themeControllerr.black500Color,
                              ),
                              const Gap(20),
                              SizedBox(
                                width: double
                                    .infinity, // The Container will take the full width of its parent
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double maxWidth = constraints.maxWidth;
                                    return AppDropdown(
                                      hintText: 'Gender',
                                      valuesList: const [
                                        'Male',
                                        'Female',
                                        'Others'
                                      ],
                                      themeController: themeController,
                                      itemsWidth: maxWidth - 20,
                                      dropdownIconShowOnSelect: true,
                                      selectedValue:
                                          controller.selectedGenderValue,
                                      selectedTextAlignment: TextAlign.left,
                                      onValueChanged: (p0) {
                                        setState(() {
                                          controller.selectedGenderValue =
                                              p0 ?? '';
                                        });
                                      },
                                      containerBorderRadius: 4,
                                    );
                                  },
                                ),
                              ),
                              const Gap(20),
                              AppTextField(
                                labelText: "Phone Number",
                                textKeyboardtype: TextInputType.number,
                                borderColor: themeControllerr.nav4,
                                textEditingController:
                                    controller.phoneNumberController,
                                floatingLabelBehaviour:
                                    FloatingLabelBehavior.auto,
                                borderWidth: 1,
                                labelSize: 16,
                                formattersList: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                labelColor: themeControllerr.black500Color,
                              ),
                              const Gap(20),
                              AppTextField(
                                labelText: "Height (cm) (optional)",
                                borderColor: themeControllerr.nav4,
                                formattersList: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Allow only digits
                                ],
                                textKeyboardtype: TextInputType.number,
                                textEditingController:
                                    controller.heightController,
                                floatingLabelBehaviour:
                                    FloatingLabelBehavior.auto,
                                borderWidth: 1,
                                labelSize: 16,
                                labelColor: themeControllerr.black500Color,
                              ),
                              const Gap(20),
                              AppTextField(
                                labelText: "Weight (kg) (optional)",
                                formattersList: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Allow only digits
                                ],
                                textKeyboardtype: TextInputType.number,
                                borderColor: themeControllerr.nav4,
                                textEditingController:
                                    controller.weightController,
                                floatingLabelBehaviour:
                                    FloatingLabelBehavior.auto,
                                borderWidth: 1,
                                labelSize: 16,
                                labelColor: themeControllerr.black500Color,
                              ),
                              const Gap(50),
                              // controller.isAppointmentRequestLoading.value
                              //     ? Container(
                              //         height: 50,
                              //         alignment: Alignment.center,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(50),
                              //           color: themeController.primary500Color,
                              //         ),
                              //         child: const CircularProgressIndicator(), //inter
                              //       )
                              //     :
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  controller.checkValidationForPatientDetails();
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: themeController.primary500Color,
                                  ),
                                  child: AppText(
                                    'Confirm',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: themeController.textPrimaryColor,
                                  ), //inter
                                ),
                              ),
                              const Gap(20),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
        });
  }
}
