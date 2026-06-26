import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';

class MonthGroupHeader extends StatelessWidget {
  final String monthTitle;
  final String summaryText;
  final bool isCredit;

  const MonthGroupHeader({
    super.key,
    required this.monthTitle,
    required this.summaryText,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F5F9), 
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monthTitle,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Row(
            children: [
              Text(
                summaryText.split('\n')[0],
                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
              width4,
              Text(
                summaryText.split('\n').length > 1 ? summaryText.split('\n')[1] : "",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? const Color(0xFF00875A) : const Color(0xFF0066C4),
                ),
              ),
              if (isCredit) ...[
                width4,
                const Icon(Icons.chevron_right, size: 16, color: Colors.blue),
              ]
            ],
          )
        ],
      ),
    );
  }
}