import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

Widget featureShortcuts(IconData icon, String title) {
    return Column(
      
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: themeColor,
                    child: Icon(icon, color: whiteColor,size: 16.h,),
                  ),
                  height4,
                  Text(title, style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 12.sp),textAlign: TextAlign.center,)
                ],
              );
  }