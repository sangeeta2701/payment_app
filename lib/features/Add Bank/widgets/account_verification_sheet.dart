// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:payment_app/core/theme/app_colors.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';
// import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';

// class AccountVerificationSheet extends StatefulWidget {
//   final BankModel selectedBank;
//   const AccountVerificationSheet({super.key, required this.selectedBank});

//   @override
//   State<AccountVerificationSheet> createState() => AccountVerificationSheetState();
// }

// class AccountVerificationSheetState extends State<AccountVerificationSheet> {
//   bool _isLoading = true;
//   bool _isLinkedSuccess = false;

//   @override
//   void initState() {
//     super.initState();
//     _performSimulatedBankLookup();
//   }

//   void _performSimulatedBankLookup() async {
//     // Simulating backend server lookup check framework delay
//     await Future.delayed(const Duration(milliseconds: 2500));
    
//     if (!mounted) return;
//     setState(() {
//       _isLoading = false;
//       // Flip this variable to false if testing failure verification states
//       _isLinkedSuccess = true; 
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(24.w),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (_isLoading) ...[
//             const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(lightBlueColor),),
//             SizedBox(height: 20.h),
//             Text(
//               "Finding bank accounts linked with your registered mobile number...",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//             ),
//           ] else if (_isLinkedSuccess) ...[
//             Icon(Icons.check_circle, color: const Color(0xFF00B15E), size: 54.sp),
//             SizedBox(height: 14.h),
//             Text("Bank Account Found!", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 16.sp,)),
//             SizedBox(height: 6.h),
//             Text(
//               "Your account with ${widget.selectedBank.name} has been successfully discovered and your UPI profile is active.",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
//             ),
//             SizedBox(height: 20.h),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0F0C21),
//                 minimumSize: Size(double.infinity, 44.h),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
//               ),
//               onPressed: () {
//                 Navigator.pop(context); // close bottom sheet
//                 Navigator.pop(context); // return to dashboard view screen
//               },
//               child: const Text("Done", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
//             )
//           ] else ...[
//             Icon(Icons.error_outline, color: Colors.red, size: 54.sp),
//             SizedBox(height: 14.h),
//             Text("No Account Found", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 13.sp,)),
//             SizedBox(height: 6.h),
//             Text(
//               "We couldn't find any account in ${widget.selectedBank.name} linked to your current mobile number.",
//               textAlign: TextAlign.center,
//               style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
//             ),
//             SizedBox(height: 20.h),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey.shade300,
//                 minimumSize: Size(double.infinity, 44.h),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
//               ),
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Try Again", style: TextStyle(color: blackColor)),
//             )
//           ],
//           SizedBox(height: 10.h),
//         ],
//       ),
//     );
//   }
// } 



//updated 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
      child: bankState.when(
        // Context 1: Async Loading Handshake Processing
        loading: () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(lightBlueColor)),
            SizedBox(height: 24.h),
            Text(
              "Finding bank accounts linked with your registered mobile number...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            SizedBox(height: 30.h),
          ],
        ),

        // Context 2: Async Data Arrival Complete Block
        data: (discoveredAccounts) {
          if (discoveredAccounts.isEmpty) {
            // Case 2A: Empty result list (No match discovered)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 54.sp),
                SizedBox(height: 14.h),
                Text("No Account Found", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 15.sp)),
                SizedBox(height: 8.h),
                Text(
                  "No account found for the registered number in ${selectedBank.name}. Please check your linked mobile profile registration.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp, height: 1.3),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    minimumSize: Size(double.infinity, 44.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Try Another Bank", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10.h),
              ],
            );
          }

          // Case 2B: Array populated (Discovered match records)
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: const Color(0xFF007AFF), size: 54.sp),
              SizedBox(height: 14.h),
              Text("Select Bank Account Found", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 16.sp)),
              SizedBox(height: 6.h),
              Text(
                "We found the following account matching your number with ${selectedBank.name}:",
                textAlign: TextAlign.center,
                style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: discoveredAccounts.length,
                itemBuilder: (context, index) {
                  final account = discoveredAccounts[index];
                  return Card(
                    elevation: 0,
                    color: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF002E72),
                        child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                      ),
                      title: Text(account['bankName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      subtitle: Text(account['maskedAccountNo'], style: TextStyle(fontSize: 12.sp, letterSpacing: 1.5)),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.black45),
                      onTap: () async {
                        bool success = await ref.read(bankProvider.notifier).activateBankAccount(account);
                        if (success && context.mounted) {
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.pop(context); // Return to dashboard home profile root
                        }
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
            ],
          );
        },

        // Context 3: Runtime Catch Exception Engine Block
        error: (error, stackTrace) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 54.sp),
            SizedBox(height: 14.h),
            Text("Something Went Wrong", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 15.sp)),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F0C21),
                minimumSize: Size(double.infinity, 44.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Dismiss", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}