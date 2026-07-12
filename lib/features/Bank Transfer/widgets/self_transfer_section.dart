import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/screen/select_bank_screen.dart';

class SelfTransferSection extends StatelessWidget {
  const SelfTransferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F5FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_alt_1_outlined, color: lightBlueColor),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Self Transfer",
                      style: AppTextStyles.blackContentTextStyle(context).copyWith(
                        fontSize: 15.sp, 
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Select A/c where you want to send money",
                      style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Connected Bank Entry Layout
            Row(
              children: [
                SizedBox(width: 8.w),
                // Replace with your local/network assets for the precise bank badge icon if needed
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF005A9C), // Blue color backing for SBI emblem
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 14),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "State Bank Of India-0106",
                        style: AppTextStyles.blackContentTextStyle(context).copyWith(
                          fontSize: 14.sp, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      
                      GestureDetector(
                        onTap: () {}, // Trigger Balance enquiry sheet
                        child: Text(
                          "Check balance",
                          style: TextStyle(color: lightBlueColor, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.black87, size: 20),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Add Another Option Trigger Row
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBankScreen(),));
              },
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  const Icon(Icons.add, color: Color(0xFF1A6CE8), size: 20),
                  SizedBox(width: 12.w),
                  Text(
                    "Add another Bank A/c",
                    style: AppTextStyles.blackContentTextStyle(context).copyWith(
                      color: lightBlueColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}