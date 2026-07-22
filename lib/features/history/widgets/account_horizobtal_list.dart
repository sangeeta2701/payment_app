

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/Pin/screens/enter_pin_screen.dart';

import '../providers/account_balance_provider.dart';

class AccountsHorizontalList extends ConsumerWidget {
  const AccountsHorizontalList({super.key});

  Future<void> _handleCheckBalance(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    String bankName,
    String accNo,
  ) async {
    // 1. Open PIN screen with checkBalance purpose
    final pinEntered = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EnterPinScreen(
          purpose: PinPurpose.checkBalance,
          bankName: bankName,
          accountNumber: accNo,
        ),
      ),
    );

    // 2. If PIN was entered successfully, run loading & set balance
    if (pinEntered != null && pinEntered.isNotEmpty) {
      ref.read(accountBalanceProvider.notifier).startLoading(accountId);

      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Set mock fetched balance
      final double fetchedBalance = accountId == 'sbi' ? 889.82 : 3291.50;
      ref.read(accountBalanceProvider.notifier).setBalance(accountId, fetchedBalance);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsMap = ref.watch(accountBalanceProvider);
    final sbiAccount = accountsMap['sbi']!;
    final hdfcAccount = accountsMap['hdfc']!;

    return SizedBox(
      height: 100.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildBankCard(
            context: context,
            ref: ref,
            accountData: sbiAccount,
            iconWidget: const Icon(Icons.account_balance, color: themeColor, size: 18),
          ),
          SizedBox(width: 12.w),
          _buildBankCard(
            context: context,
            ref: ref,
            accountData: hdfcAccount,
            iconWidget: const Icon(Icons.domain, color: Colors.redAccent, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard({
    required BuildContext context,
    required WidgetRef ref,
    required AccountBalanceData accountData,
    required Widget iconWidget,
  }) {
    return Container(
      width: 170.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountData.bankName,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackColor),
                  ),
                  Text(
                    "A/c No: ${accountData.accountNumber}",
                    style: TextStyle(fontSize: 12.sp, color: greyColor[600]),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 14.r,
                backgroundColor: greyColor[100],
                child: iconWidget,
              ),
            ],
          ),

          if (accountData.state == BalanceState.initial)
            SizedBox(
              width: double.infinity,
              height: 34.h,
              child: ElevatedButton(
                onPressed: () => _handleCheckBalance(
                  context,
                  ref,
                  accountData.accountId,
                  accountData.bankName,
                  accountData.accountNumber,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFF4FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text(
                  "Check Balance",
                  style: TextStyle(fontSize: 12.sp, color: blackColor, fontWeight: FontWeight.w600),
                ),
              ),
            )
          else if (accountData.state == BalanceState.loading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Powered by UPI",
                    style: TextStyle(fontSize: 8.sp, color: greyColor[500]),
                  ),
                ),
              ],
            )
          else
            Text(
              "₹${accountData.balance?.toStringAsFixed(2) ?? '0.00'}",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackColor),
            ),
        ],
      ),
    );
  }
}