import 'dart:async';

import 'package:demotask/view/home_page.dart';
import 'package:demotask/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    debugPrint("sharedPreferences!.getString ${sharedPreferences!.getString("token")}");
    Timer(const Duration(seconds: 3), () async {
      if (sharedPreferences!.getString("token") != null) {
        Get.offAll(() => HomePage());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        color: AppColors.lightprimaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.appLogo, height: 160, width: 160),
          const SizedBox(height: 8),
          /*const Text("SangamSutra",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),*/
          const SizedBox(height: 10)
        ],
      ),
    ));
  }
}
