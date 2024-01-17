import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config/app_color.dart';

toastMessage(String text, Color color) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: color,
    fontSize: 14,
    textColor: AppColors.whiteColor,
  );
}
