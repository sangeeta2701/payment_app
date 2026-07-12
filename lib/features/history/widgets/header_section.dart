import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "History",
            style: AppTextStyles.headingBlackTextStyle(context).copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.arrow_downward, size: 14.sp, color: blackColor),
            label: Text(
              "My Statements",
              style: AppTextStyles.greyContentTextStyle(context).copyWith(
                fontSize: 10.sp,
                color: blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: greyColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            ),
          ),
        ],
      ),
    );
  }
}