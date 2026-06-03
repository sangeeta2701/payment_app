import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class MonthGroupHeader extends StatelessWidget {
  final String title;
  const MonthGroupHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FA), // Subtle grey box match
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Text(
        title,
        style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
        // style: TextStyle(
        //   color: Colors.grey.shade600,
        //   fontSize: 14.sp,
        //   fontWeight: FontWeight.w500,
        // ),
      ),
    );
  }
}