import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class QuickRechargesSection extends StatelessWidget {
  const QuickRechargesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Network Logo Placeholder Circle (e.g., Jio)
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: themeColor,
                  child: const Text("Jio", style: TextStyle(color: whiteColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sangeeta Gupta",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackColor),
                    ),
                    Text(
                      "1 GB for ₹19",
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: blackColor),
                    ),
                  ],
                ),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right, size: 16.sp, color: Colors.grey.shade600),
              ],
            ),
          ),
          // Add more quick recharge containers inside this row dynamically if needed
        ],
      ),
    );
  }
}