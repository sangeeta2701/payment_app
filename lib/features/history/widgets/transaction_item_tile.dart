import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/history/models/transaction_model.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItemTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Avatar or Icon handling
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.grey.shade300,
            child: CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFFF5F4F9),
              backgroundImage: transaction.avatarUrl != null
                  ? NetworkImage(transaction.avatarUrl!)
                  : null,
              child: transaction.avatarUrl == null
                  ? Icon(
                      transaction.fallbackIcon,
                      color: Colors.black87,
                      size: 20.sp,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 16.w),

          // Title, Subtitle, and Debited/Credited from Bank metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.title,
                      style: AppTextStyles.blackContentTextStyle.copyWith(
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${isCredit ? '+ ' : ''}₹${transaction.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isCredit ? const Color(0xFF2E7D32) : blackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.subtitle,
                      style: AppTextStyles.greyContentTextStyle.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          isCredit ? "Credited to " : "Debited from ",
                          style: AppTextStyles.greyContentTextStyle.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        // Small Bank Logo placeholder
                        Image.asset(
                          transaction.bankLogoAsset,
                          width: 14.w,
                          height: 14.w,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 7.r,
                            backgroundColor: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
