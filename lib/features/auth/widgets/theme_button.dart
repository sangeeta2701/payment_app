 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

Widget themeButton(VoidCallback onpress, String btnText,   BuildContext context) {
    return SizedBox(
      width: double.infinity,
                      height: 48.h,
      child: ElevatedButton(
                        onPressed:onpress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                          elevation: 0,
                        ),
                        child: Text(
                          btnText,
                          style: AppTextStyles.whiteContentTextStyle(context).copyWith(
                            fontSize: 15.sp,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
    );
  }