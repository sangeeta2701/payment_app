import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class MyNumberSection extends StatelessWidget {
  const MyNumberSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: themeColor, // Brand Identity Primary Color Blue
            child: Text(
              "Jio",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
          ),
          width12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sangeeta Gupta",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackColor),
                ),
                
                height4,
                Text(
                  "6266520680",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
                height4,
                Text(
                  "Added on 19 Mar 2025",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: blackColor),
            onPressed: () {}, // Action settings option
          ),
        ],
      ),
    );
  }
}