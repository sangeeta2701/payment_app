import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class LinkedBankSelector extends StatelessWidget {
  final String bankName;
  final String accountSuffix;

  const LinkedBankSelector({
    super.key,
    required this.bankName,
    required this.accountSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Native Bank Blue Badge logo emblem
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: const BoxDecoration(color: themeColor, shape: BoxShape.circle),
            child: const Icon(Icons.account_balance, color: whiteColor, size: 14),
          ),
          width12,
          
          Expanded(
            child: Text(
              "$bankName - $accountSuffix",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2C3E50)),
            ),
          ),
          
          GestureDetector(
            onTap: () {}, // Action triggering standard bottom-sheet selection switcher
            child: Text(
              "Change Bank",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: themeColor),
            ),
          )
        ],
      ),
    );
  }
}