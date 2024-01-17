// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';
import '../config/constant.dart';
import '../widgets/common_loading_dialog.dart';
import '../widgets/common_toast.dart';

class AuthController extends GetxController {
  Rx<TextEditingController> emailId = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
  RxBool obSecure = true.obs;
  Rx<TextEditingController> forgotEmailId = TextEditingController().obs;

  Rx<TextEditingController> newEmailId = TextEditingController().obs;
  Rx<TextEditingController> newPassword = TextEditingController().obs;
  Rx<TextEditingController> newConfirmPassword = TextEditingController().obs;
  RxBool newObSecure1 = true.obs;
  RxBool newObSecure2 = true.obs;
}

class FireBaseAuth {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({required BuildContext context, required String title}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  static Future<User?> signUp({required String email, required String password, required BuildContext context}) async {
    try {
      UserCredential data = await kFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      // data.user!.uid;
      return data.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("code ==== ${e.code.toString()}");
      if (e.code == 'network-request-failed') {
        toastMessage("No Internet Connection.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN UP TIME == No Internet Connection.');
        // showSnackBar(context: context, title: "No Internet Connection.");
      } else if (e.code == 'too-many-requests') {
        toastMessage("Too many attempts please try later.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN UP TIME == Too many attempts please try later');
        // showSnackBar(context: context, title: "Too many attempts please try later.");
      } else if (e.code == 'weak-password') {
        toastMessage("The password provided is too weak.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN UP TIME == The password provided is too weak.');
        // showSnackBar(context: context, title: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        toastMessage("Email adrsss already exists", Colors.red);
        debugPrint('ERROR CREATE ON SIGN UP TIME == The account already exists for that email.');
        // showSnackBar(context: context, title: "The account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        toastMessage("The email address is not valid.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN UP TIME == The email address is not valid.');
        // showSnackBar(context: context, title: "The email address is not valid.");
      } else {
        toastMessage("Something went to Wrong.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN IN TIME ==  Something went to Wrong.');
        // showSnackBar(context: context, title: "Something went to wrong.");
      }
      return null;
    }
  }

  static Future<bool> login({required String email, required String password, required BuildContext context}) async {
    try {
      await kFirebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("error == ${e.code}");
      if (e.code == 'network-request-failed') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == No Internet Connection.');
        toastMessage("No Internet Connection.", Colors.red);
        // showSnackBar(context: context, title: "No Internet Connection.");
      } else if (e.code == 'too-many-requests') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == Too many attempts please try later');
        toastMessage("Too many attempts please try later.", Colors.red);

        // showSnackBar(context: context, title: "Too many attempts please try later.");
      } else if (e.code == 'user-not-found') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == No user found for that email.');
        toastMessage("User does not exists", Colors.red);
        // showSnackBar(context: context, title: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        toastMessage("Invalid email or password", Colors.red);
        debugPrint('ERROR CREATE ON SIGN IN TIME == The password is invalid for the given email.');
        // showSnackBar(context: context, title: "The password is invalid for the given email.");
      } else if (e.code == 'invalid-email') {
        toastMessage("Invalid email or password", Colors.red);
        debugPrint('ERROR CREATE ON SIGN IN TIME == The email address is not valid.');
        // showSnackBar(context: context, title: "The email address is not valid.");
      } else if (e.code == 'user-disabled') {
        toastMessage("The user corresponding to the given email has been disabled.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN IN TIME ==  The user corresponding to the given email has been disabled.');
        // showSnackBar(context: context, title: "The user corresponding to the given email has been disabled.");
      } else if (e.code == "invalid-credential") {
        toastMessage("user does not register or check your credential", Colors.red);
        debugPrint('user does not register');
        // showSnackBar(context: context, title: "user does not register or check your credential");
      } else {
        toastMessage("Something went to Wrong.", Colors.red);
        debugPrint('ERROR CREATE ON SIGN IN TIME ==  Something went to Wrong.');
        // showSnackBar(context: context, title: "Something went to wrong.");
      }
      return false;
    }
  }

  static getUserInfo() {
    debugPrint("UID == >${FirebaseAuth.instance.currentUser!.uid}");
    debugPrint("EMAIL == >${FirebaseAuth.instance.currentUser!.email}");
  }

  static Future logOut() async {
    FirebaseAuth.instance.signOut();
  }

  static Future resetPassword({isLoader = false, required String email}) async {
    if (isLoader) {
      showLoadingDialog();
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      toastMessage("Password reset link sent to $email Successfully", AppColors.primaryColor);
      if (isLoader) {
        hideLoadingDialog();
      }
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (isLoader) {
        hideLoadingDialog();
      }
      debugPrint("reset pass error : $e");
      if (e.code == 'network-request-failed') {
        toastMessage("No Internet Connection.", AppColors.primaryColor);
      } else if (e.code == 'too-many-requests') {
        toastMessage("Too many attempts please try later.", AppColors.primaryColor);
      } else if (e.code == 'user-not-found') {
        toastMessage("No user found for that email.", AppColors.primaryColor);
      } else if (e.code == 'invalid-email') {
        toastMessage("The email address is not valid.", AppColors.primaryColor);
      } else {
        toastMessage("Something went to wrong.", AppColors.primaryColor);
      }
    }
  }
  // static Future<bool> sendPasswordReset(String email) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   try {
  //     await auth.sendPasswordResetEmail(email: email);
  //     // If the email was sent successfully, return true (email exists)
  //     debugPrint("send::::::::======>");
  //     return true;
  //   } catch (e) {
  //     debugPrint('Error sending password reset email: $e');
  //     // Check the error message to determine if the email doesn't exist
  //     if (e is FirebaseAuthException && e.code == 'user-not-found') {
  //       // If the error code is 'user-not-found', it means the email is not registered
  //       return false;
  //     }
  //     // Handle other potential errors
  //     return false;
  //   }
  // }
}
