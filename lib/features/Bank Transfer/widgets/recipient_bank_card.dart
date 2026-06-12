import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class RecipientBankCard extends StatelessWidget {
  final String bankName;
  final String holderName;
  final String maskedAccountNumber;
  final VoidCallback onTap;

  const RecipientBankCard({
    super.key,
    required this.bankName,
    required this.holderName,
    required this.maskedAccountNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8E7ED)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF0EFF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance, color: Color(0xFF0F0C21)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holderName,
                    style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "$bankName • A/C No: $maskedAccountNumber",
                    style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}