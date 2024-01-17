import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';

void showLoadingDialog() {
  Future.delayed(
    Duration.zero,
    () {
      Get.dialog(
        useSafeArea: true,
        barrierColor: AppColors.whiteColor.withOpacity(0.5),
        Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AppImages.appLogo,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ))),
        // ),
        barrierDismissible: false,
      );
    },
  );
}

void hideLoadingDialog({bool istrue = false}) {
  Get.back(closeOverlays: istrue);
}
