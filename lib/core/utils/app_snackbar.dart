import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class AppSnackbar {
  static void show(BuildContext context, String message) {
    // 1. Clear any current snackbars so this one shows immediately
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeColorLight,
        behavior: SnackBarBehavior.floating,
        // Ensure margin is set for floating behavior
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1, // Positions it higher
          left: 16.w,
          right: 16.w,
        ),
        // FIX: Change BorderRadiusGeometry to BorderRadius
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        content: Text(
          message, 
          style: AppTextStyles.blackDescriptionTextStyle,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}