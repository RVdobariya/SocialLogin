import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_color.dart';
import '../config/app_textStyle.dart';
import '../config/validation_helper.dart';
import '../controller/auth_controller.dart';

class CommonTextField extends StatelessWidget {
  final bool isSignupScreen;
  final AuthController? authController;
  final TextEditingController controller;
  final String? validationMessage;
  final Function(String)? onChange;
  final bool? needValidation;
  final bool? isEmailValidator;
  final bool isPasswordValidator;
  final bool isConfPassValidator;
  final bool isCardValidator;
  final bool isCVCValidator;
  final bool isExpiryYearValidator;
  final bool isExpiryMonthValidator;
  final bool isPhoneNumberValidator;
  final bool isPinCodeValidator;
  final bool isExpiryDateValidator;
  final bool isGenderValidator;
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillClr;
  final Color? enableBorder;
  final Color? hintClr;
  final Color? focusBorder;
  final Color? border;
  final Color? cursorClr;
  final Color? fontClr;
  final bool? obscure;
  final double? height;
  final double? hintSize;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final bool? readOnly;
  final int? maxLength;
  final int? maxLine;
  final BorderRadius? borderRadius;
  final double? containerHeight;

  const CommonTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefix,
      this.isSignupScreen = false,
      this.suffix,
      this.contentPadding,
      this.fillClr,
      this.enableBorder,
      this.authController,
      this.hintClr,
      this.focusBorder,
      this.border,
      this.cursorClr,
      this.obscure,
      this.height,
      this.fontClr,
      this.hintSize,
      this.validationMessage,
      this.readOnly = false,
      this.needValidation = false,
      this.isEmailValidator = false,
      this.isPasswordValidator = false,
      this.isConfPassValidator = false,
      this.isCardValidator = false,
      this.isCVCValidator = false,
      this.isExpiryYearValidator = false,
      this.isExpiryMonthValidator = false,
      this.isPhoneNumberValidator = false,
      this.isPinCodeValidator = false,
      this.isGenderValidator = false,
      this.onChange,
      this.textInputType,
      this.inputFormatters,
      this.isExpiryDateValidator = false,
      this.autoFocus = false,
      this.focusNode,
      this.maxLength,
      this.maxLine,
      this.borderRadius,
      this.containerHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: containerHeight ?? 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(color: AppColors.blackColor.withOpacity(0.1), blurRadius: 5, spreadRadius: 0),
            ],
          )),
      TextFormField(
        maxLength: maxLength,
        maxLines: maxLine ?? 1,
        readOnly: readOnly!,
        focusNode: focusNode,
        autofocus: autoFocus!,
        obscureText: obscure ?? false,
        cursorColor: cursorClr ?? AppColors.blackColor,
        keyboardType: textInputType ?? TextInputType.text,
        inputFormatters: inputFormatters ?? [],
        controller: controller,
        style: AppTextStyle.font14.copyWith(fontWeight: FontWeight.w400, color: fontClr ?? AppColors.blackColor),
        onChanged: onChange,
        decoration: InputDecoration(
          filled: true,
          suffixIcon: suffix,
          prefixIcon: prefix,
          contentPadding: contentPadding ?? const EdgeInsets.only(top: 16, left: 14, right: 14),
          hintText: hintText,
          hintStyle: AppTextStyle.regular.copyWith(fontWeight: FontWeight.w500, fontSize: hintSize ?? 14, color: hintClr ?? Colors.grey),
          fillColor: AppColors.whiteColor,
          enabledBorder: OutlineInputBorder(borderRadius: borderRadius ?? BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.transparent)),
          border: OutlineInputBorder(borderRadius: borderRadius ?? BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.transparent)),
          disabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(borderRadius: borderRadius ?? BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.transparent)),
          errorBorder:
              OutlineInputBorder(borderRadius: borderRadius ?? BorderRadius.circular(10), borderSide: const BorderSide(width: 0, color: Colors.transparent)),
          focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
        ),
        validator: needValidation!
            ? (v) {
                return TextFieldValidation.validation(
                    authController: authController,
                    isSignupScreen: isSignupScreen,
                    isConfPassValidator: isConfPassValidator,
                    isEmailValidator: isEmailValidator!,
                    isPasswordValidator: isPasswordValidator,
                    isPhoneNumberValidator: isPhoneNumberValidator,
                    isPinCodeValidator: isPinCodeValidator,
                    isCardValidator: isCardValidator,
                    isCVCValidator: isCVCValidator,
                    isGenderValidator: isGenderValidator,
                    isExpiryDateValidator: isExpiryDateValidator,
                    message: validationMessage,
                    value: v!.trim());
              }
            : null,
      )
    ]);
  }
}

showDialogBox(BuildContext context,
    {String? title,
    String? subTitle,
    String? buttontext,
    String? buttontext1,
    double? height,
    double? width,
    bool canpop = true,
    double? fontSize,
    Function()? onTap,
    Function()? onTap1,
    double? imageSize,
    String? image,
    Color? color}) {
  debugPrint("image image image $image");
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          onPopInvoked: (v) {},
          canPop: canpop,
          child: AlertDialog(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (image != null) Image.asset(image, height: imageSize ?? 50, width: imageSize ?? 50, color: color),
              const SizedBox(width: 5),
              Text(title!, style: AppTextStyle.medium.copyWith(color: AppColors.primaryColor, fontSize: fontSize ?? 20, fontWeight: FontWeight.w900))
            ]),
            content: Text(subTitle!, textAlign: TextAlign.center, style: AppTextStyle.medium.copyWith(color: AppColors.greyColor)),
            actions: [
              if (onTap != null && onTap1 != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: height ?? 36,
                        width: width ?? 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.primaryColor), color: AppColors.whiteColor),
                        child: Center(
                          child: Text(buttontext ?? 'No',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.medium.copyWith(fontSize: 15, color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     await Get.offAll(
                    //         const LoginScreen());
                    //   },
                    //   child: Text('Yes',
                    //       textAlign:
                    //           TextAlign.center,
                    //       style: AppTextStyle.medium
                    //           .copyWith(
                    //               color: AppColors
                    //                   .pink700,
                    //               fontWeight:
                    //                   FontWeight
                    //                       .w500)),
                    // ),
                    GestureDetector(
                        onTap: onTap1,
                        child: Container(
                          alignment: Alignment.center,
                          height: height ?? 36,
                          width: width ?? 80,
                          decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            buttontext1 ?? "Yes",
                            style: const TextStyle(fontSize: 16, fontFamily: "lexend", fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                          ),
                        ))
                  ],
                ),
              const SizedBox(height: 10)
            ],
          ),
        );
      });
}
