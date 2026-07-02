import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:intl/intl.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pin/widgest/pin_dots_indicator.dart';
import 'package:payment_app/features/Pin/widgest/pin_keypad.dart';
import 'package:payment_app/features/Transactions/providers/transaction_notifier.dart';
import 'package:payment_app/features/Transactions/screen/transaction_details_screen.dart';


class EnterPinScreen extends ConsumerStatefulWidget {
  final String userName;
  final double amountToPay;
  final String upiId;

  const EnterPinScreen({
    super.key,
    required this.userName,
    required this.amountToPay,
    required this.upiId,
  });

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen> {
  String _currentPin = "";
  final int _maxPinLength = 6;
  bool _isProcessing = false;
  String? _localError;

  void _handleKeyPress(String value) {
    if (_isProcessing) return;
    
    setState(() {
      _localError = null; 
      if (value == "back") {
        if (_currentPin.isNotEmpty) {
          _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        }
      } else {
        if (_currentPin.length < _maxPinLength) {
          _currentPin += value;
          
          // Trigger execution pipeline immediately upon entry completion
          if (_currentPin.length == _maxPinLength) {
            _submitPaymentPipeline();
          }
        }
      }
    });
  }

  void _submitPaymentPipeline() async {
    if (_currentPin != "123456") {
      setState(() {
        _currentPin = "";
        _localError = "Incorrect UPI PIN entered. Please try again.";
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _localError = null;
    });

    final txId = await ref.read(transactionProvider.notifier).executePayment(
      receiverName: widget.userName,
      amount: widget.amountToPay,
      upiId: widget.upiId, 
    );

    setState(() => _isProcessing = false);

    if (txId != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionDetailsScreen(
            transactionId: txId,
            receiverName: widget.userName,
            amount: widget.amountToPay,
          ),
        ),
        (route) => route.isFirst, 
      );
    } else {
      setState(() => _localError = "Transaction rejected by core banking gateway.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat("#,##,###.00");

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ENTER 6-DIGIT UPI PIN",
          style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  height30,
                  Text(
                    "Sending money to",
                    style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 13.sp),
                  ),
                  height4,
                  Text(
                    widget.userName,
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 18.sp),
                  ),
                  height16,
                  Text(
                    "₹${currencyFormatter.format(widget.amountToPay)}",
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 36.sp, fontWeight: FontWeight.bold),
                  ),
                  height60,
                  Text(
                    "ENTER UPI PIN",
                    style: AppTextStyles.headingThemeTextStyle.copyWith(fontSize: 12.sp, letterSpacing: 1.0),
                  ),
                  height20,
                  
                  PinDotsIndicator(pinLength: _currentPin.length),
                  
                  if (_localError != null) ...[
                    height30,
                    Text(
                      _localError!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.errorTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                  
                  if (_isProcessing) ...[
                    height30,
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ]
                ],
              ),
            ),
          ),
          PinKeypad(onKeyTap: _handleKeyPress),
        ],
      ),
    );
  }
}