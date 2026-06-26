import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
import '../widgets/payment_app_bar.dart';
import '../widgets/transaction_bubble.dart';
import '../widgets/payment_bottom_bar.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final PayContact contact;

  const PaymentDetailsScreen({super.key, required this.contact});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  // Mocking database history state checking
  List<Map<String, dynamic>> mockHistory = [];

  @override
  void initState() {
    super.initState();
    _loadTransactionHistory();
  }

  void _loadTransactionHistory() {
    // If it's a saved contact, we match it against our mock database entries (Image 1 scenario)
    if (widget.contact.isSavedContact && widget.contact.displayName.contains("Boo")) {
      mockHistory = [
        {"amount": 500.0, "date": "24 May, 4:32 PM", "isSent": false},
        {"amount": 1200.0, "date": "25 May, 1:15 PM", "isSent": true},
        {"amount": 100.0, "date": "Yesterday, 8:44 PM", "isSent": true},
      ];
    } else {
      // If it's a brand new number, history stays empty (Image 2 scenario)
      mockHistory = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PaymentAppBar(contact: widget.contact),
      body: Column(
        children: [
          Expanded(
            child: mockHistory.isEmpty 
                ? _buildNewPaymentWelcomeState() 
                : _buildChatHistoryList(),
          ),
          const PaymentBottomBar(),
        ],
      ),
    );
  }

  // View Layout for Image 1 (Existing History Logs)
  Widget _buildChatHistoryList() {
    return ListView.builder(
      reverse: true, // Optional: items load upwards from input line like a real payment app
      padding: EdgeInsets.symmetric(vertical: 12.h),
      itemCount: mockHistory.length,
      itemBuilder: (context, index) {
        final tx = mockHistory[index];
        return TransactionBubble(
          amount: tx["amount"],
          dateString: tx["date"],
          isSent: tx["isSent"],
        );
      },
    );
  }

  // View Layout for Image 2 (Completely New Payment Welcome State)
  Widget _buildNewPaymentWelcomeState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F4F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security_outlined,
                size: 40.sp,
                color: const Color(0xFF1E1A3A),
              ),
            ),
            height16,
            Text(
              "Say hello to ${widget.contact.displayName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            height8,
            Text(
              "Initiate a secure transfer directly to their verified bank routing address.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}