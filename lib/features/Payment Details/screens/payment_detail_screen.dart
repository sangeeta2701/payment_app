import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
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
    final historyAsyncValue = ref.watch(
      chatHistoryStreamProvider(contact.phoneNumber),
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PaymentAppBar(contact: contact),
      body: Column(
        children: [
          Expanded(
            child: historyAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Error loading records: $err")),
              data: (transactions) {
                // If the stream returns an empty list array from Firestore
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "No transaction history yet.",
                      style: AppTextStyles.greyContentTextStyle.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                // Return the ListView if history data points are present
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  itemCount: transactions.length,
                  // itemBuilder: (context, index) {
                  //   final tx = transactions[index];
                  //   final double amt = (tx['amount'] as num).toDouble();
                  //   final bool isSentAction = tx['type'] == 'sent';

                  //   return TransactionBubble(
                  //     amount: amt,
                  //     dateString: "10:05 PM",
                  //     isSent: isSentAction,
                  //   );
                  // },

                  // Inside payment_detail_screen.dart under your ListView.builder:
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final double amt = (tx['amount'] as num).toDouble();
                    final bool isSentAction = tx['type'] == 'sent';

                    // ➔ SAFELY RESOLVE THE SERVER TIMESTAMP
                    final Timestamp? serverTime = tx['timestamp'] as Timestamp?;
                    final String formattedTime = serverTime != null
                        ? DateFormat('hh:mm a').format(serverTime.toDate())
                        : DateFormat('hh:mm a').format(
                            DateTime.now(),
                          ); // Fallback during hot-reload execution

                    return TransactionBubble(
                      amount: amt,
                      dateString: formattedTime, // ➔ PASS THE DYNAMIC TIME
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
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor, // Rich navy brand coloring accent
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),

              
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAmountScreen(
                      isFromQR: false,
                      userName: contact.displayName,
                      upiId: '${contact.phoneNumber}@payapp',
                    ),
                  ),
                );

               
              },
              icon: Icon(
                Icons.verified_user_outlined,
                color: whiteColor,
                size: 18.sp,
              ),
              label: Text(
                "Pay Securely",
                style: AppTextStyles.whiteButtonTextStyle.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          height30,
        ],
      ),
    );
  }
}
