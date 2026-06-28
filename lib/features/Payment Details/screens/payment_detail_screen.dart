// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:payment_app/core/constants/sizedbox.dart';
// import 'package:payment_app/core/theme/app_colors.dart';
// import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
// import '../widgets/payment_app_bar.dart';
// import '../widgets/transaction_bubble.dart';
// import '../widgets/payment_bottom_bar.dart';

// class PaymentDetailsScreen extends StatefulWidget {
//   final PayContact contact;

//   const PaymentDetailsScreen({super.key, required this.contact});

//   @override
//   State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
// }

// class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
//   // Mocking database history state checking
//   List<Map<String, dynamic>> mockHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactionHistory();
//   }

//   void _loadTransactionHistory() {
//     // If it's a saved contact, we match it against our mock database entries (Image 1 scenario)
//     if (widget.contact.isSavedContact && widget.contact.displayName.contains("Boo")) {
//       mockHistory = [
//         {"amount": 500.0, "date": "24 May, 4:32 PM", "isSent": false},
//         {"amount": 1200.0, "date": "25 May, 1:15 PM", "isSent": true},
//         {"amount": 100.0, "date": "Yesterday, 8:44 PM", "isSent": true},
//       ];
//     } else {
//       // If it's a brand new number, history stays empty (Image 2 scenario)
//       mockHistory = [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: PaymentAppBar(contact: widget.contact),
//       body: Column(
//         children: [
//           Expanded(
//             child: mockHistory.isEmpty 
//                 ? _buildNewPaymentWelcomeState() 
//                 : _buildChatHistoryList(),
//           ),
//           const PaymentBottomBar(),
//         ],
//       ),
//     );
//   }

//   // View Layout for Image 1 (Existing History Logs)
//   Widget _buildChatHistoryList() {
//     return ListView.builder(
//       reverse: true, // Optional: items load upwards from input line like a real payment app
//       padding: EdgeInsets.symmetric(vertical: 12.h),
//       itemCount: mockHistory.length,
//       itemBuilder: (context, index) {
//         final tx = mockHistory[index];
//         return TransactionBubble(
//           amount: tx["amount"],
//           dateString: tx["date"],
//           isSent: tx["isSent"],
//         );
//       },
//     );
//   }

//   // View Layout for Image 2 (Completely New Payment Welcome State)
//   Widget _buildNewPaymentWelcomeState() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 32.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF5F4F9),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.security_outlined,
//                 size: 40.sp,
//                 color: const Color(0xFF1E1A3A),
//               ),
//             ),
//             height16,
//             Text(
//               "Say hello to ${widget.contact.displayName}",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             height8,
//             Text(
//               "Initiate a secure transfer directly to their verified bank routing address.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey.shade500,
//                 height: 1.4,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Amount/screen/add_amount_screen.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
import 'package:payment_app/features/Payment%20Details/provider/payment_notifier.dart';
import '../widgets/payment_app_bar.dart';
import '../widgets/transaction_bubble.dart';

class PaymentDetailsScreen extends ConsumerWidget {
  final PayContact contact;
  const PaymentDetailsScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(chatHistoryStreamProvider(contact.phoneNumber));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PaymentAppBar(contact: contact),
      body: Column(
        children: [
          Expanded(
            child: historyAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Error loading records: $err")),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(child: Text("No transaction history yet."));
                }
                return ListView.builder(
                  reverse: true, // Forces layout lists to scale upwards like messaging apps
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final double amt = (tx['amount'] as num).toDouble();
                    final bool isSentAction = tx['type'] == 'sent';

                    return TransactionBubble(
                      amount: amt,
                      dateString: "10:05 PM", // Dynamically format timestamp field later
                      isSent: isSentAction,
                    );
                  },
                );
              },
            ),
          ),
          
          // Reference Match: Bottom Static Pay Confirmation Call Trigger
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: whiteColor,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor, // Rich navy brand coloring accent
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AddAmountScreen(isFromQR: false,userName:"Sanggeta",upiId: "sanggeta@upi",)));
                PaymentService.executeSecureTransaction(
                  targetPhone: contact.phoneNumber,
                  paymentAmount: 50.0,
                  transactionType: 'sent',
                );
              },
              icon: Icon(Icons.verified_user_outlined, color: whiteColor, size: 18.sp),
              label: Text(
                "Pay Securely",
                style: AppTextStyles.whiteButtonTextStyle.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}