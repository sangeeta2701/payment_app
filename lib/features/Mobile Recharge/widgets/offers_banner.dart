import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class OffersBanner extends StatelessWidget {
  final int offerCount;
  const OffersBanner({super.key, required this.offerCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F0), // Soft green banner
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: const Color(0xFF00875A), size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "$offerCount offers available for you",
              style: TextStyle(
                color: const Color(0xFF00875A),
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  "View All",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                Icon(Icons.chevron_right, color: themeColor, size: 16.sp),
              ],
            ),
          )
        ],
      ),
    );
  }
}