import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;
  final String receiverName;
  final double amount;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
    required this.receiverName,
    required this.amount,
  });

  // Native Device Platform File Downloading Mock Strategy
  Future<void> _downloadReceiptReceiptFile(BuildContext context) async {
    try {
      final Directory? downloadsDir = await getExternalStorageDirectory();
      if (downloadsDir == null) throw Exception("Storage subsystem inaccessible.");

      final String receiptPath = "${downloadsDir.path}/Receipt_$transactionId.txt";
      final File targetFile = File(receiptPath);

      final String receiptContent = """
      ====================================
               PAYMENT AP RECEIPT
      ====================================
      Transaction ID : $transactionId
      Paid To        : $receiverName
      Amount Sent    : INR ${amount.toStringAsFixed(2)}
      Date & Time    : ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}
      Status         : SUCCESSFUL SECURE TX
      ====================================
      """;

      await targetFile.writeAsString(receiptContent);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Receipt saved safely to local device: $receiptPath", style: AppTextStyles.whiteContentTextStyle(context).copyWith(fontSize: 12.sp)),
          backgroundColor: const Color(0xFF00B15E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download sequence suspended due to disk permission profiles.")),
      );
    }
  }

  // Opens Native OS Share Bottom Selection Sheets
  void _shareReceiptViaNativeSheet() {
    final String textToShare = "Successfully transferred ₹${amount.toStringAsFixed(0)} securely to $receiverName via PaymentApp. Txn ID: $transactionId";
    Share.share(textToShare, subject: 'Payment Receipt Confirm Notification');
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.now());

    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparent,
        automaticallyImplyLeading: false, // Prevents backing out into the PIN matrix
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blackColor),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      height24,
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: const BoxDecoration(color: Color(0xFF00B15E), shape: BoxShape.circle),
                        child: Icon(Icons.check, size: 40.sp, color: whiteColor),
                      ),
                      height16,
                      Text("Payment Successful", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 22.sp)),
                      height4,
                      Text(formattedDate, style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
                      SizedBox(height: 32.h),

                      // Structured Main Invoice Metadata Card Panel
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "₹${amount.toStringAsFixed(2)}",
                              style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 34.sp, fontWeight: FontWeight.bold),
                            ),
                            Divider(color: Colors.grey.shade100, height: 32.h),
                            _buildDetailsRow("To Recipient", receiverName, context),
                            height12,
                            _buildDetailsRow("Transaction ID", transactionId.substring(0, 12).toUpperCase(), context),
                            height12,
                            _buildDetailsRow("Payment Status", "SUCCESS", context, isStatus: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Operational Call Action Row Controls
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: themeColor),
                        minimumSize: Size(double.infinity, 46.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                      ),
                      onPressed: () => _downloadReceiptReceiptFile(context),
                      icon: const Icon(Icons.file_download_outlined, color: themeColor),
                      label: Text("Download", style: AppTextStyles.headingThemeTextStyle(context).copyWith(fontSize: 14.sp)),
                    ),
                  ),
                  width12,
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        minimumSize: Size(double.infinity, 46.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                        elevation: 0,
                      ),
                      onPressed: _shareReceiptViaNativeSheet,
                      icon: const Icon(Icons.share_outlined, color: whiteColor),
                      label: Text("Share", style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 14.sp)),
                    ),
                  ),
                ],
              ),
              height24,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String title, String value, BuildContext context, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 13.sp)),
        Text(
          value,
          style: isStatus 
              ? AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 13.sp, color: const Color(0xFF00B15E))
              : AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 13.sp),
        ),
      ],
    );
  }
}