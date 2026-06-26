import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';

class TransactionBubble extends StatelessWidget {
  final double amount;
  final String dateString;
  final bool isSent; // true for paid, false if received

  const TransactionBubble({
    super.key,
    required this.amount,
    required this.dateString,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFF1E1A3A) : const Color(0xFFF5F4F9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isSent ? Radius.circular(16.r) : Radius.circular(0.r),
            bottomRight: isSent ? Radius.circular(0.r) : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "₹${amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: isSent ? Colors.white : Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            height4,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSent) ...[
                  Icon(Icons.check_circle, color: Colors.purpleAccent, size: 12.sp),
                  SizedBox(width: 4.w),
                ],
                Text(
                  isSent ? "Sent • $dateString" : "Received • $dateString",
                  style: TextStyle(
                    color: isSent ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}