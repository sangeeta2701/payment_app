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
    // ➔ Sent: Blue-tinted right card. Received: White-filled left card.
    final bubbleColor = isSent ? const Color(0xFFE3F2FD) : whiteColor;
    final alignment = isSent ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        width: 240.w,
        margin: EdgeInsets.symmetric(vertical: 6.h),
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
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Positioned(
                bottom: -10.h,
                right: -10.w,
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(Icons.verified_outlined, size: 90.sp, color: lightBlueColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "₹${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 1)}",
                          style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                        width8,
                        Icon(Icons.check_circle, color: const Color(0xFF00B15E), size: 16.sp),
                      ],
                    ),
                    height4,
                    // ➔ DYNAMIC CONDITION LABELS:
                    Text(
                      isSent ? "Sent to Bank A/c" : "Received",
                      style: AppTextStyles.blackContentTextStyle.copyWith(
                        fontSize: 13.sp, 
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        dateString,
                        style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 10.sp, color: Colors.black45),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 3.h, color: lightBlueColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}