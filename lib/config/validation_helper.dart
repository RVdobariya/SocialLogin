import '../controller/auth_controller.dart';

class TextFieldValidation {
  TextFieldValidation._();

  static String? validation({
    String? value,
    String? message,
    AuthController? authController,
    bool isEmailValidator = false,
    bool isPasswordValidator = false,
    bool isSignupScreen = false,
    bool isConfPassValidator = false,
    bool isPhoneNumberValidator = false,
    bool isPinCodeValidator = false,
    bool isCardValidator = false,
    bool isGenderValidator = false,
    bool isCVCValidator = false,
    // bool isExpiryYearValidator = false,
    // bool isExpiryMonthValidator = false,
    bool isExpiryDateValidator = false,
  }) {
    if (value!.isEmpty) {
      return "$message is required!";
    }
    if (isPhoneNumberValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 10 || value.length > 10) {
        return 'Phone number must be 10 character!';
      }
    }
    if (isGenderValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.toString() != "Male" && value.toString() != "Female" && value.toString() != "Other") {
        return 'Please enter Valid Gender(Male - Female - Other)';
      }
    }

    if (isPinCodeValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 6 || value.length > 6) {
        return 'Pincode number must be 6 character!';
      }
    }
    if (isCardValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 16) {
        return 'Card number must be 16 digit!';
      }
    }
    if (isCVCValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 3) {
        return 'Enter valid CVC!';
      }
    }
    if (isConfPassValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else {
        if (isSignupScreen) {
          if (authController!.newPassword.value.text != value.toString()) {
            return "Password does not match";
          }
        } else {
          if (authController!.password.value.text != value.toString()) {
            return "Password does not match";
          }
        }
      }
    }
    if (isExpiryDateValidator == true) {
      final DateTime now = DateTime.now();
      final List<String> date = value.split(RegExp(r'/'));
      final int month = int.parse(date.first);
      final int year = int.parse('20${date.last}');
      final int lastDayOfMonth = month < 12 ? DateTime(year, month + 1, 0).day : DateTime(year + 1, 1, 0).day;
      final DateTime cardDate = DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);
      if (value.isEmpty) {
        return "$message is required!";
      } else if (cardDate.isBefore(now) || month > 12 || month == 0) {
        return 'Enter valid Expiry Date';
      }
      return null;
    }
    // if (isExpiryMonthValidator == true) {
    //   if (value.isEmpty) {
    //     return "$message is required!";
    //   }
    // }

    if (isEmailValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return 'Enter Valid $message';
      }
    }
    if (isPasswordValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (isSignupScreen) {
        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#/$&*~]).{8,}$').hasMatch(value)) {
          if (value.length < 8) {
            return 'Password must have at least 8 characters!';
          } else if (!value.contains(RegExp(r'[a-z]')) ||
              !value.contains(RegExp(r'[A-Z]')) ||
              !value.contains(RegExp(r'[0-9]')) ||
              !value.contains(RegExp(r'[!@#/$&*~]'))) {
            return 'Password must contain at least one uppercase,\none lowercase, one numeric & one special character';
          }
        }
      }
    }

    return null;
  }
}
