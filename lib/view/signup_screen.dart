import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demotask/view/login_screen.dart';
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
import '../widgets/common_toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.lightprimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Center(child: Image.asset(AppImages.appLogo, height: 140, width: 140)),
                  const SizedBox(height: 80),
                  Text("Sign Up", style: AppTextStyle.medium.copyWith(fontSize: 25, color: AppColors.primaryColor)),
                  const SizedBox(height: 20),
                  CommonTextField(
                      needValidation: true,
                      isEmailValidator: true,
                      validationMessage: "Email id",
                      hintText: 'Email id',
                      controller: authController.newEmailId.value,
                      prefix: const Icon(CupertinoIcons.mail_solid, color: AppColors.greyColor, size: 20)),
                  const SizedBox(height: 10),
                  Obx(() {
                    return CommonTextField(
                        isSignupScreen: true,
                        needValidation: true,
                        isPasswordValidator: true,
                        validationMessage: "Password",
                        hintText: 'Password',
                        controller: authController.newPassword.value,
                        obscure: authController.newObSecure1.value,
                        suffix: InkWell(
                            onTap: () {
                              authController.newObSecure1.value = !authController.newObSecure1.value;
                            },
                            child: Icon(authController.newObSecure1.value ? Icons.remove_red_eye : Icons.visibility_off, color: AppColors.greyColor, size: 20)),
                        prefix: const Icon(Icons.lock, color: AppColors.greyColor, size: 20));
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return CommonTextField(
                        needValidation: true,
                        authController: authController,
                        isSignupScreen: true,
                        isConfPassValidator: true,
                        validationMessage: "Confirm password",
                        hintText: 'Confirm password',
                        controller: authController.newConfirmPassword.value,
                        obscure: authController.newObSecure2.value,
                        suffix: InkWell(
                            onTap: () {
                              authController.newObSecure2.value = !authController.newObSecure2.value;
                            },
                            child: Icon(authController.newObSecure2.value ? Icons.remove_red_eye : Icons.visibility_off, color: AppColors.greyColor, size: 20)),
                        prefix: const Icon(Icons.lock, color: AppColors.greyColor, size: 20));
                  }),
                  const SizedBox(height: 40),
                  Center(
                      child: GestureDetector(
                          onTap: () async {
                            /*          final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection('user').get();
                            final List<String> documents = result.docs.map((e) => e.id).toList();
                            debugPrint("doc data == $documents");
                            if (documents.contains(authController.emailId.value.text)) {
                              final DocumentSnapshot<Map<String, dynamic>> results =
                                  await FirebaseFirestore.instance.collection('user').doc(authController.emailId.value.text).get();
                              final data = results.data();
                              if (data!['is_email'] == true) {
                                debugPrint("You are already register, please Login using email");
                              } else {
                                debugPrint("you have to login using google");
                              }
                            } else {
                              FirebaseFirestore.instance.collection('user').doc(authController.emailId.value.text).set({
                                'emailID': authController.emailId.value.text,
                                'password': authController.newPassword.value.text,
                                'is_Email': true,
                                'is_google': false
                              });
                            }*/
                            if (formKey.currentState!.validate()) {
                              User? valueOfSignUp = await FireBaseAuth.signUp(
                                  email: authController.newEmailId.value.text, password: authController.newPassword.value.text, context: context);
                              if (valueOfSignUp != null) {
                                showLoadingDialog();
                                await sharedPreferences!.setString("token", FirebaseAuth.instance.currentUser!.uid);

                                try {
                                  await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                    'emailID': authController.newEmailId.value.text,
                                    "u_id": FirebaseAuth.instance.currentUser!.uid,
                                  });

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
                                  } else {
                                    hideLoadingDialog();
                                    // Get.offAll(() => const LoginScreen(), transition: Transition.rightToLeft);
                                  }

                                  // Get.offAll(() => const LoginScreen(), transition: Transition.rightToLeft);
                                  hideLoadingDialog();
                                } on FirebaseAuthException catch (e) {
                                  hideLoadingDialog();
                                  debugPrint("$e");
                                }
                              }
                            }
                          },
                          child: customButton(text: "Sign Up"))),
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
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.greyColor), color: AppColors.whiteColor, borderRadius: BorderRadius.circular(100)),
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
                        var data = await signInWithGoogle(context: context, authController: authController);
                        if (data != null) {
                          showLoadingDialog();
                          if (sharedPreferences!.getString("token") != null) {
                            DocumentSnapshot<Map<String, dynamic>> data =
                                await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).get();
                            Map<String, dynamic>? datas = data.data();
                            if (datas!['is_delete'] == true) {
                              sharedPreferences!.clear();
                              FireBaseAuth.logOut();
                              hideLoadingDialog();
                              toastMessage("Your account has been deactivate\nPlease contact customer care", Colors.red);
                            } else {
                              FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(sharedPreferences!.getString("token"))
                                  .update({"fcm_token": sharedPreferences!.getString("fcm_token")});
                              /*final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection('user').get();
                    final List<String> documents = result.docs.map((e) => e.id).toList();
                    debugPrint("doc data == $documents");*/
                              /*final DocumentSnapshot<Map<String, dynamic>> results =
                                await FirebaseFirestore.instance.collection('user').doc(sharedPreferences!.getString("token")).get();
                            final data = results.data();*/
                              sharedPreferences!.setBool("profile_setup", data['profile_setup']);
                              sharedPreferences!.setBool("interest_fill", data['interest_fill']);
                              await sharedPreferences!.setString("first_name", data['first_name']);
                              await sharedPreferences!.setString("profile_pic", data['profile_image']);
                              if (data['profile_setup'] == true) {
                                if (data['interest_fill'] == true) {
                                  hideLoadingDialog();
                                  // Get.to(() => const BottomScreen(), transition: Transition.rightToLeft);
                                  /* Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => const BottomScreen(),
                                    ),
                                    ModalRoute.withName('bottomscreen'),
                                  );*/
                                } else {
                                  hideLoadingDialog();
                                  /*  Get.to(
                                      () => const InterestScreen(
                                            isStartPage: true,
                                          ),
                                      transition: Transition.rightToLeft);*/
                                }
                              } else {
                                hideLoadingDialog();
                                // Get.to(() => const ProfileViewScreen(), transition: Transition.rightToLeft);
                              }
                            }
                          } else {
                            hideLoadingDialog();
                            // Get.offAll(() => const LoginScreen(), transition: Transition.rightToLeft);
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
                              "Signup with google",
                              style: AppTextStyle.medium.copyWith(fontSize: 14),
                            ),
                            const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ? ",
                        style: AppTextStyle.medium.copyWith(fontSize: 14, color: AppColors.blackColor),
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.off(() => const LoginScreen(), transition: Transition.rightToLeft);
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }

  static Future<User?> signInWithGoogle({required BuildContext context, AuthController? authController}) async {
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

        user = userCredential.user;
        bool isNew = userCredential.additionalUserInfo!.isNewUser;
        var token = sharedPreferences!.getString("fcm_token").toString();
        if (isNew) {
          FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
            'emailID': user.email,
            'is_Email': false,
            'is_google': true,
            "profile_setup": false,
            "interest_fill": false,
            "u_id": user.uid,
            "profile_image": "",
            "first_name": "",
            "last_name": "",
            "bio": "",
            "dob": "",
            "likes": [],
            "liked": [],
            "matches": [],
            "gender": "",
            "mobile_no": "",
            "otherImages": [],
            "country": "",
            "city": "",
            "state": "",
            "interest": [],
            "fcm_token": token,
            "is_delete": false,
            "online": false
          });
          await FirebaseFirestore.instance.collection('notification').doc(user.uid).set({'message': []});
          await sharedPreferences!.setString("userId", user.uid);
          await sharedPreferences!.setString("token", user.uid);
          hideLoadingDialog();
        } else {
          hideLoadingDialog();
          toastMessage("You are already register!\nPlease login using google", Colors.red);
          return null;
          // FirebaseFirestore.instance.collection('user').doc(user!.uid).update({"fcm_token": token});
        }

        debugPrint("isNew === $isNew");
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
