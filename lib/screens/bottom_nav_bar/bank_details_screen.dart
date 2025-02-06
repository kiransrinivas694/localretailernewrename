import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bank_details_controller.dart';
import 'package:b2c/screens/auth/sign_up_2_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailsController>(
      init: BankDetailsController(),
      builder: (bankDetailsController) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const CommonText(
                content: "Bank details", boldNess: FontWeight.w600),
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.appGradientColor,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: CommonText(
                          content: "Bank details",
                          textSize: 18,
                          textColor: AppColors.textColor,
                          boldNess: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            buildTextFormField(
                              'Enter account holder name',
                              bankDetailsController.accountNameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32)
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter account number',
                              bankDetailsController.accountNumberController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(32),
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter IFSC number',
                              bankDetailsController.ifscController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter branch name',
                              bankDetailsController.bankBranchController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter bank name',
                              bankDetailsController.bankNameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32)
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter upi phone number',
                              bankDetailsController.upiPhoneNumberController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildTextFormField(
                              'Enter UPI ID',
                              bankDetailsController.upiIdController,
                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(32)
                              // ],
                            ),
                            const SizedBox(height: 16),
                            // buildTextFormField(
                            //   'Enter google pay number',
                            //   bankDetailsController.googlePayController,
                            //   keyboardType:
                            //       const TextInputType.numberWithOptions(),
                            //   isVerified:
                            //       bankDetailsController.googlePayVerified,
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(10),
                            //     FilteringTextInputFormatter.digitsOnly
                            //   ],
                            // ),
                            // const SizedBox(height: 16),
                            // buildTextFormField(
                            //   'Enter phone pay number',
                            //   bankDetailsController.phonePayController,
                            //   keyboardType:
                            //       const TextInputType.numberWithOptions(),
                            //   isVerified:
                            //       bankDetailsController.phonePayVerified,
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(10),
                            //     FilteringTextInputFormatter.digitsOnly
                            //   ],
                            // ),
                            // const SizedBox(height: 16),
                            // buildTextFormField(
                            //   'Enter paytm number',
                            //   bankDetailsController.paytmController,
                            //   keyboardType:
                            //       const TextInputType.numberWithOptions(),
                            //   isVerified: bankDetailsController.paytmVerified,
                            //   inputFormatters: [
                            //     LengthLimitingTextInputFormatter(10),
                            //     FilteringTextInputFormatter.digitsOnly
                            //   ],
                            // ),
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: () => bankDetailsController
                                  .validateBankDetailsForm(),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const AppText(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  color: AppColors.appWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (bankDetailsController.isLoading)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.appWhite.withOpacity(0.4),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor)),
                ),
            ],
          ),
        );
      },
    );
  }

  Padding buildTextFormField(String name, TextEditingController editController,
      {TextInputType? keyboardType,
      bool? isVerified,
      List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            name,
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isVerified == null
                    ? AppColors.borderColor
                    : isVerified
                        ? AppColors.greenColor
                        : AppColors.redColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: editController,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: name,
                hintStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
