import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final historyAsyncValue = ref.watch(chatHistoryStreamProvider(contact.phoneNumber));
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PaymentAppBar(contact: contact),
      body: Column(
        children: [
          Expanded(
            child: historyAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor))),
              error: (err, stack) => Center(child: Text("Error loading records: $err")),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "No transaction history yet.",
                      style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 14.sp),
                    ),
                  );
                }

                // 1. GROUP TRANSACTIONS BY DATE STRING PROGRAMMATICALLY
                final Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
                for (var tx in transactions) {
                  final Timestamp? serverTime = tx['timestamp'] as Timestamp?;
                  if (serverTime != null) {
                    final String dateKey = DateFormat('dd MMM yyyy').format(serverTime.toDate());
                    groupedTransactions.putIfAbsent(dateKey, () => []).add(tx);
                  }
                }

                final List<String> dateHeaders = groupedTransactions.keys.toList();

                // 2. RENDER THE GROUPED DYNAMIC DATE LAYOUT
                return ListView.builder(
                  reverse: true, // Loads chat timeline from the bottom up
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: dateHeaders.length,
                  itemBuilder: (context, index) {
                    final String dateString = dateHeaders[index];
                    final List<Map<String, dynamic>> dayTransactions = groupedTransactions[dateString]!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dynamic Reference Sticky Date Header Pill
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16.h),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            dateString,
                            style: AppTextStyles.greyContentTextStyle.copyWith(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        
                        // Render day-specific payment metrics bubbles
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dayTransactions.length,
                          itemBuilder: (context, txIndex) {
                            final tx = dayTransactions[txIndex];
                            final double amt = (tx['amount'] as num).toDouble();
                            
                            // Dynamically evaluate type based on current profile login signatures
                            final bool isSentAction = tx['senderId'] == myUid;

                            final Timestamp? serverTime = tx['timestamp'] as Timestamp?;
                            final String formattedTime = serverTime != null
                                ? DateFormat('h:mm a').format(serverTime.toDate())
                                : DateFormat('h:mm a').format(DateTime.now());

                            return TransactionBubble(
                              amount: amt,
                              dateString: formattedTime,
                              isSent: isSentAction, // Passes true for debit cards, false for incoming credits
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: whiteColor,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
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
              icon: Icon(Icons.verified_user_outlined, color: whiteColor, size: 18.sp),
              label: Text(
                "Pay Securely",
                style: AppTextStyles.whiteButtonTextStyle.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
          height30,
        ],
      ),
    );
  }
}