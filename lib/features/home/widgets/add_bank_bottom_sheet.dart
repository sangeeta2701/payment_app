import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/screen/select_bank_screen.dart';

void showAddBankBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false, //prevent closing when tapping outside
    enableDrag: false, //prevent closing when dragging down
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    backgroundColor: whiteColor,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle element visual indicator bar
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: greyColor, size: 24.sp),
              ),
            ),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            height24,
            
            // Icon emblem
            CircleAvatar(
              radius: 28.r,
              backgroundColor: const Color(0xFFE6F0FF),
              child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF1A6CE8), size: 30),
            ),
            height16,
            
            // Title & Subtitle text
            Text(
              "Link Your Bank Account",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F1F1F),
              ),
            ),
            height8,
            Text(
              "Link your bank account now to send and receive money securely using UPI.",
              textAlign: TextAlign.center,
              
              style: AppTextStyles.greyContentTextStyle.copyWith(
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            height24,
            
            // Primary action button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  // 1. Pop the bottom sheet off the current window stack first
                  Navigator.pop(context);
                  
                  // 2. Navigate cleanly straight into your setup screen target
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectBankScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F0C21), // Matches your primary deep dark theme color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Add Bank Account",
                  style: AppTextStyles.whiteContentTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            height8,
          ],
        ),
      );
    },
  );
}