import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class TransactionBubble extends StatelessWidget {
  final double amount;
  final String dateString;
  final bool isSent;

  const TransactionBubble({
    super.key,
    required this.amount,
    required this.dateString,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    // Exact visual representation matching incoming image parameters
    final bubbleColor = isSent ? const Color(0xFFE3F2FD) : whiteColor;
    final alignment = isSent ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        width: 240.w,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: isSent ? Radius.circular(20.r) : Radius.circular(4.r),
            bottomRight: isSent ? Radius.circular(4.r) : Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Subtle background watermark stamp decoration match
              Positioned(
                bottom: -10.h,
                right: -10.w,
                child: Opacity(
                  opacity: 0.06,
                  child: Icon(Icons.verified_outlined, size: 100.sp, color:lightBlueColor),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "₹${amount.toStringAsFixed(0)}",
                          style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 18.sp),
                        ),
                        width4,
                        Icon(Icons.check_circle, color: const Color(0xFF00B15E), size: 18.sp),
                      ],
                    ),
                    height4,
                    Text(
                      isSent ? "Sent to Bank A/c" : "Received",
                      style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    height12,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        dateString,
                        style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 10.sp),
                      ),
                    )
                  ],
                ),
              ),
              
              // Reference Match: Bold structural base indicator underlines
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 4.h, color: const Color(0xFF00B9F5)),
              )
            ],
          ),
        ),
      ),
    );
  }
}