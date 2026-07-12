import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class BeneficiaryTile extends StatelessWidget {
  final String name;
  final String emojis;
  final String dateStr;
  final String phoneNumber;
  final String statusMessage;
  final Color avatarColor;
  final VoidCallback onTap;

  const BeneficiaryTile({
    super.key,
    required this.name,
    required this.emojis,
    required this.dateStr,
    required this.phoneNumber,
    required this.statusMessage,
    required this.avatarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            // Circular Initials Avatar
            Container(
              height: 46.h,
              width: 46.w,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                name.substring(0, min(2, name.length)).toUpperCase(),
                style: TextStyle(
                  color: const Color(0xFF6C5DD3),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            
            // Context Details Text Group
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$name $emojis",
                        style: AppTextStyles.blackContentTextStyle(context).copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        dateStr,
                        style: AppTextStyles.greyContentTextStyle(context).copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    phoneNumber,
                    style: AppTextStyles.greyContentTextStyle(context).copyWith(
                      fontSize: 12.sp, 
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F9EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_rupee, size: 10, color: Color(0xFF00B15E)),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        statusMessage,
                        style: AppTextStyles.greyContentTextStyle(context).copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.star_border, color: Colors.grey.shade400, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

// Simple Helper for Substring Guard check
int min(int a, int b) => a < b ? a : b;