import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class PaySearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const PaySearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F9),
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade600, size: 20.sp),
          width8,
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter a mobile number or name",
                hintStyle: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 13.sp),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}