import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/transaction_model.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItemTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Initials Profile Badge
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFFEDE7F6),
            child: Text(
              transaction.title.substring(0, 2).toUpperCase(),
              style: TextStyle(color: const Color(0xFF673AB7), fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 12.w),

          // Core Data details section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${transaction.title} ${transaction.emojiSuffix ?? ''}",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                SizedBox(height: 3.h),
                Text(
                  "${transaction.dateString}, ${transaction.timestamp}",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 6.h),
                
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
                        style: TextStyle(fontSize: 11.sp, color: transaction.categoryTextColor, fontWeight: FontWeight.bold),
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
                  color: transaction.type == TransactionType.credit ? const Color(0xFF00875A) : Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text("To ", style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                  // Inline App target brand badge indicator
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFF5F259F), shape: BoxShape.circle),
                    child: const Text("पे", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
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