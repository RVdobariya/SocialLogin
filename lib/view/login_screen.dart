import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demotask/view/home_page.dart';
import 'package:demotask/view/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';
import '../config/app_textStyle.dart';
import '../controller/auth_controller.dart';
import '../main.dart';
import '../widgets/common_button.dart';
import '../widgets/common_loading_dialog.dart';
import '../widgets/common_textfield.dart';
import 'forgot_passowrd_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      await FirebaseMessaging.instance.getToken().then((value) async {
        await sharedPreferences!.setString("fcm_token", value.toString());
        debugPrint("=-=-=-=-=fcmToken=-=-=-=-=> ${sharedPreferences!.getString("fcm_token")}");
      }).catchError((e) {
        debugPrint("firebase Error == $e");
      });
    } catch (e) {
      debugPrint("error == $e");
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        showLoadingDialog();
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        debugPrint("============");
        user = userCredential.user;
        bool isNew = userCredential.additionalUserInfo!.isNewUser;
        var token = sharedPreferences!.getString("fcm_token").toString();
        if (isNew) {
          await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
            'emailID': user.email,
            "u_id": user.uid,
          });
        }
        await sharedPreferences!.setString("userId", user!.uid);
        await sharedPreferences!.setString("token", user.uid);
        hideLoadingDialog();
        debugPrint("++$isNew");
      } on FirebaseAuthException catch (e) {
        hideLoadingDialog();
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        hideLoadingDialog();
        // handle the error here
      }
    }
    return user;
  }
}

class _LoginScreenState extends State<LoginScreen> {
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
                  child: Image.asset(AppImages.appLogo, height: 140, width: 140),
                ),
                const SizedBox(height: 80),
                Text("Sign In", style: AppTextStyle.medium.copyWith(fontSize: 25, color: AppColors.primaryColor)),
                const SizedBox(height: 20),
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
                              controller: authController.emailId.value,
                              prefix: const Icon(CupertinoIcons.mail_solid, color: AppColors.greyColor, size: 20));
                        }),
                        const SizedBox(height: 10),
                        Obx(() {
                          return CommonTextField(
                              needValidation: true,
                              validationMessage: "Password",
                              isPasswordValidator: true,
                              hintText: 'Password',
                              controller: authController.password.value,
                              obscure: authController.obSecure.value,
                              suffix: InkWell(
                                  onTap: () {
                                    authController.obSecure.value = !authController.obSecure.value;
                                  },
                                  child:
                                      Icon(authController.obSecure.value ? Icons.remove_red_eye : Icons.visibility_off, color: AppColors.greyColor, size: 20)),
                              prefix: const Icon(Icons.lock, color: AppColors.greyColor, size: 20));
                        }),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const ForgotPasswordScreen(), transition: Transition.rightToLeft);
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: AppTextStyle.regular.copyWith(color: AppColors.primaryColor, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                            child: GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool valueOfSignUp = await FireBaseAuth.login(
                                        email: authController.emailId.value.text, password: authController.password.value.text, context: context);
                                    debugPrint("valueOfSignUp **** $valueOfSignUp");
                                    if (valueOfSignUp) {
                                      showLoadingDialog();
                                      DocumentSnapshot<Map<String, dynamic>> data =
                                          await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).get();
                                      var datas = data.data();
                                      await sharedPreferences!.setString("userId", FirebaseAuth.instance.currentUser!.uid);
                                      await sharedPreferences!.setString("token", FirebaseAuth.instance.currentUser!.uid);
                                      if (sharedPreferences!.getString("token") != null) {
                                        try {
                                          await FirebaseMessaging.instance.getToken().then((value) async {
                                            await sharedPreferences!.setString("fcm_token", value.toString());
                                          }).catchError((e) {
                                            debugPrint("firebase Error == $e");
                                          });
                                        } catch (e) {
                                          debugPrint("error == $e");
                                        }
                                        var token = sharedPreferences!.getString("fcm_token").toString();
                                        await FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(sharedPreferences!.getString("token"))
                                            .update({"fcm_token": token});
                                        final DocumentSnapshot<Map<String, dynamic>> results =
                                            await FirebaseFirestore.instance.collection('user').doc(sharedPreferences!.getString("token")).get();
                                        final data = results.data();
                                      } else {
                                        hideLoadingDialog();
                                      }
                                    }
                                  }
                                },
                                child: customButton(text: "Sign In"))),
                      ],
                    )),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 0.7, color: AppColors.greyColor),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                      decoration:
                          BoxDecoration(border: Border.all(color: AppColors.greyColor), color: AppColors.whiteColor, borderRadius: BorderRadius.circular(100)),
                      child: Text("OR", style: AppTextStyle.medium.copyWith(fontSize: 12)),
                    ),
                    Expanded(
                      child: Container(height: 0.7, color: AppColors.greyColor),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final done = await LoginScreen.signInWithGoogle(context: context);
                      if (done != null) {
                        showLoadingDialog();
                        if (sharedPreferences!.getString("token") != null) {
                          Get.to(
                            () => HomePage(),
                          );

                          /*final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection('user').get();
                        final List<String> documents = result.docs.map((e) => e.id).toList();
                        debugPrint("doc data == $documents");*/
                        } else {
                          hideLoadingDialog();
                          Get.offAll(() => const LoginScreen(), transition: Transition.rightToLeft);
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppColors.greyColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(AppImages.google),
                          ),
                          Text(
                            "Login with google",
                            style: AppTextStyle.medium.copyWith(fontSize: 14),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyle.medium.copyWith(fontSize: 14, color: AppColors.blackColor),
                    ),
                    InkWell(
                        onTap: () {
                          Get.off(() => SignupScreen(), transition: Transition.rightToLeft);
                        },
                        child: Text(
                          "Sign Up",
                          style: AppTextStyle.medium.copyWith(fontSize: 14, color: AppColors.primaryColor),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
