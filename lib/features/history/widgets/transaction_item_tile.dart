import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import '../models/transaction_model.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItemTile({super.key, required this.transaction});

  /// Safe helper method to prevent RangeError when title length is less than 2
  String _getInitials(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return "TX";
    if (trimmed.length < 2) return trimmed.toUpperCase();
    return trimmed.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: greyColor.shade100, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Initials Profile Badge (Safely handled)
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFFEDE7F6),
            child: Text(
              _getInitials(transaction.title),
              style: TextStyle(
                color: const Color(0xFF673AB7),
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          width12,

          // Core Data details section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${transaction.title} ${transaction.emojiSuffix ?? ''}",
                  style: AppTextStyles.blackContentTextStyle(context).copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height4,
                Text(
                  "${transaction.dateString}, ${transaction.timestamp}",
                  style: AppTextStyles.greyContentTextStyle(context).copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                height8,
                
                // Functional Categorization Badge Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: transaction.categoryBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (transaction.categoryIcon != null) ...[
                        Icon(transaction.categoryIcon, size: 12, color: transaction.categoryTextColor),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        transaction.categoryTag,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: transaction.categoryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Numeric Pricing and routing layout column section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${transaction.type == TransactionType.credit ? '+ ' : '- '}₹${transaction.amount.toInt()}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == TransactionType.credit ? successColor : blackColor,
                ),
              ),
              height8,
              Row(
                children: [
                  Text("To ", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 11.sp) ),
                  // Inline App target brand badge indicator
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFF5F259F), shape: BoxShape.circle),
                    child:  Text(
                      "पे",
                      style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 8.sp, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}