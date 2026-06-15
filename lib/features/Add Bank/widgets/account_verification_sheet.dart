import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';

class AccountVerificationSheet extends StatefulWidget {
  final BankModel selectedBank;
  const AccountVerificationSheet({super.key, required this.selectedBank});

  @override
  State<AccountVerificationSheet> createState() => AccountVerificationSheetState();
}

class AccountVerificationSheetState extends State<AccountVerificationSheet> {
  bool _isLoading = true;
  bool _isLinkedSuccess = false;

  @override
  void initState() {
    super.initState();
    _performSimulatedBankLookup();
  }

  void _performSimulatedBankLookup() async {
    // Simulating backend server lookup check framework delay
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      // Flip this variable to false if testing failure verification states
      _isLinkedSuccess = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading) ...[
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(lightBlueColor),),
            SizedBox(height: 20.h),
            Text(
              "Finding bank accounts linked with your registered mobile number...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ] else if (_isLinkedSuccess) ...[
            Icon(Icons.check_circle, color: const Color(0xFF00B15E), size: 54.sp),
            SizedBox(height: 14.h),
            Text("Bank Account Found!", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 16.sp,)),
            SizedBox(height: 6.h),
            Text(
              "Your account with ${widget.selectedBank.name} has been successfully discovered and your UPI profile is active.",
              textAlign: TextAlign.center,
              style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F0C21),
                minimumSize: Size(double.infinity, 44.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
              ),
              onPressed: () {
                Navigator.pop(context); // close bottom sheet
                Navigator.pop(context); // return to dashboard view screen
              },
              child: const Text("Done", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
            )
          ] else ...[
            Icon(Icons.error_outline, color: Colors.red, size: 54.sp),
            SizedBox(height: 14.h),
            Text("No Account Found", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 13.sp,)),
            SizedBox(height: 6.h),
            Text(
              "We couldn't find any account in ${widget.selectedBank.name} linked to your current mobile number.",
              textAlign: TextAlign.center,
              style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: Size(double.infinity, 44.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Try Again", style: TextStyle(color: blackColor)),
            )
          ],
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}