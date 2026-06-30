import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/screen/select_bank_screen.dart';
import 'package:payment_app/features/Pin/screens/enter_pin_screen.dart';
import '../providers/bank_notifier.dart';
import 'bank_account_tile.dart';

class BankSelectorBottomSheet extends ConsumerStatefulWidget {
  final double amountToPay;
  final String userName;
  const BankSelectorBottomSheet({super.key, required this.amountToPay, required this.userName });

  @override
  ConsumerState<BankSelectorBottomSheet> createState() => _BankSelectorBottomSheetState();
}

class _BankSelectorBottomSheetState extends ConsumerState<BankSelectorBottomSheet> {
  bool _isAccountSelected = true;

  @override
  Widget build(BuildContext context) {
    final bankStream = ref.watch(activeUserBankProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Choose account to pay", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 16.sp)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          height8,
          Text(
            "Amount: ₹${widget.amountToPay.toStringAsFixed(2)}",
            style: AppTextStyles.blackContentTextStyle.copyWith(fontWeight: FontWeight.bold, color: themeColor),
          ),
          Divider(color: Colors.grey.shade200, height: 32.h),

          bankStream.when(
            loading: () => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(lightBlueColor))),
            error: (err, stack) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text("Verification error: $err", style: const TextStyle(color: Colors.redAccent)),
            ),
            data: (bankData) {
              if (bankData == null) {
                return _buildEmptyState(context);
              }
              return Column(
                children: [
                  BankAccountTile(
                    bankName: bankData['bankName'],
                    maskedAccount: bankData['maskedAccount'],
                    isSelected: _isAccountSelected,
                    onToggle: (value) => setState(() => _isAccountSelected = value),
                  ),
                  SizedBox(height: 24.h),
                  _buildProceedButton(context, widget.amountToPay),
                ],
              );
            },
          ),
          height12,
        ],
      ),
    );
  }

  // Extracted Component: Empty Account Link State UI
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Text(
          "No bank account linked to your profile yet. Please connect an account to continue with payments.",
          style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 13.sp),
        ),
        SizedBox(height: 20.h),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightBlueColor,
            minimumSize: Size(double.infinity, 46.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectBankScreen()));
          },
          icon: const Icon(Icons.add_card_rounded, color: Colors.white),
          label: const Text("Add Bank Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // Extracted Component: Dynamic Confirmation Button UI
  Widget _buildProceedButton(BuildContext context, double amount) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F0C21),
        minimumSize: Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        disabledBackgroundColor: Colors.grey.shade300,
        elevation: 0,
      ),
      onPressed: !_isAccountSelected
          ? null
          : () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EnterPinScreen(userName: widget.userName,amountToPay: widget.amountToPay,)));
            },
      child: Text(
        "Proceed Securely • ₹${amount.toStringAsFixed(0)}",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}