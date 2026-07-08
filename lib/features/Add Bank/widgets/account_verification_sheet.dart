//updated
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';
import 'package:payment_app/features/Add%20Bank/providers/bank_notifier.dart';

class AccountVerificationSheet extends ConsumerWidget {
  final BankModel selectedBank;
  const AccountVerificationSheet({super.key, required this.selectedBank});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the active AsyncValue live data state
    final bankState = ref.watch(bankProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.w,
        24.h,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: bankState.when(
        // Context 1: Async Loading Handshake Processing
        loading: () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            height20,
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(lightBlueColor),
            ),
            height24,
            Text(
              "Finding bank accounts linked with your registered mobile number...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            height30,
          ],
        ),

        // Context 2: Async Data Arrival Complete Block
        data: (discoveredAccounts) {
          if (discoveredAccounts.isEmpty) {
            // Case 2A: Empty result list (No match discovered)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 54.sp,
                ),
                SizedBox(height: 14.h),
                Text(
                  "No Account Found",
                  style: AppTextStyles.headingBlackTextStyle.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
                height8,
                Text(
                  "No account found for the registered number in ${selectedBank.name}. Please check your linked mobile profile registration.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.greyContentTextStyle.copyWith(
                    fontSize: 12.sp,
                    height: 1.3,
                  ),
                ),
                height24,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    minimumSize: Size(double.infinity, 44.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Try Another Bank",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                height12,
              ],
            );
          }

          // Case 2B: Array populated (Discovered match records)
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: lightBlueColor,
                size: 54.sp,
              ),
              height12,
              Text(
                "Select Bank Account Found",
                style: AppTextStyles.headingBlackTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              height8,
              Text(
                "We found the following account matching your number with ${selectedBank.name}:",
                textAlign: TextAlign.center,
                style: AppTextStyles.greyContentTextStyle.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              height16,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: discoveredAccounts.length,

               
               itemBuilder: (context, index) {
  final account = discoveredAccounts[index];
  
  // ➔ SCHEMATIC FIX: Pull the exact field 'maskedAccountNo' as stored in your Firestore console
  final String dbMaskedNo = account['maskedAccountNo'] ?? "XXXX XXXX 0000";
  
  // Clean up formatting to show identical custom layout dots
  final String displayMaskedNo = dbMaskedNo.replaceAll("XXXX XXXX", "•••• •••• ••");

  return Card(
    elevation: 0,
    color: const Color(0xFFF1F5F9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: themeColor,
        child: const Icon(Icons.account_balance, color: whiteColor, size: 18),
      ),
      title: Text(
        account['bankName'] ?? selectedBank.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
      subtitle: Text(
        displayMaskedNo, // ➔ Renders the mapped '•••• •••• ••0106' layout
        style: TextStyle(fontSize: 12.sp, letterSpacing: 1.5, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.black45),
      // onTap: () async {
      //   // Show an indicator while executing write commands
      //   showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) => const Center(child: CircularProgressIndicator()),
      //   );

      //   final Map<String, dynamic> activePayload = {
      //     'bankName': account['bankName'] ?? selectedBank.name,
      //     'maskedAccountNo': displayMaskedNo,
      //     'upiId': account['upiId'] ?? "${account['phoneNumber']}@payapp",
      //   };

      //   bool success = await ref.read(bankProvider.notifier).activateBankAccount(activePayload);
        
      //   if (context.mounted) Navigator.pop(context); // Remove progress loading state

      //   if (success && context.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("${activePayload['bankName']} linked successfully!")),
      //     );
      //     Navigator.pop(context); // Close Verification Sheet
      //     Navigator.pop(context); // Pop back out to Home Dashboard
      //   } else if (context.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Error linking account. Check connection settings.")),
      //     );
      //   }
      // },
    
    onTap: () async {
  // 1. Capture the structural navigator states BEFORE the async await gap
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // 2. Prepare payload tracking changes safely
  final Map<String, dynamic> activePayload = {
    'bankName': account['bankName'] ?? selectedBank.name,
    'maskedAccountNo': displayMaskedNo,
    'upiId': account['upiId'] ?? "${account['phoneNumber']}@payapp",
  };

  debugPrint("****************[TAP LOG] Click registered on bank row. Sending payload to notifier...");

  // 3. Execute the database transaction update 
  bool success = await ref
      .read(bankProvider.notifier)
      .activateBankAccount(activePayload);
  
  debugPrint("****************[TAP LOG] Notifier database task complete. Success code returned: $success");

  // 4. Execute UI state adjustments using the safe, pre-captured navigator instance
  if (success) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text("${activePayload['bankName']} linked successfully!")),
    );
    // Pop the verification sheet overlay window first
    navigator.pop(); 
    // Pop the selection screen layout backdrop second to return cleanly to home
    navigator.pop(); 
  } else {
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text("Error linking account. Database update rejected.")),
    );
  }
},
    
    ),

  );
}
              ),
              height12,
            ],
          );
        },

        // Context 3: Runtime Catch Exception Engine Block
        error: (error, stackTrace) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 54.sp),
            SizedBox(height: 14.h),
            Text(
              "Something Went Wrong",
              style: AppTextStyles.headingBlackTextStyle.copyWith(
                fontSize: 15.sp,
              ),
            ),
            height8,
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.greyContentTextStyle.copyWith(
                fontSize: 12.sp,
              ),
            ),
            height24,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F0C21),
                minimumSize: Size(double.infinity, 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Dismiss",
                style: TextStyle(color: Colors.white),
              ),
            ),
            height12,
          ],
        ),
      ),
    );
  }
}
