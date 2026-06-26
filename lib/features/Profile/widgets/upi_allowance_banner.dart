import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class UpiAllowanceBanner extends StatelessWidget {
  const UpiAllowanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6), // Light yellowish cream banner tone
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFE5B4).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.priority_high, size: 12, color: Colors.white),
          ),
          width8,
          Expanded(
            child: Text(
              "Receive money on Paytm from\nall UPI apps",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF4A4A4A), height: 1.3),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F1F1F),
              foregroundColor: whiteColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Allow", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}