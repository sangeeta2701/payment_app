import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

Widget scanShortcuts(IconData icon, VoidCallback onpress, String title) {
     return Column(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: greyColor.withOpacity(0.3),
                  child: IconButton(onPressed: onpress, icon: Icon(icon, color: whiteColor,size: 18.sp,)),
                ),
                height4,
                Text(title, style: AppTextStyles.whiteContentTextStyle,)
              ],
            );
   }
