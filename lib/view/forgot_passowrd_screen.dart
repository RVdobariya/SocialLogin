import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';
import '../config/app_textStyle.dart';
import '../controller/auth_controller.dart';
import '../widgets/common_button.dart';
import '../widgets/common_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightprimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    AppImages.appLogo,
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text("SangamSutra", style: TextStyle(color: AppColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold, height: -0.1)),
                ),
                const SizedBox(height: 80),
                Text("Forgot Password", style: AppTextStyle.medium.copyWith(fontSize: 25, color: AppColors.primaryColor)),
                const SizedBox(height: 30),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Obx(() {
                          return CommonTextField(
                            validationMessage: "Email id",
                            isEmailValidator: true,
                            needValidation: true,
                            hintText: 'Email id',
                            controller: authController.forgotEmailId.value,
                            prefix: const Icon(
                              CupertinoIcons.mail_solid,
                              color: AppColors.greyColor,
                              size: 20,
                            ),
                          );
                        }),
                        const SizedBox(height: 60),
                        Center(
                            child: GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    debugPrint("email${authController.forgotEmailId.value.text}");
                                    await FireBaseAuth.resetPassword(isLoader: true, email: authController.forgotEmailId.value.text.toString())
                                        .whenComplete(() {
                                      authController.forgotEmailId.value.clear();
                                    });
                                  }
                                },
                                child: customButton(text: "Next"))),
                      ],
                    )),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Back to Sign in",
                        style: AppTextStyle.medium.copyWith(fontSize: 14, color: AppColors.primaryColor),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
